local b4={}; for k,v in pairs(_ENV) do b4[k]=v end
-------------------------------------------------------------------------------
--[[
In this code:
- vars are global by default unless marked with "local" or 
  defined in function argument lists.
- functions are names before they are used. Hence, these line: --]]
local any,cli,coerce,copy,csv,eg,fmt,kap,many,map,o,oo,obj,push,sort,the
--[[
- There is only one data structure: a table.
- Tables can have numeric or symbolic keys.
- Tables start and end with {}
- Global settings are stores in "the" table: --]]
the = {best=.5, Budget = 32,file="../etc/data/auto93.csv", go="help", p=2,seed=10019}
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
function obj(s,    t,new) --> t; create a klass and a constructor + print method
  function new(_,...) local i=setmetatable({a=s}, t); t.new(i,...); return i end
  t={}; t.__index = t;return setmetatable(t, {__call=new}) end

local COLS,DATA,NUM,ROW,SYM = obj"COLS",obj"DATA",obj"NUM",obj"ROW",obj"SYM"
-------------------------------------------------------------------------------
function ROW.new(i,t) i.cells=t; i.yseen=true end
-------------------------------------------------------------------------------
function NUM.new(i,n,s)
  i.at, i.txt, i.n = n or 0, s or "", 0
  i.w  = i.txt:find"-$" and -1 or 1
  i.lo =  math.huge
  i.hi = -math.huge end

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
  i.at, i.txt, i.n, i.has = n or 0,  s or "", 0, {} end

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
  
function DATA.dist(i,row1,row2,cols,       d,n)
  d,n = 0,1E-32
  for _,col in pairs(cols or i.cols.x) do
    d = d + col:dist(row1.cells[col.at], row2.cells[col.at])^the.p
    n = n + 1 end
  return (d/n)^(1/the.p) end

function DATA.add(i,t)
  if   i.cols 
  then t = push(i.rows, t.cells and t or ROW(t))
       i.cols:add(t)
  else i.cols=COLS(t) end end

function DATA.sort(i,row1,row2,    s1,s2,ys,x,y)
  s1,s2,ys,x,y = 0,0,i.cols.y
  for _,col in pairs(ys) do
    x  = row1.cells[col.at] 
    y  = row2.cells[col.at]  
    print("::",x,y.." ")
    x  = col:norm(x)
    y  = col:norm(y)
    s1 = s1 - math.exp(col.w * (x-y)/#ys)
    s2 = s2 - math.exp(col.w * (y-x)/#ys) end
  print(s1,s2,x,y)
  return s1/#ys < s2/#ys end

function DATA.sorts(i)
  return sort(i.rows, function(a,b) return i:sort(a,b) end) end

function DATA.learn(i,      some)
  some = many(i.rows, the.samples)
  for j=1,#some do
    for k=j+1,#some do
      row1,row2 = some[j], some[k]
      print(o(row1.cells), o(row2.cells),2, i:dist(row1,row2,i.cols.y)) end end end 
-------------------------------------------------------------------------------
-- Misc support functions
function fmt(sControl,...) --> str; emulate printf
  return string.format(sControl,...) end

function any(t) return t[math.random(#t)] end
function many(t,n,    u) u={}; for _=1,n do u[1+#u]= any(t) end; return u end

function push(t,x) t[1+#t]=x; return x end

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
  fun = function(k,v) if not tostring(k):find"^_" then return fmt(":%s %s",k,o(v)) end end
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
egs.norm=function(      data,rows)
  data=DATA(the.file)
  for i=1,10 do 
    row = any(data.rows)
    for _,col in pairs(data.cols.x) do
      x = row.cells[col.at]
      print(x, col:norm(x))  end end end 

egs.sort=function(      data,rows)  
  data=DATA(the.file)
  rows = data:sorts()
  oo(data.cols.names)
  for i=1,#data.rows,32 do oo(rows[i].cells)  end end
-------------------------------------------------------------------------------
the=cli(the)
eg(the.go, egs) 
for k,v in pairs(_ENV) do if not b4[k] then print( fmt("#W ?%s %s",k,type(v)) ) end end 
