--<!-- vim: set syntax=lua ts=2 sw=2 expandtab: -->
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
local help=[[
tiny.lua : lots of AI in a tiny box
(c) 2023, Tim Menzies <timm@ieee.org> BSD-2
]]
local the  = {
      Far  = .95,
      go   = "nothing",
      file = "../etc/data/auto93.csv",
      goal = "plan",
      help = false,
      Max  = 512,
      min  = .5,
      p    = 2,
      rest = 4,
      seed =  937162211}
---------------------------------------
local m   = math
local fmt = string.format

local lt,sort
function lt(x)       return function(a,b) return a[x] < b[x] end end
function sort(t,fun) table.sort(t,fun); return t end

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
  return math.floor(n * mult + 0.5) / mult end

local Seed,rint,rand=937162211 
function rint(nlo,nhi) return m.floor(0.5 + rand(nlo,nhi)) end
function rand(nlo,nhi) 
  Seed = (16807 * Seed) % 2147483647
  return (nlo or 0) + ((nhi or 1) - (nlo or 0)) * Seed / 2147483647 end

local coerce,lines,csv
function coerce(s,    fun) 
  fun = function(s1)
          if s1=="true" then return true elseif s1=="false" then return false end
  return s1 end
  return m.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function lines(sFilename,fun,    src,s) 
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

function csv(sFilename,fun,     cells)
  cells = function(s,    t)
    t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; return t end
  lines(sFilename, function(line) fun(cells(line)) end) end

local o,oo
function oo(t) print(o(t)); return t end
function o(t,    fun) 
  fun = function(k,v) return fmt(":%s %s",k,o(v)) end 
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
function isNum(col)  return col.lo   end
function isSym(col)  return col.most end
function isData(col) return col.rows end

local NUM,SYM,add,has,mid,div
function NUM(n,s) 
  return {at=n, txt=s or "", n=0, has={}, ok=true,
          hi=-m.huge, lo=m.huge, w=(s or ""):find"-$"} end

function SYM(n,s) 
  return {at=n, txt=s or "", n=0, has={}, most=0, mode=nil} end

function add(col,x,  inc,pos,num,sym)
  sym = function(t)
          t[x] = inc + (t[x] or 0) 
          if t[x] > col.most then col.mast, col.mode = t[x], x end end
  num = function(t,     pos)
          col.lo = m.min(x, col.lo)
          col.hi = m.max(x, col.hi) 
          pos    = #t<the.Max and #t+1 or rand()<the.Max/col.n and rint(1,#t)
          if pos then col.ok=false
                      t[pos] = x end end
  if x~="?" then  
    inc   = inc or 1
    col.n = col.n + inc
    return isSym(col) and sym(col.has)  or num(col.has) end end 

function has(col) 
  if isNum(col) and not col.ok then sort(col.has) ; col.ok=true end
  return col.has end

function mid(col,      most,mode)
  return isSym(col) and col.mode or per(has(col), .5) end

function div(col,    num,sym)
  num = function(t) return (per(t,.9) - per(t,.1))/2.58 end
  sym = function (t,    e,fun)
          fun = function (p) return p*math.log(p,2) end
          e=0; for _,n in pairs(self.has) do e = e - fun(n/self.n) end 
          return e end 
  return isSym(col) and num(has(col)) or sym(col.has) end
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
  if     type(src)=="string" then csv(file, fun) 
  elseif tyepe(src)=="table" then 
    if isData(src) then row(data, src.cols.names) else map(src,fun) end end 
  map(rows or {}, fun)
  return data end

function row(data,t)
  if data.cols then 
    push(data.rows,t)
    for _,cols in pairs{data.cols.x, data.cols.y} do
      for _,col in pairs(cols) do add(col,t[col.at]) end end
  else data.cols = COLS(t) end end

function stats(data,  fun,cols,nPlaces,     tmp,fun)
  fun = function(k,col) return rnd((fun or mid)(col),nPlaces), col.txt end
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
                      if y=="?" then y= x<.5 and 1 or 1 end	
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

