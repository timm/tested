--<!-- vim: set syntax=lua ts=2 sw=2 expandtab: -->
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
local help=[[
tiny.lua : lots of AI in a tiny box
(c) 2023, Tim Menzies <timm@ieee.org> BSD-2
]]
local the  = {
      bins = 16,
      Far  = .95,
      file = "../etc/data/auto93.csv",
      go   = "nothing",
      Goal = "plan",
      help = false,
      Halves=512,
      Max  = 512,
      min  = .5,
      p    = 2,
      rest = 4,
      seed =  937162211}
---------------------------------------
local m   = math
local fmt = string.format

local lt,gt,sort
function lt(x)       return function(a,b) return a[x] < b[x] end end
function gt(x)       return function(a,b) return a[x] > b[x] end end
function sort(t,fun) table.sort(t,fun); return t end

local Seed,rint,rand = 937162211 
function rint(nlo,nhi) return m.floor(0.5 + rand(nlo,nhi)) end
function rand(nlo,nhi) 
  Seed = (16807 * Seed) % 2147483647
  return (nlo or 0) + ((nhi or 1) - (nlo or 0)) * Seed / 2147483647 end

local function gaussian(mu,sd)  --> n; return a sample from a Gaussian with mean `mu` and sd `sd`
  return  (mu or 0) + (sd or 1) * m.sqrt(-2*m.log(rand())) * m.cos(2*m.pi*rand())  end


