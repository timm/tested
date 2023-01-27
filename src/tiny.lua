-- vim: ts=2 sw=2 et :
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
local the,help = {}, [[

tiny.lua

OPTIONS:
  -c --cliffs   cliff's delta threshold     = .2385
  -f  --file    data file                   = ../etc/data/auto93.csv
  -F  --Far     distance to distant         = .95
  -h  --help    show help                   = false
  -H  --Halves  search space for clustering = 512
  -g  --go      start-up action             = nothing
  -m  --min     size of smallest cluster    = .5
  -M  --Max     numbers                     = 512
  -p  --p       dist coefficient            = 2
  -r  --rest    how many of rest to sample  = 4
  -s  --seed    random number seed          = 10019
]]
local magic = "\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)"
local adds,add,any,better,big,copy,cli,csv,cells,cliffsDelta,clone,coerce
local diffs,dist,div,egs,fmt,half,has,kap,keys,lines,lt
local main,many,map,mid,norm,o,oo,per,push
local rint,rand,read,rnd,row,rogues,Seed,show,sort,stats,sway,tree
local COL,COLS,DATA,NUM,SYM
local m = math

-- ### Factories
function COL(n,s,    col)
   col = s:find"^[A-Z]" and NUM(n,s) or SYM(n,s) 
   col.isIngored  = col.txt:find"X$"
   col.isKlass    = col.txt:find"!$"
   col.isGoal     = col.txt:find"[!+-]$"
   return col end

function NUM(n,s) 
  return {at= n or 0, txt= s or "", n=0,
          hi= -m.huge, lo= m.huge, 
	        ok=true, has={},
          w= (s or ""):find"-$" and -1 or 1} end

function SYM(n,s)
  return {at=n or 0, txt=s or "", n=0, 
          isSym=true, has={}} end

function COLS(ss,     col,cols)
  cols={names=ss, all={},x={},y={}}
  for n,s in pairs(ss) do  
    col = push(cols.all, COL(n,s))
    if not col.isIgnored then
      if col.isKlass then cols.klass = col end
      push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end

function adds(col,t) 
  for _,x in pairs(t or {}) do add(col,x) end; return col end

function add(col,x,  inc)
  if x ~= "?" then
    inc = inc or 1
    col.n = col.n + inc
    if   col.isSym
    then col.has[x] = inc + (col.has[x] or 0) 
    else col.lo, col.hi = m.min(x,col.lo), m.max(x,col.hi) 
      local n = #col.has
      local pos = n < the.Max and n+1 or rand() < the.Max/col.n and rand(n) 
      if pos then
        col.has[pos] = x
        col.ok = false end end end end 

function has(col)
  if not col.isSym and not col.ok then sort(col.has); col.ok=true end
  return col.has end

function mid(col,    mode,most)
  if   col.isSym 
  then most,mode = 0 
       for x,n in pairs(col.has) do if n>most then most,mode=n,x end end
       return mode 
  else return per(has(col), .5) end end 

function div(col,    e)
  if   col.isSym 
  then e=0; for _,n in pairs(col.has) do e= e-n/col.n*m.log(n/col.n,2) end; return e
  else return (per(has(col),.9) - per(has(col), .1))/2.58 end end

-- ### Data
function DATA() return {rows={},cols=nil} end  -- initially, no `cols`

function stats(data,  fun,cols,nPlaces,     tmp)
  tmp = kap(cols or data.cols.y,
            function(k,col) return rnd((fun or mid)(col),nPlaces), col.txt end)
  tmp["N"] = #data.rows
  return tmp end

function clone(data,t,    data1)
  data1=row(DATA(), data.cols.names)
  for _,t in pairs(t or {}) do row(data1,t) end
  return data1 end

function read(sfile,    data) 
  data=DATA()
  csv(sfile, function(t) row(data,t) end); return data end

function row(data,t)
  if data.cols  then
    push(data.rows,t)
    for _,cols in pairs{data.cols.x, data.cols.y} do
      for _,col in pairs(cols) do 
	     add(col, t[col.at]) end end 
  else data.cols = COLS(t) end 
  return data end
       
function dist(data,t1,t2,  cols,    d,n,dist1)
  function dist1(col,x,y)
    if x=="?" and y=="?" then return 1 end
    if   col.isSym
    then return x==y and 0 or 1 
    else x,y = norm(col,x), norm(col,y)
         if x=="?" then x= y<.5 and 1 or 1 end	
         if y=="?" then y= x<.5 and 1 or 1 end	
         return m.abs(x-y) end 
  end ---------
  d, n = 0, 1/big	
  for _,col in pairs(cols or data.cols.x) do
    n = n + 1
    d = d + dist1(col, t1[col.at], t2[col.at])^the.p end 
  return (d/n)^(1/the.p) end
 
function norm(num,x)
  return x=="?" and x or (x - num.lo)/(num.hi - num.lo + 1/big) end