function half(data,  rows,cols,above)
  local d,proj1,cos,same,A,B,c,left,right
  cols = cols or data.cols
  rows = rows or data.rows
  gap  = function(r1,r2) return dist(data,r1,r2,cols) end
  cos  = function(a,b) return (a^2 + c^2 - b^2)/(2*c) end
  proj = function(r) return {row=r, x=cos(gap(r,A), gap(r,B), c)} end
  some = many(rows,the.Halves)
  A    = above or far(data,any(some),some,cols)
  B    = far(data,A,some,cols)
  c    = gap(A,B)
  left, right = {},{}
  for n,two in pairs(sort(map(rows,proj),lt"x")) do
    push(n <= #rows/2 and left or right, two.row) end
  return left,right,A,B,(above and 1 or 2)  end
------------------------
local function better(data,row1,row2,    s1,s2,ys,x,y) 
  s1,s2,ys,x,y = 0,0,data.cols.y
  for _,col in pairs(ys) do
    x  = norm(col, row1[col.at] )
    y  = norm(col, row2[col.at] )
    s1 = s1 - m.exp(col.w * (x-y)/#ys)
    s2 = s2 - m.exp(col.w * (y-x)/#ys) end
  return s1/#ys < s2/#ys end

local function bestHalf(data,rows,stop,worse,evals,  above)
  if   #rows <= stop
  then return rows, many(worse, the.rest*#rows), evals
  else left,right,A,B,n = half(data,rows,cols,above)
       if better(data,B,A) then left,right,A,B = right,left,B,A end
       map(right, function(row) push(worse,row) end)
       return betters(data,left,stop,worse,evals+n,A) end end 

local function sway(data)
   best,rest,evals = betters(data, data.rows, #data.rows^the.min, {}, 0)
   return DATA(data,best), DATA(data,rest), evals end

local goal={}
goal.plan    = function(b,r) return b^2/(b+r) end
goal.monitor = function(b,r) return r^2/(b+r) end
goal.explore = function(b,r) return r^2/(b+r) end

local function xys(datas,best,     x,xy,B,R)
  B,R,t = 0,0,{}
  for klass,data in pairs(datas)  do
    for _,col in pairs(data.cols.x) do
      for _,z in pairs(has(col)) do
        if klass==best then B = B+1 else R = R+1 end
        push(t,{x=x, y= klass==best}) end end end 
  return sort(t,lt"x"),B,R end 

local function split1(col,rows,best,      min)
  local t,B,R,lb,lr,rb,rr,val,tiny,range,most
  range = function(lo,hi,v) return {lo=lo, hi=hi, at=col.at, txt=col.txt,val=v} end 
  val   = function(b,r,     z)  
            tiny=1/m.huge
            return goal[the.goal]( b/(B+z), r/(R+z)) end
  t,B,R = xys(rows,best)
  lb,lr,rb,rr = 0,0,B,R
  min = the.median and (B+R)/2 or B/3
  most = -1
  for i,xy in pairs(t) do
    if xy.y then lb = lb+1; rb = rb-1 else lr = lr-1; rr = rr-1 end
    if i >= min and i <= #t - min + 1 then
      v1,v2 = val(lb,lr), val(rb,rr)
      if v1 > v2 and v1>most then 
        most,out= v1,range(t[1].x, xy.x, v1) end
      if v2 > v1 and v2>most then 
        most,out= v2,range(xy.x, t[#t].x, v2) end 
      if the.median then break end end end 
  return out end

local function split(cols,rows,best)
   return sort(map(cols,function(col) return split1(col,rows,best) end), gt"val")[1] end

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
  io.write(fmt(">>  %s ",what)) 
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
  for k,v in pairs(_ENV) do if not b4[k] then print(k,type(v)) end end 
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
go.num = function(  num)
  num = NUM()
  for i=1,1000 do add(num,rand()^.5) end
  print(mid(num)) end
 
return pcall(debug.getlocal,4,1) and locals() or main() 
