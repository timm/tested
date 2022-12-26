local b4={}; for k,v in pairs(_ENV) do b4[k]=v end
-------------------------------------------------------------------------------
--[[
In this code:
- vars are global by default unless marked with "local" or 
  defined in function argument lists.
- functions are names before they are used. Hence, these line: --]]
local any,cli,coerce,copy,csv,eg,fmt,gt,kap,lt
local many,map,o,oo,obj,push,shuffle,slice,sort,the
--[[
- There is only one data structure: a table.
- Tables can have numeric or symbolic keys.
- Tables start and end with {}
- Global settings are stores in "the" table: --]]
the = {best   = .5, 
       Budget = 16,
       file   = "../etc/data/auto93.csv", 
       go     =  "help", 
       p      = 2,
       seed   = 10019}
--[[
- For all `key=value` in `the`, a command line flag `-k X` means `value`=X
- At startup, we run `go[the.go]`
- #t is length of the table t (and empty tables have #t==0)
- Tables can have numeric or symbolic fields.
- `for pos,x in pairs(t) do` is the same as python's 
  `for pos,x in enumerate(t) do`

In the function arguments, the following conventions apply (usually):
- n == number
- s == string
- t == table
- is == boolean
- x == anything
- fun == function
- UPPER = class
- lower = instance; e.g. rx is an instance of RX
- xs == a table of "x"; e.g. "ns" is a list of numbers
- Two spaces denote start of optional args
- Four spaces denote start of local args.  --]]
-------------------------------------------------------------------------------
local id=0
function obj(s,    t,new) --> t; create a klass and a constructor + print method
  function new(_,...) id=id+1; local i=setmetatable({a=s,id=id}, t); t.new(i,...); return i end
  t={}; t.__index = t;return setmetatable(t, {__call=new}) end

local COLS,DATA,NUM,ROW,SYM = obj"COLS",obj"DATA",obj"NUM",obj"ROW",obj"SYM"
-------------------------------------------------------------------------------
function ROW.new(i,t) i.cells=t; i.yseen=false; i.rank=0; i.guess=0 end
-------------------------------------------------------------------------------
function NUM.new(i,n,s)
  i.at, i.txt, i.n = n or 0, s or "", 0
  i.w  = i.txt:find"-$" and -1 or 1
  i.lo =  math.huge
  i.hi = -math.huge 
  i.good, i.bad, i.score = {},{},{} end

function NUM.add(i,x)
  if x ~="?" then 
    i.n  = i.n + 1
    i.lo = math.min(i.lo,x)
    i.hi = math.max(i.hi,x) end end

function NUM.dist(i,n1,n2)
  if n1=="?" and n2=="?" then return 1 end
  n1,n2 = i:norm(n1), i:norm(n2)
  if n1=="?" then n1 = n2<.5 and 1 or 0 end
  if n2=="?" then n2 = n1<.5 and 1 or 0 end
  return math.abs(n1 - n2) end 

function NUM.norm(i,n)
  return n == "?" and n  or (n - i.lo)/(i.hi - i.lo + 1E-32) end
-------------------------------------------------------------------------------
function SYM.new(i,n,s)
  i.at, i.txt, i.n, i.has = n or 0,  s or "", 0, {} 
  i.good, i.bad, i.score = {},{},{} end

function SYM.add(i,s)
  if x ~="?" then 
    i.n = i.n + 1
    i.has[s] = 1 + (i.has[s] or 0) end end 

function SYM.dist(i,s1,s2)
  return s1=="?" and s2=="?" and 1 or (s1==s2) and 0 or 1 end 

function SYM.norm(i,x) return x end
-------------------------------------------------------------------------------
function COLS.new(i,t,     col,cols)
  i.names, i.all, i.x, i.y = t, {}, {}, {}
  for n,s in pairs(t) do 
    col = push(i.all, s:find"^[A-Z]+" and NUM(n,s) or SYM(n,s))
    if not s:find"X$" then
      push(s:find"[!+-]$" and i.y or i.x, col) end end end
    
