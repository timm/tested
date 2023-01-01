local b4={}; for k,v in pairs(_ENV) do b4[k]=v end
local the,help={},[[  
fish1,lua : sort many <X,Y> things on Y, after peeking at just a few Y things
(c)2022 Tim Menzies <timm@ieee.org> BSD-2

Note: fish1 is just a demonststraing of this kind of processing.
It is designed to be incomplete, to have flaws. If you look at this
case say say "a better way to do this wuld be XYZ", then fish1 has
been successful.

USAGE: lua fish1.lua [OPTIONS] [-g [ACTIONS

OPTIONS:
  -b  --budget  number of evaluations = 16
  -f  --file    csv data file         = ../etc/data/auto93.csv
  -g  --go      start up action       = ls
  -h  --help    show help             = false
  -p  --p       distance coefficient  = 2
  -s  --seed    random number seed    = 10019

ACTIONS:
]] 
-------------------------------------------------------------------------------
--[[
In this code:
- vars are global by default unless marked with "local" or 
  defined in function argument lists.
- functions are names before they are used. Hence, these line: --]]
local any,cli,coerce,copy,csv,fmt,gt,kap,keys,lt
local main,many,map,o,oo,obj,percent,push,settings,shuffle,slice,sort
  --[[
- There is only one data structure: a table.
- Tables can have numeric or symbolic keys.
- Tables start and end with {}
- Global settings are stores in "the" table which is generated from
  "help". E.g. from the above the.budget =16
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
- Four spaces denote start of local args.  

In my object system, instances are named `i` (since that is shorter than `self`)--]]

-------------------------------------------------------------------------------
local id=0
function obj(s,    t,new) --> t; create a klass and a constructor + print method
  function new(_,...) id=id+1; local i=setmetatable({a=s,id=id}, t); t.new(i,...); return i end
  t={}; t.__index = t;return setmetatable(t, {__call=new}) end

local COLS,DATA,NUM,ROW,SYM = obj"COLS",obj"DATA",obj"NUM",obj"ROW",obj"SYM"
------------------------------------------------------------------------------
function ROW.new(i,t) i.cells=t; i.yseen=false; i.rank=0; i.guess=0 end
-------------------------------------------------------------------------------
function NUM.new(i,n,s)
  i.at, i.txt = n or 0, s or ""
  i.w  = i.txt:find"-$" and -1 or 1
  i.lo =  math.huge
  i.hi = -math.huge 
  i.good, i.bad, i.score = {},{},{} end

function NUM.includes(i,x)
  if x ~="?" then 
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
  i.at, i.txt, i.has = n or 0,  s or "", {} 
  i.good, i.bad, i.score = {},{},{} end

function SYM.includes(i,s)
  if x ~="?" then 
    i.has[s] = true end end

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
    
function COLS.includes(i,row)
  for _,t in pairs{i.x} do
    for _,col in pairs(t) do
      col:includes(row.cells[col.at]) end end end
-------------------------------------------------------------------------------
function DATA.new(i,src,     data,fun)
  i.rows, i.cols = {}, nil
  fun = function(x) i:includes(x) end
  if type(src) == "string" then csv(src,fun) else map(src or {}, fun) end end
  
function DATA.includes(i,t)
  if   i.cols 
  then t = push(i.rows, ROW(t.cells and t.cells or t))
       i.cols:includes(t)
  else i.cols=COLS(t) end end

function DATA.clone(i,  init,     data)
  data=DATA({i.cols.names})
  map(init or {}, function(x) data:includes(x) end)
  return data end

function DATA.dist(i,row1,row2,cols,       d,n)
  d,n = 0,1E-32
  for _,col in pairs(cols or i.cols.x) do
    d = d + col:dist(row1.cells[col.at], row2.cells[col.at])^the.p
    n = n + 1 end
  return d^(1/the.p)/n^(1/the.p) end

function DATA.sort(i,row1,row2,    s1,s2,ys,x,y)
  s1,s2,ys,x,y = 0,0,i.cols.y
  for _,col in pairs(ys) do
    x  = row1.cells[col.at]; if not row1.yseen then col:includes(x) end; x = col:norm(x)
    y  = row2.cells[col.at]; if not row2.yseen then col:includes(y) end; y = col:norm(y)
    s1 = s1 - math.exp(col.w * (x-y)/#ys)
    s2 = s2 - math.exp(col.w * (y-x)/#ys) end
  row1.yseen = true
  row2.yseen = true
  return s1/#ys < s2/#ys end

function DATA.truth(i,  rows,t)
  t = sort(rows or i.rows, function(a,b) return i:sort(a,b) end)
  for truth,row in pairs(t) do 
    row.truth = math.floor(100*truth/#i.rows) end 
  return t end

function DATA.learn(i,  quiet,rows,     now,after)
  rows = shuffle(rows or i.rows)
  now, after ={},{}
  for j,row in pairs(rows) do
    push(j<=the.budget and now or after,row) end
  i:reinforce(quiet,now) 
  return i:guess(after) end

function DATA.reinforce(i,quiet,  rows,x,xgap,ygap,n,b,G,B)
  local row1,row2,tmp,x,y 
  rows = rows or i.rows
  n=0
  -- count good and bad for each column attribute
  for j=1,#rows do
    for k=j+1,#rows do
      n=n+1 -- number of comparisons
      row1,row2 = rows[j],rows[k]
      ygap = i:dist(row1,row2,i.cols.y)
      xgap = i:dist(row1,row2,i.cols.x)
      if i:sort(row2,row1) then row1,row2 = row2,row1 end
      for _,col in pairs(i.cols.x) do
        x,y = row1.cells[col.at], row2.cells[col.at]
        if x ~= y and x ~= "?" and y ~= "?" then
          col.bad[y]   = (col.bad[y]  or 0) + (ygap/xgap) -- suggested by RELIEF https://en.wikipedia.org/wiki/Relief_(feature_selection) 
          col.good[x]  = (col.good[x] or 0) + (ygap/xgap)--gap
          end end end end 
  -- combine goods and bads into "score"
  for _,col in pairs(i.cols.x) do
    col.good = percent(col.good,1/n)  -- normalize
    col.bad = percent(col.bad,1/n)  -- normalize 
    for k,g in pairs(col.good) do
       b= col.bad[k]  or 1e-31
       G = g/(g+b)
       B = b/(g+b)
       col.score[k] = G/(G+B) end -- suggested by Tarantula. see table1 of http://shorturl.at/prAP1
    if not quiet then print(col.txt, o(col.score,true)) end end  end

function DATA.guess(i,  rows,x)
  for _,row in pairs(rows or i.rows) do
    for _,col in pairs(i.cols.x) do
      x = row.cells[col.at]
      if x~="?" then
        row.guess = row.guess + (col.score[x] or 0) end end end 
  return slice(sort(rows, gt"guess"),1,the.budget) end
-------------------------------------------------------------------------------
-- Misc support functions
function fmt(sControl,...) --> str; emulate printf
  return string.format(sControl,...) end

function percent(t,n,     tmp)
  n=n or 1
  for k,v in pairs(t) do t[k]=t[k]*n end
  tmp=0; for _,v in pairs(t) do tmp=tmp+v end
  for k,v in pairs(t) do t[k] = v/tmp end 
  return t end

function any(t) return t[math.random(#t)] end 
function many(t,n,    u) print("n",n) u={}; for i=1,n do u[1+#u]=any(t) end; return u end

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

function keys(t)
  return sort(kap(t, function(k,_) return k end)) end

-- Note the following conventions for `map`.
-- - If a nil first argument is returned, that means :skip this result"
-- - If a nil second argument is returned, that means place the result as position size+1 in output.
-- - Else, the second argument is the key where we store function output.
function map(t, fun,     u) --> t; map a function `fun`(v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do v,k=fun(v); u[k or (1+#u)]=v end;  return u end
 
function kap(t, fun,     u) --> t; map function `fun`(k,v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v; end; return u end

function copy(t) --> t; return a shallow copy of `t.
  return {table.unpack(t)} end

function oo(t) print(o(t)); return t end
function o(t,flag,     fun)
  if type(t)~="table" then return tostring(t) end
  fun= function(k,v) if not tostring(k):find"^_" then return fmt(":%s %s",o(k),o(v)) end end
  return "{"..table.concat(#t>0 and not flag and map(t,o) or sort(kap(t,fun))," ").."}" end

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

function settings(s,    t) --> t;  parse help string to extract a table of options
  t={};s:gsub("\n[%s]+[-][%S]+[%s]+[-][-]([%S]+)[^\n]+= ([%S]+)",function(k,v) t[k]=coerce(v) end)
  return t end

function cli(options) --> t; update key,vals in `t` from command-line flags
  for k,v in pairs(options) do
    v=tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
         v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    options[k] = coerce(v) end 
  return options end

function main(options,help,funs,     k,old,fails) 
  old,fails={},0
  for k,v in pairs(cli(settings(help))) do options[k] = v end 
  if options.help then print(help) else 
    for k,v in pairs(options) do old[k]=v end
    k=options.go
    for k,fun in pairs(funs) do
      if options.go=="all" or k==options.go then
         for k,v in pairs(old) do options[k]=v end
         math.randomseed(options.seed)
         if funs[k]()=="false" then fails=fails+1
                                    print("❌ fail:",k) end end end end
  for k,v in pairs(_ENV) do 
    if not b4[k] then print( fmt("#W ?%s %s",k,type(v)) ) end end 
  os.exit(fails) end 
-------------------------------------------------------------------------------
local egs={}
local function eg(key,str, fun)
  egs[key]=fun
  help=help..fmt("  -g  %s\t%s\n",key,str) end

eg("ls",    "list all",           function() print(help) end)
eg("the",   "show settings",      function() oo(the) end)
eg("num",   "can NUMs be built?", function() oo(NUM()) end)
eg("sym",   "can SYMs be built?", function() oo(SYM()) end)
eg("data",  "can we load data from disk?", function() map(DATA(the.file).cols.x,oo) end)
eg("clone", "can we cline data?",function() 
  local data1,data2
  data1 = DATA(the.file)
  data2 = data1:clone(data1.rows)
  map(data1.cols.y,oo)
  print""
  map(data2.cols.y,oo)
  print""
  oo(data1.rows[1])
  oo(data2.rows[1])
end)

eg("norm", "does data normalization work?",function(      data,rows,row,x)
  data=DATA(the.file)
  for i=1,10 do 
    row = any(data.rows)
    for _,col in pairs(data.cols.x) do
      x = row.cells[col.at]
      print(x, col:norm(x))  end end end )

eg("eg","can i sort examples?", function(      data,rows)  
  data=DATA(the.file)
  rows = data:truth()
  oo(data.cols. names)
  for i=1,#data.rows,32 do oo(rows[i].cells)  end end)

eg("learn", "can i sort with minimal data?",function(      data0,data,rows)  
  data0=DATA("../etc/data/nasa93demd.csv")
  data=data0:clone(data0.rows)
  data:truth()
  for k,row in pairs(sort(data:learn(false),lt"truth")) do
    print(k,row.truth, row.guess,o(row.cells)) end 
  print("+","=====","=====","=====")
  print("#","truth","guess","cells")
  oo(data.cols.names)
  oo{seed=the.seed, budget=the.budget}
  end )

eg("learnssum", "can i sort with minimal data?",function(      data0,data,rows)  
  data0=DATA("../etc/data/nasa93demd.csv")
  local out={}
  for j=1,20 do
    data=data0:clone(data0.rows)
    data:truth()
    out[j]=map(sort(data:learn(true),lt"truth") ,
               function(r) return r.truth end)
  end 
  for _,b in pairs{1,5,10} do 
    local tmp={}
    for j=1,20 do push(tmp,out[j][b]) end 
    sort(tmp)
    print("|",the.budget,"|",b,"|",tmp[5],"|",tmp[10],"|", tmp[15],"|") end 
  end)
-------------------------------------------------------------------------------
main(the,help,egs) 
