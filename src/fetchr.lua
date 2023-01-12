local b4={}; for k,v in pairs(_ENV) do b4[k]=v end -- lua trivia (used to find rogue locals)
local add,cli,coerce,copy,csv,dist,half,kap,lt,main,map
local norm,o,csv,push,record,sort 
local COL, SYM, NUM, COLS, DATA, ROW
local the, help = {}, [[
fetchr : find a rule to fetch good rows, after peeking at just a few rows
(c) 2023 Tim Menzies <timm@ieee.org> BSD-2 license (t.ly/74ji)

OPTIONS:
  -b --budget   max peeking budget           = 20
  -p  --p       distance coefficient         = 2
  -F  --Far     how far is long distances    = .95
  -s  --seed    random number seed           = 10029
  -S  --Sample  search space for clustering  = 512
]]
 --------------------------------------------------------------------------
-- ## Columns
function COL(n,s,    col)
  col = (s:find"^[A-Z]+" and NUM or SYM)(n,s)
  col.isIgnored = col.txt:find"X$"
  col.isKlass   = col.txt.find"!$"
  col.isGoal    = col.txt.find"[!+-]$"
  return col end

function SYM(n,s)
  return {at=n, txt=s,seen={}} end

function NUM(n,s)
  return {isNum=true, lo=math.huge, hi=-math.huge, at=n or 0, txt=s or "",
          w=(s or ""):find"-$" and -1 or 1 } end

function norm(num,x)
  return x=="?" and x or (x-col.lo)/(col.hi - col.lo +1E-32)  end

function add(col,x)
  if x == "?" then return x end
  if col.isNum then
    col.lo = math.min(x,col.lo)
    col.hi = math.max(x,col.hi)  
  else col.seen[x] = true end end

-- ## Factory for Making Columns
function COLS(row,     cols,col)
  cols={names=row, all={}, x={}, y={}}
  for n,s in pairs(row) do  
    col = push(cols.all, COL(n,s))
    if not col.isIgnored then
      if col.isKlass then cols.klass = col end
      push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end

-- ## Row
function ROW(t) return {cells=t} end

-- ## Data
function DATA(src,    data,fun)
  data = {rows={}}
  function fun(row) record(data,row) end 
  if type(src)=="string" then csv(src,fun) else map(src or {},fun) end
  return data end

function record(data,row)
  if data.cols then
    row = push(data.rows, row.cells and row or ROW(row))
    for _,col in pairs{data.cols.x, data.cols.y} do
      for _,col in pairs(cols) do
        add(col, row.cells[col.at]) end end 
  else data.cols = COLS(row) end end  
        
function dist(data,row1,row2,  cols)
  local n,d,dist1 = 0,0
  function dist1(col,x,y)
    if x=="?" and y=="?"then return 1 
    elseif col.isNum then 
      x, y = norm(col,x), norm(col,y)
      if x=="?" then x= y<.5 and 1 or 0 end
      if y=="?" then y= x<.5 and 1 or 0 end
      return math.abs(x-y)
    else return x==y and 0 or 1 end  
  end ------------------------------
  for _,col in pairs(cols or data.cols.x) do
    n = n + 1
    d = d + dist1(row1.cells[col.at], row2.cells[col.at])^the.p end
  return (d/n)^(1/the.p) end

function half(data,rows,  cols,above)
  local left,right,far,gap,some,proj,tmp,A,B,c = {},{}
  function gap(r1,r2) return dist(data, r1, r2, cols) end
  function proj(r)    return {row=r, dist=(gap(r,A)^2 + c^2 - gap(r,B)^2)/(2*c)} end
  rows = rows or data.rows
  some = many(rows, the.Sample)
  A    = above or any(some)
  tmp  = sort(map(some, function(r) return {row=r,dist=gap(A,r)} end),lt"dist") 
  far  = tmp[(#tmp*the.Far)//1] 
  B,c  = far.row, far.dist
  for n,tmp in pairs(sort(map(rows,proj), lt"dist")) do
    push(n <= (rows//2) and left or right, tmp.row) end
  return left, right, A, B, c end  
-------------------------------------------------------------------------
function copy(t,    u) --> t; deep copy
  if type(t) ~= "table" then return t end 
  u={}; for k,v in pairs(t) do u[k]=copy(v) end; return u end 

function sort(t, fun) --> t; return `t`,  sorted by `fun` (default= `<`)
  table.sort(t,fun); return t end

function lt(x) --> fun;  return a function that sorts ascending on `x`
  return function(a,b) return a[x] < b[x] end end

function push(t, x) --> any; push `x` to end of list; return `x` 
  table.insert(t,x); return x end

function map(t, fun,     u) --> t; map a function `fun`(v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do v,k=fun(v); u[k or (1+#u)]=v end;  return u end
 
function kap(t, fun,     u) --> t; map function `fun`(k,v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v; end; return u end

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
    then t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; fun(t)
    else return io.close(src) end end end

function o(t,    fun) --> s; convert `t` to a string. sort named keys. 
  if type(t)~="table" then return tostring(t) end
  fun= function(k,v) return string.format(":%s %s",k,o(v)) end 
  return "{"..table.concat(#t>0  and map(t,o) or sort(kap(t,fun))," ").."}" end

function cli(options,txt) --> t; update key,vals in `t` from command-line flags
  txt:gsub("\n[%s]+([-][%S])[%s]+[-][-]([%S]+)[^\n]+= ([%S]+)",function(flag,k,v) 
    print(flag)
    for n,x in ipairs(arg) do
      if x==flag then
        v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    options[k] = coerce(v) end) end

function main(funs,settings,txt,    fails,saved)
  cli(settings,txt)
  fails,saved = 0,copy(settings)
  if settings.help then print(txt) else
    for name,fun in pairs(funs) do
      if settings.go =="all" or settings.go==name then
        for k,v in pairs(saved) do setings[k]=v end
        Seed = settings.seed
        if fun()==false then print("❌ FAIL",name); fails=fail+1
	                           print("✅ PASS",name) end end end end
  for k,v in pairs(_ENV) do -- LUA trivia. Looking for rogue locals
    if not b4[k] then print( string.format("#W ?%s %s",k,type(v)) ) end end 
  os.exit(fails) end  
-------------------------------------------------------------------------
local egs={}
function egs.show()  print(o(the)) end
function egs.maths() print(10 + 10) end
-------------------------------------------------------------------------
main(egs,the,help)