local per,any,many,push
function per(t,p)   return t[ m.max(1, m.min(#t, (((p or .5)*#t) + .5) // 1)) ] end
function any(t)     return t[rint(#t)] end
function many(t,n)  local u={}; for i=1,n do push(u, any(t)) end; return u end 
function push(t,x) t[1+#t]=x; return x end

local map,kap
function map(t, fun) return kap(t, function(_,v) return fun(v) end) end
function kap(t, fun,     u) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v end; return u end

local function rnd(n, nPlaces) 
  if type(n) ~= "number" then return n end
  local mult = 10^(nPlaces or 2)
  return m.floor(n * mult + 0.5) / mult end

local coerce,lines,csv
function csv(sFilename,fun,     cells)
  cells = function(s,    t)
    t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; return t end
  lines(sFilename, function(line) fun(cells(line)) end) end

function lines(sFilename,fun,    src,s) 
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

function coerce(s,    fun) 
  fun = function(s1)
          if s1=="true" then return true elseif s1=="false" then return false end
  return s1 end
  return m.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

local o,oo
function oo(t) print(o(t)); return t end
function o(t,    fun) 
  fun = function(k,v) return fmt(":%s %s",k,v) end 
  return type(t) ~="table" and tostring(t) or 
         "{"..table.concat(#t>0 and map(t,o) or sort(kap(t,fun))," ").."}" end

local function cli(k,v)
  v = tostring(v)
  for n,x in ipairs(arg) do
    if x=="-"..(k:sub(1,1)) or x=="--"..k then
      v= v=="false" and "true" or v=="true" and "false" or arg[n+1] end end 
  return coerce(v),k end 
------------------------
local isNum,isSym,isData
function isNum(col)  return col.lo   ~= nil end
function isSym(col)  return col.most ~= nil end
function isData(col) return col.rows ~= nil end

local NUM,SYM,add,has,mid,div
function NUM(n,s) 
  return {at=n, txt=s or "", n=0, has={}, ok=false,
          hi=-m.huge, lo=m.huge, w=(s or ""):find"-$" and -1 or 1} end

function SYM(n,s) 
  return {at=n, txt=s or "", n=0, has={}, most=0, mode=nil} end

function add(col,x,  inc,     t)
  if x=="?" then return x end
  inc   = inc or 1
  col.n = col.n + inc
  t=col.has
  if   isSym(col) 
  then t[x] = inc + (t[x] or 0) 
       if t[x] > col.most then col.most, col.mode = t[x], x end 
  else local pos
       col.lo = m.min(x, col.lo)
       col.hi = m.max(x, col.hi) 
       if     #t<the.Max           then col.ok=false; t[1+#t]= x 
       elseif rand()<the.Max/col.n then col.ok=false; t[rint(1,#t)] = x end end end

function has(col) 
  if isNum(col) and not col.ok then sort(col.has); col.ok=true end
  return col.has end

function mid(col)
  return isSym(col) and col.mode or  per(has(col), .5) end

function div(col)
  if isNum(col) then 
    return (per(has(col),.9) - per(has(col),.1))/2.58 
  elseif isSym(col) then
    local e=0
    for _,n in pairs(col.has) do e = e - n/col.n * m.log(n/col.n,2) end
    return e  end end
------------------------
local COL,COLS
function COL(n,s,    col)
   col = s:find"^[A-Z]" and NUM(n,s) or SYM(n,s) 
   col.isIgnored  = col.txt:find"X$"
   col.isKlass    = col.txt:find"!$"
   col.isGoal     = col.txt:find"[!+-]$"
   return col end

function COLS(ss,     col,cols)
  cols={names=ss, all={},x={},y={}}
  for n,s in pairs(ss) do  
    col = push(cols.all, COL(n,s))
    if not col.isIgnored and col.isKlass then cols.klass = col end
    if not col.isIgnored then push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end
------------------------
local DATA,row,stats
function DATA(src, rows,     data,fun)
  data = {rows={}, cols=nil}
  fun  = function(t) row(data,t) end 
  if     type(src)=="string" then csv(src, fun) 
  elseif type(src)=="table" then 
    if isData(src) then row(data, src.cols.names) else map(src,fun) end end 
  map(rows or {}, fun)
  return data end

function row(data,t)
  if data.cols then 
    push(data.rows,t)
    for _,cols in pairs{data.cols.x, data.cols.y} do
      for _,col in pairs(cols) do add(col,t[col.at]) end end
  else data.cols = COLS(t) end end

function stats(data,  what,cols,nPlaces,     tmp,fun)
  fun = function(k,col) return rnd((what or mid)(col),nPlaces), col.txt end
  tmp = kap(cols or data.cols.y, fun)
  tmp["N"] = #data.rows
  return tmp end
------------------------
local norm,dist,around,far,half
function norm(num,n)
  return n=="?" and n or (n - num.lo)/(num.hi - num.lo + 1/m.huge) end

function dist(data,t1,t2,  cols,    d,gap,sym,num)
  sym = function(x,y) return x==y and 0 or 1 end
  num = function(x,y) if x=="?" then x= y<.5 and 1 or 1 end  
                      return m.abs(x-y) end 
  gap = function(col,x,y) 
          if x=="?" and y=="?" then return 1 end
          return isSym(col) and sym(x,y) or num(norm(col,x), norm(col,y)) end
  d, cols = 0, (cols or data.cols.x)  
  for _,col in pairs(cols) do
    d = d + gap(col, t1[col.at], t2[col.at])^the.p end 
  return (d/#cols)^(1/the.p) end

function around(data,t1,  rows,cols,     fun)
  fun = function(t2) return {row=t2, dist=dist(data,t1,t2,cols)} end
  return sort(map(rows and data.rows, fun),lt"dist") end
 
function far(data,t1,  rows,cols,    tmp)
  tmp = around(data,t1,rows,cols)
  return tmp[(#tmp*the.Far) // 1].row end

function half(data,  rows,above,cols)
  local gap,proj,cos,some,A,B,c,left,right
  cols = cols or data.cols.x
  rows = rows or data.rows
  gap  = function(r1,r2) return dist(data,r1,r2,cols) end
  cos  = function(a,b) return (a^2 + c^2 - b^2)/(2*c) end
  proj = function(r) return {row=r, x=cos(gap(r,A), gap(r,B), c)} end
  some = many(rows, m.min(#rows, the.Halves))
  A    = above or far(data, any(some), some, cols)
  B    = far(data,A,some,cols)
  c    = gap(A,B)
  left, right = {},{}
  for n,two in pairs(sort(map(rows,proj),lt"x")) do
    push(n <= #rows/2 and left or right, two.row) end
  return left,right,A,B,(above and 1 or 2)  end
------------------------
local function better(data,row1,row2,    s1,s2,ys,x,y) 
  s1, s2, ys, x, y = 0, 0, data.cols.y
  for _,col in pairs(ys) do
    x  = norm(col, row1[col.at] )
    y  = norm(col, row2[col.at] )
    s1 = s1 - m.exp(col.w * (x-y)/#ys)
    s2 = s2 - m.exp(col.w * (y-x)/#ys) end
  return s1/#ys < s2/#ys end

local function bestHalf(data,rows,stop,worse,evals,  above)
  if   #rows <= stop
  then return rows, many(worse, the.rest*#rows), evals
  else local left,right,A,B,n = half(data,rows)
       if better(data,B,A) then left,right,A,B = right,left,B,A end
       map(right, function(row) push(worse,row) end)
       return bestHalf(data,left,stop,worse,evals+n,A) end end 

local function sway(data,     best,rest,evals)
   best,rest,evals = bestHalf(data, data.rows, (#data.rows)^the.min, {}, 0)
   return DATA(data,best), DATA(data,rest), evals end

local goal,val={}
goal.plan    = function(b,r) return b^2/(b+r) end
goal.monitor = function(b,r) return r^2/(b+r) end
goal.explore = function(b,r) return 1/(b+r)   end

function val(range,B,R,     b,r) 
  b,r = range.has[true], range.has[false]
 return goal[the.Goal]( b/(B+1/m.huge), r/(R+1/m.huge)) end

local function RANGE(at,txt,lo,hi)
  return {lo=lo, hi=hi or lo, at=col.at, txt=col.txt, ys=SYM()} end 

local function merge(range1,range2,    range3)
  range3= RANGE(range1.at, range1.txt, range1.lo, range2.hi)
  for _,t in pairs{range1.has, range2.has} do
    for k,n in pairs(t) do add(range3,k,n) end end
  return range3 end

local function merged(range1,range2,B,R) 
  range3= merge(range1,range2,B,R)
  if val(range3,B,R)  > val(range1,B,R) or val(range3,B,R) > val(range2,B,R) then
    return range3 end end
   
local function extend(range, x,y)
  range.lo = min(range.lo,x)
  range.hi = max(range.hi,x)
  add(range.ys, y) end

function bin(col,x,      tmp)
  if x=="?" or isSym(col)  then return x end
  tmp = (col.hi - col.lo)/(the.bins - 1)
  return col.hi == col.lo and 1 or m.floor(x/tmp + .5)*tmp end

local function xys(col,datas,best,     tmp,x,y,B,R.value)
  B,R,tmp = 0,0,{}
  for klass,data in pairs(datas)  do
    for i,row in pairs(data.rows) do
      x= row[col.at]
      if x ~= "?" then
        y = klass==best
        if y then B = B+1 else R = R+1 end
        k=bin(col,x)
        tmp[k] = tmp[k] or RANGE(col.at,col.txt,x)
        extend(tmp[k], xy.x, y)  end end end  
  value=function(range)
          range.val = val(range.has[true], range.has[false],B,R)
          return range end
  return sort(tmp,map(tmp,value),t"lo"),B,R end 

local function merge(col,ranges)
  if isSym(col) then return ranges end
  
local function splitsym(col,datas,best)
  local t,B,R = xys(col,datas,best)
  for i,xy in pairs(t) do
    tmp[xy.x] = tmp[xy.x] or NUM()
    add(tmp[xy.x], xy.x==best) end
  tmp = kap(tmp,function(k,num) return RANGE(k,k,num.n, val(num.has[best) return RANge(
    {b=0,r=0}
    best[xy.x] = best[xy.x] orout[xy.x] =  out[xy.x] or  RANGE(xy.x,xy.x,0,0,col)
    out[xy.x].n = out[xy.x].n + 1 end
  map(out,function(range) range.val= val(

local function splitnum(col,datas,best)
  local t,B,R = xys(col,datas,best)
  local min = the.median and (B+R)/2 or B/3
  local most,out = -1, RANGE(t[1].x, t[#t].x, B+R,0,col) 
  local b,r = 0,0 
  for i,xy in pairs(t) do -- walk left to right, incrementing  counts from b,r
    if xy.y then b = b+1 else r = r+1 end
    if i >= min and i <= #t - min + 1 then
      if xy.x ~= t[i+1].x then
        local v1 = val(b, r,B,R)
        if v1 > most then most,out= v1, RANGE(t[1].x, xy.x, i,v1,col) end
        local v2 = val(B-b, R-r,B,R)
        if v2 > most then most,out= v2, RANGE(xy.x, t[#t].x, #t-i, v2,col) end 
        if the.median then break end end end end
  return out end

local function split(cols,datas,best,    fun)
   fun = function(col) return (isNump(col) and splitnum or splitsym)(col,datas,best) end
   return sort(map(cols,fun), gt"val")[1] end

local function selects(range,rows,     yes,no)
  yes,no = {}
  for _,row in pairs(row) do
    x = row[range.at]
    if x == "?" then push(yes,row) 
    elseif range.lo == range.hi and range.lo == x then push(yes,row)
    elseif range.lo <= x and x < range.hi then push(yes,row)
    else   push(no,row) end end
  return yes,no end

local function fftTrees(data,best,rows,out)
  rows  = rows or data.rows
  out   = out or {}
  range = split(data,cols,rows,best)
  left,right = selects(range,rows)

end
------------------------------------
local go,no,copy,fails = {},{},{},0
local ok,todo,locals,main,showHelp

function ok(test, txt)  
  if not test then fails = fails + 1 end 
  print(fmt(test and "✅ PASS %s" or "❌ FAIL %s",txt)) end

function todo(what,fun) 
  for k,v in pairs(copy) do the[k]=v end
  Seed = the.seed 
  m.randomseed(the.seed)
  io.write(fmt(">> %s ",what)) 
  fun() end

function showHelp(the)
  print("\n"..help,
        "\nUSAGE:\n   lua tiny.lua [OPTIONS] [--go ACTION]\n\nOPTIONS:")
  map(sort(kap(the,function(k,v) return fmt("   --%-8s%s",k,v) end)),
      print)
  print("\nACTIONS:")
  for k,_ in pairs(go) do print("   lua tiny.lua --go "..k) end end 

function main()
  the = kap(the,cli)
  if the.help then showHelp(the) end
  for k,v in pairs(the) do copy[k]=v end
  for what,fun in pairs(go) do
    if the.go == "all" or the.go == what then 
      todo(what,fun) end end
  for k,v in pairs(_ENV) do if not b4[k] then print("?",k,type(v)) end end 
  os.exit(fails) end 

function locals(    t,i,s,x)
  t,i,s,x = {},1 
  while true do
    s, x = debug.getlocal(2, i)
    if not s then break end
    if s:sub(1,1) ~= "" then t[s]=x ; print(s,x) end
    i = i + 1 end
  return t end
------------------------
go.the = function() oo(the); ok(type(the)=="table","the")  end

go.any = function(     t)
  t={1,2,4,7}
  for i=1,10 do io.write(" ",(table.concat(many(t,4)))) end ; print"" end

go.num = function(  num1,num2)
  num1,num2 = NUM(),NUM()
  for i=1,1000 do  add(num1,rand()^2) end
  for i=1,1000 do  add(num2,rand()) end
  ok(.24 <=mid(num1) and mid(num1) <= .26 and mid(num1) < mid(num2),"nummid")
  ok( m.abs(div(num1) - div(num2)) <= .05, "numdiv") end
 
go.gauss=function( n) 
   n=NUM()
   for i=1,1000 do add(n, gaussian(10,2)) end 
   ok(9.8 <= mid(n) and mid(n) <= 10.2 and 1.8<=div(n) and div(n) < 2.2,"sd") end

go.sym=function(      s)
  s=SYM()
  for _,x in pairs{"a","a","a","a","b","b","c"} do add(s,x)  end
  ok("a" == mid(s),"midsym")
  print(1.37 <= div(s) and div(s) <= 1.39,"divsym") end

go.csv=function(       n)
  n=0
  csv(the.file,function(t) n= n+ #t end); ok(3192==n,"csvn") end

go.data=function(      data)
  data=DATA(the.file) 
  print(o(stats(data,mid,data.cols.x)), o(stats(data,mid,data.cols.y)))
  print(o(stats(data,div,data.cols.x)), o(stats(data,div,data.cols.y))) end

go.dist=function(      data)
  data=DATA(the.file) 
  for i=1,#data.rows,30 do
    print(dist(data,data.rows[1],data.rows[i])) end end

go.half=function(      data,left,right)
  data=DATA(the.file) 
  left,right = half(data) 
  ok(199==#left and 199==#right,"half") end 

go.better=function(      data)
  data=DATA(the.file) 
  print("\n","",o(data.rows[301]))
  for i=1,#data.rows,30 do
    print(i,better(data, data.rows[301], data.rows[i]), o(data.rows[i])) end end

go.sway=function(      data,best,rest,n)
  data=DATA(the.file) 
  print("\nb4   ",o(stats(data,mid,data.cols.y)))
  best,rest,n = sway(data)
  print("after", o(stats(best,mid,best.cols.y)),n)
end

go.split= function(      data,best,rest,n)
  data=DATA(the.file)
  best,rest,n = sway(data)
  print(#best.rows,#rest.rows)
  oo(split(data.cols.x, {best=best, rest=rest},"best")) end

---------------------------------------------
return pcall(debug.getlocal,4,1) and locals() or main() 
