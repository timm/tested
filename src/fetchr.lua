local b4={}; for k,v in pairs(_ENV) do b4[k]=v end -- lua trivia (used to find rogue locals)
local push,map,kap,sort
local coerce, csv
local the={p=2,far=.95, sample=256}

function SYM(n,s)
  return {at=n, txt=s,seen={}} end

function NUM(n,s)
  return {isNum=true, lo=math.huge, hi=-math.huge, at=n or 0, txt=s or 0,
          w=(s or ""):find"-$" and -1 or 1 } end

function COLS(row,     col)
  cols={names=row, all={},x={},y={}}
  for n,s in pairs(row) do  
    col = s:find"^[A-Z]+" and NUM(n,s) or SYM(n,s)
    push(cols.all, col)
    if not s:find"X$" then
      if s:find"!$" then cols.klass = col end
      push(s:find"[!+-]$" and cols.y or cols.x, col) end end 
  return cols end

function DATA(src,    data)
  data={rows={}}
  if type(src)=="string" 
  then csv(src,       function(row)   adds(data,row) end)
  else map(src or {}, function(_,row) adds(data,row) end) end
  return data end

function adds(data,row)
  if data.cols then
    push(data.rows,row)
    for _,col in pairs{data.cols.x, data.cols.y} do
      for _,col in pairs(cols) do
        add(col, row[col.at]) end end 
  else data.cols = COLS(row) end end  
        
function add(col,x)
  if x == "?" then return x end
  if col.isNum then
    col.lo = math.min(x,col.lo)
    col.hi = math.max(x,col.hi)  
  else col.seen[x] = true end

function dists(data,row1,row2,  cols,     n,d)
  n,d = 0,0
  for _,col in pairs(cols or data.cols.x) do
    n = n + 1
    d = d + col:dist(row1[col.at], row2[col.at])^the.p end
  return (d/n)^(1/the.p) end

function far(data,row1,  rows,cols)
   rows = sort(map(rows or i.rows, function(row2) 
	    return {row=row2, dist=dist(data,row1,row2,cols)} end),lt"dist") end
   return rows[(the.Far * #rows)//1].row end

function dist(col,x,y)
  if x=="?" and y=="?"then return 1 e
  elseif col.isNum then 
    x,y = norm(col,x), norm(col,y)
    if x=="?" then x= y<.5 and 1 or 0 end
    if y=="?" then y= x<.5 and 1 or 0 end
    return math.abs(x-y)
  else return x==y and 0 or 1 end end
 
function norm(num,x)
  return x=="?" and x or (x-col.lo)/(col.hi - col.lo +1E-32)  end
------------------------------------------------------   
function copy(t,    u) --> t; deep copy
  if type(t) ~= "table" then return t  
  else u={}; for k,v in pairs(t) do u[k]=copy(v) end; return u end

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
    then t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t]=coerce(s1) end; fun(t)
    else return io.close(src) end end end

function o(t,    fun) --> s; convert `t` to a string. sort named keys. 
  if type(t)~="table" then return tostring(t) end
  fun= function(k,v) return nil,string.format(":%s %s",k,o(v)) end 
  return "{"..table.concat(#t>0  and map(t,o) or sort(kap(t,fun))," ").."}" end

function cli(options) --> t; update key,vals in `t` from command-line flags
  for k,v in pairs(options) do
    v=tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) then
         v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    options[k] = coerce(v) end  end

function main(funs,settings,    fails,saved)
  cli(settings)
  fails,saved = 0,copy(settings)
  for name,fun in pairs(funs) do
    if settings.go =="all" or settings.go==name then
      for k,v in pairs(saved) do setings[k]=v end
      Seed = settings.seed
      if fun()==false then print("FAIL",name); fails=fail+1
	                   print("PASS",name) end end
  for k,v in pairs(_ENV) do -- LUA trivia. Looking for rogue locals
    if not b4[k] then print( string.formant("#W ?%s %s",k,type(v)) ) end end 
  os.exit(fails) end  

eg={}
function eg.the() print(o(the)) end
main(egs,the)