function half(data,  rows,cols,above)
  local left,right,far,gap,some,proj,cos,tmp,A,B,c = {},{}
  function gap(r1,r2) return dist(data, r1, r2, cols) end
  function cos(a,b,c) return (a^2 + c^2 - b^2)/(2*c) end
  function proj(r)    return {row=r, x=cos(gap(r,A), gap(r,B),c)} end
  rows = rows or data.rows
  some = many(rows,the.Halves)
  A    = above or any(some)
  tmp  = sort(map(some,function(r) return {row=r, d=gap(r,A)} end ),lt"d")
  far  = tmp[(#tmp*the.Far)//1]
  B,c  = far.row, far.d
  for n,two in pairs(sort(map(rows,proj),lt"x")) do
    push(n <= #rows/2 and left or right, two.row) end
  return left,right,A,B,c end

function tree(data,  rows,cols,above,     here)
  rows = rows or data.rows
  here = {data=clone(data,rows)}
  if #rows >= 2*(#data.rows)^the.min then
    local left,right,A,B = half(data, rows, cols, above)
    here.left  = tree(data, left,  cols, A)
    here.right = tree(data, right, cols, B) end
  return here end 

function sway(data,     worker,best,rest)
  function worker(rows,worse,  above)
    if   #rows <= (#data.rows)^the.min 
    then return rows, many(worse, the.rest*#rows) 
    else local l,r,A,B = half(data, rows, cols, above)
         if better(data,B,A) then l,r,A,B = r,l,B,A end
         map(r, function(row) push(worse,row) end) 
         return worker(l,worse,A) end 
  end ----------------------------------
  best,rest = worker(data.rows,{})
  return clone(data,best), clone(data,rest) end 

function better(data,row1,row2,    s1,s2,ys,x,y) 
  s1,s2,ys,x,y = 0,0,data.cols.y
  for _,col in pairs(ys) do
    x  = norm(col, row1[col.at] )
    y  = norm(col, row2[col.at] )
    s1 = s1 - m.exp(col.w * (x-y)/#ys)
    s2 = s2 - m.exp(col.w * (y-x)/#ys) end
  return s1/#ys < s2/#ys end
  
function show(tree,  lvl,post)
  if tree then 
    lvl  = lvl or 0
    if lvl==0 or not tree.left 
    then post= o(stats(tree.data)) end
    print(fmt("%s[%s] %s",("|.. "):rep(lvl), #(tree.data.rows),post or ""))
    show(tree.left, lvl+1)
    show(tree.right,lvl+1) end end

-- ## Lib
-- ### Maths
big  = math.huge

function rnd(n, nPlaces) 
  local mult = 10^(nPlaces or 2)
  return math.floor(n * mult + 0.5) / mult end

Seed=937162211
function rint(nlo,nhi)  
  return m.floor(0.5 + rand(nlo,nhi)) end

function rand(nlo,nhi) --> num; return float from `nlo`..`nhi` (default 0..1)
  nlo, nhi = nlo or 0, nhi or 1
  Seed = (16807 * Seed) % 2147483647
  return nlo + (nhi-nlo) * Seed / 2147483647 end

--  M.Hess, J.Kromrey. 
--  Robust Confidence Intervals for Effect Sizes: 
--  A Comparative Study of Cohen's d and Cliff's Delta Under Non-normality and Heterogeneous Variances
--  American Educational Research Association, San Diego, April 12 - 16, 2004
--  0.147=  small, 0.33 =  medium, 0.474 = large; med --> small at .2385
function cliffsDelta(ns1,ns2) 
  if #ns1 > 256     then ns1 = many(ns1,256) end
  if #ns2 > 256     then ns2 = many(ns2,256) end
  if #ns1 > 10*#ns2 then ns1 = many(ns1,10*#ns2) end
  if #ns2 > 10*#ns1 then ns2 = many(ns2,10*#ns1) end
  local n,gt,lt = 0,0,0
  for _,x in pairs(ns1) do
    for _,y in pairs(ns2) do
      n = n + 1
      if x > y then gt = gt + 1 end
      if x < y then lt = lt + 1 end end end
  return m.abs(lt - gt)/n > the.cliffs end

function diffs(nums1,nums2)
  return kap(nums1,function(k,nums) return cliffsDelta(nums.has,nums2[k].has),nums.txt end) end

-- ### String to thing
function coerce(s,    fun) 
  function fun(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function cells(s,    t)
  t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; return t end

function lines(sFilename,fun,    src,s) 
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

function csv(sFilename,fun)
  lines(sFilename, function(line) fun(cells(line)) end) end

-- ### Lists
push = function(t,x) t[#t+1]=x; return x end
sort = function(t,f) table.sort(t,f); return t end
lt   = function(x)   return function(a,b) return a[x] < b[x] end end
any  = function(t)   return t[rint(#t)] end
many = function(t,n,    u) u={}; for i=1,n do push(u, any(t)) end; return u end 
map  = function(t, fun) return kap(t, function(_,v) return fun(v) end) end
keys = function(t)      return sort(kap(t,function(k,_) return k end)) end

function kap(t, fun,     u) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v; end; return u end

function per(t,p) 
  p=math.floor(((p or .5)*#t)+.5); return t[m.max(1,m.min(#t,p))] end

function copy(t,    u) 
  if  type(t)~="table" then return t end
  u={}; for k,v in pairs(t) do u[k] = copy(v) end; return u end

-- ### Strings
fmt  = string.format

function oo(t) print(o(t)); return t end
function o(t,    fun) 
  if type(t)~="table" then return tostring(t) end
  function fun (k,v) return fmt(":%s %s",k,o(v)) end 
  return "{"..table.concat(#t>0  and map(t,o) or sort(kap(t,fun))," ").."}" end

-- ### Test engine
function main(funs,the,help,    fails,saved,names)
  fails, saved, names = 0, copy(the), keys(funs)
  if   the.help 
  then print(help)
       print("ACTIONS:\n  -g  .  (runs all actions)") 
       for _,name in pairs(names) do print("  -g   "..name) end end
  for _,name in pairs(names) do
    if name:find(".*"..the.go..".*") then
      for k,v in pairs(saved) do the[k]=v end
        Seed = the.seed
        if funs[name]()==false then print("❌ "..name); fails=fail+1
                               else print("✅ "..name) end end end  
  rogues()
  return fails end

function rogues() 
  for k,v in pairs(_ENV) do 
    if not b4[k] then print(fmt("#W ?%s %s",k,type(v))) end end end

function cli(t)
  for k,v in pairs(t) do
    v = tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
        v= v=="false" and "true" or v=="true" and "false" or arg[n+1] end end 
    t[k] = coerce(v) end 
  return t end

-- ## Examples
local egs = {}
function egs.the() oo(the) end
function egs.rand(      t,u)
  Seed=1; t={}; for i=1,1000 do push(t,rint(100)) end
  Seed=1; u={}; for i=1,1000 do push(u,rint(100)) end
  for k,v in pairs(t) do assert(v==u[k]) end end

function egs.nums(     num1,num2)
  num1,num2 = NUM(), NUM()
  for i=1,10000 do add(num1, rand()) end
  for i=1,10000 do add(num2, rand()^2) end
  print(1,rnd(mid(num1)), rnd(div(num1)))
  print(2,rnd(mid(num2)), rnd(div(num2))) 
  return .5 == rnd(mid(num1)) and mid(num1)> mid(num2) end

function egs.syms(     sym)
  sym=adds(SYM(), {"a","a","a","a","b","b","c"})
  print (mid(sym), rnd(div(sym))) 
  return 1.38 == rnd(div(sym)) end

function egs.csv(    n) 
  n=0; csv(the.file, function(t) n=n+#t end) 
  return 3192 == n end

function egs.data(    data,col) 
  data=read(the.file)
  col=data.cols.x[1]
  print(col.lo,col.hi, mid(col),div(col))
  oo(stats(data)) end

function egs.clone(    data1,data2)
  data1=read(the.file)
  data2=clone(data1,data1.rows) 
  oo(stats(data1))
  oo(stats(data2))
end

function egs.cliffs(   t1,t2,t3)
  assert(false == cliffsDelta( {8,7,6,2,5,8,7,3},{8,7,6,2,5,8,7,3}))
  assert(true  == cliffsDelta( {8,7,6,2,5,8,7,3}, {9,9,7,8,10,9,6})) 
  t1,t2={},{}
  for i=1,1000 do push(t1,rand()) end
  for i=1,1000 do push(t2,rand()^2) end
  assert(false == cliffsDelta(t1,t1)) 
  assert(true ==  cliffsDelta(t1,t2)) 
  local diff,j=false,1.0
  while not diff  do
    t3=map(t1,function(x) return x*j end)
    diff=cliffsDelta(t1,t3)
    print(rnd(j),diff) 
    j=j*1.025 end end

function egs.dist(    data,num)
  data = read(the.file)
  num  = NUM()
  for _,row in pairs(data.rows) do
    add(num,dist(data, row, data.rows[1])) end
  oo{lo=num.lo, hi=num.hi, mid=rnd(mid(num)), div=rnd(div(num))} end 

function egs.half(   data,l,r)
  data = read(the.file)
  local left,right,A,B,c = half(data) 
  print(#left,#right)
  l,r = clone(data,left), clone(data,right)
  print("l",o(stats(l)))
  print("r",o(stats(r))) end
 
function egs.tree(   data,l,r)
  show(tree(read(the.file))) end

function egs.sway(    data,best,rest)
  data = read(the.file)
  best,rest = sway(data)
  print("\nall ",o(stats(data))) 
  print("    ",o(stats(data,div))) 
  print("\nbest",o(stats(best))) 
  print("    ",o(stats(best,div))) 
  print("\nrest",o(stats(rest))) 
  print("    ",o(stats(rest,div))) 
  print("\nall ~= best?", o(diffs(best.cols.y, data.cols.y)))
  print("best ~= rest?", o(diffs(best.cols.y, rest.cols.y))) end

-- ### Start-up
help:gsub(magic, function(k,v) the[k] = coerce(v) end)
os.exit( main(egs, cli(the), help) )
