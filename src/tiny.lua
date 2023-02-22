local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
local is = {
      p    = 2,
      Far  = .95,
      min  = .5,
      rest = 4,
      seed =  937162211,
      file = "../etc/data/auto93.csv"}
---------------------------------------
local m    = math
local fmt  = string.format
local sort = table.sort

local function lt(x) return function(a,b) return a[x] < b[x] end end

local function any(t) return t[rint(#t)] end
local function many(t,n,    u) u={}; for i=1,n do push(u, any(t)) end; return u end 

local function push(t,x) t[1+#t]=x; return x end

local function kap(t, fun,     u) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v; end; return u end

local function map(t, fun) return kap(t, function(_,v) return fun(v) end) end

local Seed=937162211 -- seed
local function rand(nlo,nhi) -- random floats
  nlo, nhi = nlo or 0, nhi or 1
  Seed = (16807 * Seed) % 2147483647
  return nlo + (nhi-nlo) * Seed / 2147483647 end

local function rint(nlo,nhi)  -- random ints  
  return m.floor(0.5 + rand(nlo,nhi)) end

local function coerce(s,    fun) 
  fun = function(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
  return s1 end
  return m.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

local function lines(sFilename,fun,    src,s) 
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

local function csv(sFilename,fun,     cells)
  cells = function(s,    t)
    t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; return t end
  lines(sFilename, function(line) fun(cells(line)) end) end

local function o(t,    fun) 
  fun = function(k,v) return fmt(":%s %s",k,o(v)) end 
  return type(t) ~="table" and tostring(t) or 
         "{"..table.concat(#t>0  and map(t,o) or sort(kap(t,fun))," ").."}" end

local function oo(t) print(o(t)); return t end

local function cli(k,v)
  v = tostring(v)
  for n,x in ipairs(arg) do
    if x=="-"..(k:sub(1,1)) then
      v= v=="false" and "true" or v=="true" and "false" or arg[n+1] end end 
  return  coerce(v) end 
------------------------
function COL(n,s,    col)
   col = s:find"^[A-Z]" and NUM(n,s) or SYM(n,s) 
   col.isIgnored  = col.txt:find"X$"
   col.isKlass    = col.txt:find"!$"
   col.isGoal     = col.txt:find"[!+-]$"
   return col end

local function NUM(n,s) 
  return {at=n, txt=s or "", n=0, hi=-m.huge, lo=m.huge, w=(s or ""):find"-$"} end

local function SYM(n,s) 
  return {at=n, txt=s or "", n=0, has={}, isSym=true} end

local function COLS(ss,     col,cols)
  cols={names=ss, all={},x={},y={}}
  for n,s in pairs(ss) do  
    col = push(cols.all, COL(n,s))
    if not col.isIgnored and col.isKlass then cols.klass = col end
    if not col.isIgnored then push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end

local row
local function DATA(src, rows,     data,row)
  data = {rows={}, cols=nil}
  add  = function(t) row(data,t) end 
  if type(src)=="string" then csv(file, add) 
  elseif type(src)=="table" then 
    if src.rows then row(data, src.cols.names) else map(src,add) end end 
  map(rows or {}, add)
  return data end

local function add(col,x,  inc)
  if x~="?" then 
    if col.isSym then col.has[x] = (inc or 1) + (col.has[x] or 0) else 
      col.hi = m.max(x, col.hi)
      col.lo = m.min(x, col.lo) end end end 

function row(data,t)
  if data.cols then 
    push(data.rows,t)
    for _,cols in pairs{data.cols.x, data.cols.y} do
      for _,col in pairs(cols) do add(col,t[col.at]) end end
  else data.cols = COLS(t) end end

local function norm(num,n)
  return n=="?" and n or (n - num.lo)/(num.hi - num.lo + 1/m.huge) end

local function dist(data,t1,t2,  cols,    d,dist1,sym,num)
  sym = function(x,y) return x==y and 0 or 1 end
  num = function(x,y) 
    if x=="?" then x= y<.5 and 1 or 1 end	
    if y=="?" then y= x<.5 and 1 or 1 end	
    return m.abs(x-y) end 
  dist1 = function(col,x,y)
    if x=="?" and y=="?" then return 1 end
    return col.isSym and sym(x,y) or num(norm(col,x), norm(col,y)) 
  end -------------
  d, cols = 0, (cols or data.cols.x)	
  for _,col in pairs(cols) do
    d = d + dist1(col, t1[col.at], t2[col.at])^is.p end 
  return (d/#cols)^(1/is.p) end

local function around(data,t1,  rows,cols,     fun)
  fun = function(t2) return {row=t2, dist=dist(data,t1,t2,cols)} end
  return sort(map(rows and data.rows, fun),lt"dist") end
 
local function far(data,t1,  rows,cols,    tmp)
  tmp = around(data,t1,rows,cols)
  return tmp[(#tmp*is.Far) // 1].row end

local function half(data,  rows,cols,above)
  local d,proj1,cos,same,A,B,c,left,right
  d    = function(r1,r2) return dist(data,r1,r2,cols) end
  cos  = function(a,b) return (a^2 + c^2 - b^2)/(2*c) end
  proj = function(r) return {row=r, x=cos(d(r,A), d(r,B), c)} end
  rows = rows or data.cols
  some = many(rows,is.Halves)
  A    = above or any(some)
  B    = far(data,A,rows,cols)
  c    = d(A,B)
  left, right = {},{}
  for n,two in pairs(sort(map(rows,proj),lt"x")) do
    push(n <= #rows/2 and left or right, two.row) end
  return left,right,A,B,(above and 1 or 2)  end

local function better(data,row1,row2,    s1,s2,ys,x,y) 
  s1,s2,ys,x,y = 0,0,data.cols.y
  for _,col in pairs(ys) do
    x  = norm(col, row1[col.at] )
    y  = norm(col, row2[col.at] )
    s1 = s1 - m.exp(col.w * (x-y)/#ys)
    s2 = s2 - m.exp(col.w * (y-x)/#ys) end
  return s1/#ys < s2/#ys end

local function betters(data,  rows,stop,evals,    fun,best,rest)
  rows = rows or data.rows
  stop = stop or rows^is.min
  if #rows <= (#data.rows)^is.min 
  then return DATA(data,rows), DATA(data, many(worse, is.rest*#rows)), evals
  else l,r,A,B,n = half(data,rows,cols,above)
       if better(data,B,A) then l,r,A,B = r,l,B,A end
       map(r, function(row) push(worse,row) end)
       return fun(l, worse, A) end end 
  best,rest = fun(data.rows,{},0)
  return DATA(data,best), DATA(data,rest),evals end

-----------------
local function tests(      copy,ok)
  ok = {}
  for k,v in pairs(is) do copy[k]=v end
  ok = function(x) 
    print("testing",x)
    for k,v in pairs(copy) do is[k]=v end
    Seed = is.seed end
  _rand = function()
            ok("_rand") end
  _rand() end
 
  


-----------------
is = kap(is,cli)
csv(is.file,print)
