local b4={}; for k,v in pairs(_ENV) do b4[k]=v end
-------------------------------------------------------------------------------
--[[
In this code:
- vars are global by default unless marked with "local" or 
  defined in function argument lists.
- functions are names before they are used. Hence, these line: --]]
local COL,ROW,COLS,DATA
local update,updates, grow
local cli,coerce,csv,eg,fmt,kap,map,o,push,sort,the
--[[
- There is only one data structure: a table.
- Tables can have numeric or symbolic keys.
- Tables start and end with {}
- Global settings are stores in "the" table: --]]
the={p=2, seed=10019, best=.5, go="help"}
--[[
- For all `key=value` in `the`, a command line flag `-k X` means `value`=X
- At startup, we run  `go[the.go]`
- #t is length of the table t (and empty tables have #t==0)
- Tables can have numeric or symbolic fields.
- `for pos,x in pairs(t) do` is the same as python's 
  `for pos,x in enumerate(t) do`

In the function arguments, the following conventions usally apply:
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
--]]
-------------------------------------------------------------------------------
function ROW(t) return {cells=t, yseen=true} end
-------------------------------------------------------------------------------
function COL(n,s,      i)
  i = {n=n or 0, txt=s or ""}
  i.w = i.txt:find"-$" and -1 or 1
  if i.txt:find"[A-Z]+" then
    i.isNum = true
    i.lo =  math.huge
    i.hi = -math.huge 
  else 
    i.has={} end
  return i end

function update(col,x)
  if x ~="?" then
    col.n = col.n + 1
    if   col.isNum 
    then col.lo = math.min(col.lo,x)
         col.hi = math.max(col.hi,x)
    else col.has[x] = 1 + col.has[x] end end end

function dist(col,x,y)
  if x=="?" and y=="?" then return 1 end
  if col.isNum 
  then x,y = norm(col,x), norm(col,y)
       if x=="?" then x = y<.5 and 1 or 0 end
       if y=="?" then y = x<.5 and 1 or 0 end
       return math.abs(x - y) 
  else return x==y and 0 or 1 end end
-------------------------------------------------------------------------------
function COLS(t,     col,cols)
  cols = {names=t, all={}, x={}, y={}}
  for n,s in pairs(t) do 
    col = push(cols.all, COL(n,s))
    if not s:find"X$" then
      push(s:find"[!+-]$" and cols.y or cols.x, col) end end 
  return cols end
    
function updates(cols, row)
  for _,t in pairs{cols.x, cols.y} do
    for _,col in pairs(t) do
      update(col, row.cells[col.at]) end end
  return row end

function dists(cols,row1,row2,       d,n)
  d,n = 0,1E-32
  for _,col in pairs(cols) do
    d = d + dist(col, row1.cells[col.at], row2.cells[col.at])^the.p
    n = n + 1 end
  return (d/n)^(1/the.p) end

-------------------------------------------------------------------------------
function DATA(src,     data,fun)
  data = {rows={}, cols=nil}
  fun  = function(x) add(data,x) end
  if type(src) == "string" then csv(src,fun) else map(src or {}, fun) end
  return data end 
  
function add(data,t)
  if   data.cols 
  then push(data.rows, updates(data.cols, t.cells and t or ROW(t))) 
  else data.cols = COLS(t) end end
-------------------------------------------------------------------------------
-- Misc support functions
function fmt(sControl,...) --> str; emulate printf
  return string.format(sControl,...) end

function push(t,x) t[1+#t]=x; return x end

function sort(t, fun) --> t; return `t`,  sorted by `fun` (default= `<`)
  table.sort(t,fun); return t end

function map(t, fun,     u) --> t; map function `fun`(k,v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do u[#u+1]=fun(v); end; return u end

function kap(t, fun,     u) --> t; map function `fun`(k,v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do u[#u+1]=fun(k,v); end; return u end

function o(t,      fun)
  fun = function(k,v) if tostring(k):find"^_" then return fmt(":%s %s",k,o(v)) end end
  return type(t)~="table" and tostring(t) or
         "{"..table.concat(#t>0 and map(t,o) or sort(kap(t,fun))," ") .."}" end

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
    options[k] = coerce(v) end
  return options end

function eg(k,egs,    b4)
  if egs[k] then
    b4={}; for k,v in pairs(the) do b4[k]=v end 
    math.randomseed(the.seed)
    egs[k]() 
    for k,v in pairs(b4) do the[k]=v end end end
-------------------------------------------------------------------------------
local egs={}

egs.all= function() 
  for _,k in sort(map(egs,function(k,_) return k end)) do
    if k ~= "all" and k:sub(1,1) ~= "_" then eg(l) end end end 
-------------------------------------------------------------------------------
the=cli(the)
eg(the.go, egs) 
for k,v in pairs(_ENV) do if not b4[k] then print( fmt("#W ?%s %s",k,type(v)) ) end end 
