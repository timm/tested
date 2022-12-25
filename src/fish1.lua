local b4={}; for k,v in pairs(_ENV) do b4[k]=v end
local the={seed=1, best=.5, go="help"}
-------------------------------------------------------------------------------
local COL,COLS
local adds,add
local cli,coerce,csv,eg,fmt,map,o,push,sort
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

function add(col,x)
  if x ~="?" then
    col.n = col.n + 1
    if   col.isNum 
    then col.lo = math.min(col.lo,x)
         col.hi = math.max(col.hi,x)
    else col.has[x] = 1 + col.has[x] end end end
-------------------------------------------------------------------------------
function ROW(t) return {cells=t, yseen=true} end
-------------------------------------------------------------------------------
function COLS(t,     col,cols)
  cols = {names=t, all={}, x={},y={}}
  for n,s in pairs(t) do 
    col = push(cols.all, COL(n,s))
    if not s:find"X$" then
      push(s:find"[!+-]$" and cols.y or cols.x, col) end end 
  return cols end
    
function adds(cols, row)
  for _,col in pairs(cols.x) do add(col, row.cells[col.at]) end 
  for _,col in pairs(cols.y) do add(col, row.cells[col.at]) end 
  return t end

function DATA(src,     data)
  data = {rows={}, cols=nil}
  if   type(src) == "string" 
  then csv(src,       function(x) update(data,x) end)
  else map(src or {}, function(x) update(data,x) end) end
  return data end 
  
function update(data,t)
  if   data.cols 
  then push(data.rows, adds(data.cols, t.cells and t or ROW(t))) 
  else data.cols = COLS(t) end end
-------------------------------------------------------------------------------
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
  if type(t)~="table" then return tostring(t) end
  fun=function(k,v) if k:find"^_" then return fmt(":%s %s",k,o(v)) end end
  return "{"..table.concat(#t>0 and map(t,o) or sort(kap(t,fun))," ") .."}" end

function coerce(s,    fun) --> any; return int or float or bool or string from `s`
  function fun(s1)
    if s1=="true"  then return true  end
    if s1=="false" then return false end
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