function COLS.add(i,row)
  for _,t in pairs{i.x, i.y} do
    for _,col in pairs(t) do
      col:add(row.cells[col.at]) end end end
-------------------------------------------------------------------------------
function DATA.new(i,src,     data,fun)
  i.rows, i.cols = {}, nil
  fun = function(x) i:add(x) end
  if type(src) == "string" then csv(src,fun) else map(src or {}, fun) end end
  
function DATA.add(i,t)
  if   i.cols 
  then t = push(i.rows, ROW(t.cells and t.cells or t))
       i.cols:add(t)
  else i.cols=COLS(t) end end

function DATA.clone(i,  init,     data)
  data=DATA({i.cols.names})
  map(init or {}, function(x) data:add(x) end)
  return data end

function DATA.dist(i,row1,row2,cols,       d,n)
  d,n = 0,1E-32
  for _,col in pairs(cols or i.cols.x) do
    d = d + col:dist(row1.cells[col.at], row2.cells[col.at])^the.p
    n = n + 1 end
  return d^(1/the.p)/n^(1/the.p) end

function DATA.sort(i,row1,row2,    s1,s2,ys,x,y)
  row1.yseen = true
  row2.yseen = true
  s1,s2,ys,x,y = 0,0,i.cols.y
  for _,col in pairs(ys) do
    x  = col:norm(row1.cells[col.at] )
    y  = col:norm(row2.cells[col.at]  )
    s1 = s1 - math.exp(col.w * (x-y)/#ys)
    s2 = s2 - math.exp(col.w * (y-x)/#ys) end
  return s1/#ys < s2/#ys end

function DATA.truth(i,  rows,t)
  t = sort(rows or i.rows, function(a,b) return i:sort(a,b) end)
  for truth,row in pairs(t) do 
    row.truth = math.floor(100*truth/#i.rows) end 
  return t end

function DATA.learn(i,  rows)
  local now, after, rows = {}, {}, rows or i.rows
  for j,row in pairs(rows) do 
    push(j<=the.Budget and now or after, row) end
  i:reinforce(now) 
  return i:guess(after) end

function DATA.reinforce(i,  rows)
  local row1,row2,gap,tmp,x,y 
  rows = rows or i.rows
  for j=1,#rows do
    for k=j+1,#rows do
      row1,row2 = rows[j], rows[k]
      gap       = i:dist(row1, row2, i.cols.y)
      row1,row2 = rows[j],rows[k]
      if i:sort(row2,row1) then row1,row2 = row2,row1 end
      for _,col in pairs(i.cols.x) do
        x,y = row1.cells[col.at], row2.cells[col.at]
        --print(j,k,row1.id,row2.id,x,y)
        if x ~= y and x ~= "?" and y ~= "?" then
          col.bad[y]   = (col.bad[y]  or 0) + gap 
          col.good[x]  = (col.good[x] or 0) + gap
          col.score[y] = (col.good[y] or 1E-31)/col.bad[y] 
          col.score[x] = col.good[x]/(col.bad[x] or 1E-31) end end end end 
  for _,col in pairs(i.cols.x) do
    tmp=0; for k,v in pairs(col.score) do tmp = tmp + col.score[k] end
    for k,v in pairs(col.score) do 
      col.score[k] = (col.score[k] or 1E-31)/tmp  end end end

function DATA.guess(i,  rows)
  for _,row in pairs(rows or i.rows) do
    for _,col in pairs(i.cols.x) do
      x = row.cells[col.at]
      if x~="?" then
        row.guess = row.guess + (col.score[x] or 0) end end end 
  return sort(rows, gt"guess") end
-------------------------------------------------------------------------------
-- Misc support functions
function fmt(sControl,...) --> str; emulate printf
  return string.format(sControl,...) end

function any(t) return t[math.random(#t)] end 

function shuffle(t,   j) --> t;  Randomly shuffle, in place, the list `t`.
  for i=#t,2,-1 do j=math.random(i); t[i],t[j]=t[j],t[i] end; return t end

function slice(t, go, stop, inc,    u) --> t; return `t` from `go`(=1) to `stop`(=#t), by `inc`(=1)
  if go   and go   < 0 then go=#t+go     end
  if stop and stop < 0 then stop=#t+stop end
  u={}; for j=(go or 1)//1,(stop or #t)//1,(inc or 1)//1 do u[1+#u]=t[j] end; return u end

function push(t,x) t[1+#t]=x; return x end

function lt(x) return function(a,b) return a[x] < b[x] end end
function gt(x) return function(a,b) return a[x] > b[x] end end

function sort(t, fun) --> t; return `t`,  sorted by `fun` (default= `<`)
  table.sort(t,fun); return t end

function map(t, fun,     u) --> t; map function `fun`(k,v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do u[#u+1]=fun(v); end; return u end

function kap(t, fun,     u) --> t; map function `fun`(k,v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do u[#u+1]=fun(k,v); end; return u end

 function copy(t) --> t; return a deep copy of `t.
  return {table.unpack(t)} end

function oo(t) print(o(t)); return t end
function o(t,     fun)
  fun = function(k,v) if not tostring(k):find"^_" then return fmt(":%s %s",o(k),o(v)) end end
  return type(t)~="table" and tostring(t) or (
         "{"..table.concat(#t>0 and map(t,o) or sort(kap(t,fun))," ") .."}") end

function coerce(s,    fun) --> any; return int or float or bool or string from `s`
  function fun(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function csv(sFilename,fun,    src,s,t) --> nil; call `fun` on rows (after coercing cell text)
  src,s,t  = io.input(sFilename)
  while true do
    s = io.read()
    if   s
    then t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t]=coerce(s1) end; fun(t)
    else return io.close(src) end end end

function cli(options) --> t; update key,vals in `t` from command-line flags
  for k,v in pairs(options) do
    v=tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
         v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    options[k] = coerce(v)  end
  return options end

function eg(k,funs,    b4)
  if funs[k] then 
    b4=copy(the); math.randomseed(the.seed); funs[k](); the=copy(b4) end end 
-------------------------------------------------------------------------------
local egs={}

egs.all= function() 
  for _,k in sort(kap(egs,function(k,_) return k end)) do
    if k ~= "all" then eg(l) end end end 

egs.num= function() oo(NUM()) end
egs.sym= function() oo(SYM()) end
egs.data=function() map(DATA(the.file).cols.x,oo) end
egs.clone=function() 
  local data1,data2
  data1 = DATA(the.file)
  data2 = data1:clone(data1.rows)
  map(data1.cols.y,oo)
  print""
  map(data2.cols.y,oo)
  print""
  oo(data1.rows[1])
  oo(data2.rows[1])
end

egs.norm=function(      data,rows,row,x)
  data=DATA(the.file)
  for i=1,10 do 
    row = any(data.rows)
    for _,col in pairs(data.cols.x) do
      x = row.cells[col.at]
      print(x, col:norm(x))  end end end 

egs.sort=function(      data,rows)  
  data=DATA(the.file)
  rows = data:truth()
  oo(data.cols. names)
  for i=1,#data.rows,32 do oo(rows[i].cells)  end end

egs.learn=function(      data,rows)  
  data=DATA("../etc/data/nasa93demd.csv")
  data:truth()
  oo(data.cols.names)
  for k,row in pairs((data:learn())) do
    if k <= the.Budget then print(row.truth, row.guess,o(row.cells)) end end
  print(math.random(100))
end 
  --for k,row in pairs(data:learn()) do print(row.truth)  end end 
-------------------------------------------------------------------------------
the=cli(the)
eg(the.go, egs) 
for k,v in pairs(_ENV) do if not b4[k] then print( fmt("#W ?%s %s",k,type(v)) ) end end 
