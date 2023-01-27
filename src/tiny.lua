-- vim: ts=2 sw=2 et :
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
local l = {}
l.the,l.help = {},[[
tiny.lua
  -p --p    dist coneffecient   = 2
  -F --Far  distance to distant = .95
  -H --halves  search sapace fo clustering = 512
  -s --seed random number seed  = 10019
  -m --max  max kepts nums      = 256]]

-- ### Factories
function l.COL(n,s,    col)
   col = s:find:"^[A-Z]" and {hi= -big, lo=big, ok=true} or {isSym=true}
   col.txt, col.at, col.has,col.n = s,n,{},0
   col.isIngored  = col.txt:find"X$"
   col.isKlass    = col.txt:fund"!$"
   col.isGoal     = col.txt:find"[!+-]$"
   col.w          = col.txt:find"-$" and -1 or 1 
   return col end

function l.COLS(ss,     col,cols)
  cols={names=ss, all={},x={},y={}}
  for n,s in pairs(ss) do  
    col = l.push(cols.all, COL(n,s))
    if not col.isIgnored then
      if col.isKlass then cols.klass = col end
      l.push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end

function l.add(col,x,  inc)
  if x ~= "?" then
    inc = inc or 1
    col.n = col.n + inc
    if   col.isSym
    then col.has[x] = inc + (col.has[x] or 0) 
    else col.lo, col.hi = l.min(x,col.lo), l.max(x,col.hi) 
      local n = #col.has
      local pos = n < the.max and n+1 or l.rand() < the.max/col.n and l.rand(n) 
      if pos then
        col.has[pos] = x
        col.ok = false end end end end 

function l.has(col)
  if not col.isSym 
    if not col.ok then l.sort(col.has); col.ok=true end
  return col.has end

function l.mid(col)
  if   col.isSym 
  then m,mode = 0 
       for x,n in pairs(col.has) do if n>m then m,mode=n,x end end
       return mode 
  else return per(l.has(col), .5) end end 

function l.div(col)
  if   col.isSym 
  then e=0; for _,n in pairs(col.has) do e= e-n/col.n*log(n/col.n,2) end; return e
  else return (per(l.has(col),.9) - per(l.has(col), .1))/2.58 end end

-- ### Data
function l.DATA() return {rows={}} end

function l.stats(data,  fun,cols,nPlaces,     tmp)
  tmp = kap(cols or self.cols.all,
            function(k,col) return l.rnd((fun or l.mid)(col),nPlaces),col.txt end)
  tmp["N"] = #self.rows
  return tmp end

function l.clone(data,t,    data1)
  data1 = DATA()
  for _,row in pairs(t or {}) do l.row(data1,row) end
  return data1 end

function l.read(data,sfile) 
  csv(sfile, function(t) l.row(data,t) end); return data end

function l.row(data,t)
  if data.cols then
    push(data.rows,t)
    for _,cols in pairs{l.col.x, l.col.y} do
      for _,col in pairs(cols) do 
	l.add(col, t[col.at]) end end 
  else data.cols = l.COLS(t) end end
       
function l.dist(data,t1,t2,  cols,    d,n,dist)
  function dist1(col,x,y)
    if x=="?" and y=="?" then return 1 end
    if   col.isSym
    then return x==y and 0 or 1 
    else x,y = l.norm(col,x), l.norm(col.y)
         if x=="?" then x= y<.5 and 1 or 1 end	
         if y=="?" then y= x<.5 and 1 or 1 end	
         return l.abs(x-y) end 
  end ---------
  d, n = 0, 1/big	
  for _,col in pairs(cols or data.cols.x) do
    n = n + 1
    d = d + dist(col, t1[col.at], t2[col.at])^the.p end
  return (d/n)^(1/the.p) end
 
function l.norm(num,x)
  return x=="?" and x or (x - num.lo)/(num.hi - num.lo + 1/big) end

function l.half(data,  rows,cols,above)
  local left,right,far,gap,some,proj,costmp,A,B,c
  function gap(r1,r2) return l.dist(data, r1, r2, cols) end
  function cos(a,b,c) return (a^2 + c^2 - b^2)/(2*c) end
  function proj(r)    return {row=r, x=cos(gap(r,A), gap(r,B),c)} end
  rows = rows or data.rows
  some = l.many(rows,the.Halves)
  A    = above or any(some)
  tmp  = l.sort(l.map(some,function(r) return {row=r,d=gap(r,A)} end ),lt"d")
  far  = tmp[(#tmp*theFar)//1]
  B,c  = far.row, far.d
  left,right= {},{}
  for n,two in pairs(l.sort(l.map(rows,proj)),lt"x") do
    push(n< (#row)//2 and left or right,two.row) end
  return left,right,A,B,c end

-- ## Lib
-- ### Maths
l.abs  = math.abs
l.big  = math.huge
l.log  = math.log
l.max  = math.max
l.min  = math.min
l.rand = math.random

function l.rnd(n, nPlaces) 
  local mult = 10^(nPlaces or 2)
  return math.floor(n * mult + 0.5) / mult end

-- ### String to thing
function l.coerce(s,    fun) 
  function fun(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function l.cells(s,    t)
  t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = l.coerce(s1) end; return t end

-- ### Files
function l.lines(sFilename,fun,    src,s) 
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

function l.csv(sFilename,fun)
  l.lines(sFilename, function(line) fun(l.cells(line)) end) end

-- ### Lists
l.push = function(t,x) t[#t+1]=x; return x end
l.sort = function(t,f) table.sort(t,f); return t end

l.lt   = function(x) return function(a,b) return a[x] < b[x] end end

function l.map(t, fun) return l.kap(t, function(_,v) return fun(v) end) end
 
function l.kap(t, fun,     u) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v; end; return u end

function l.per(t,p) 
  p=math.floor(((p or .5)*#t)+.5); return t[math.max(1,math.min(#t,p))] end

function l.any(t) 
  return t[rint(#t)] end

function l.many(t,n) 
  local u={}; for i=1,n do push(u, l.any(t)) end; return u end 

-- ### Strings
l.fmt  = string.format

function l.o(t,    fun) 
  if type(t)~="table" then return tostring(t) end
  function fun (k,v) return l.fmt(":%s %s",k,l.o(v)) end 
  return "{"..table.concat(#t>0  and l.map(t,l.o) or l.sort(l.kap(t,fun))," ").."}" end

-- ### Start-up
help:gsub("\n  -[%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)", function(k,v) 
       for n,x in ipairs(arg) do
         if x=="-"..(k:sub(1,1)) or x=="--"..k then
           v= v=="false" and "true" or v=="true" and "false" or arg[n+1] end end 
       the[k] = l.coerce(v) end)  

math.randomseed = the.seed
for k,v in pairs(_ENV) do if not b4[k] then print(fmt("#W ?%s %s",k,type(v))) end end 
return l
