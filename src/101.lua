#!/usr/bin/env lua
---       _        __        _     
---     /' \     /'__`\    /' \    
---    /\_, \   /\ \/\ \  /\_, \   
---    \/_/\ \  \ \ \ \ \ \/_/\ \  
---       \ \ \  \ \ \_\ \   \ \ \ 
---        \ \_\  \ \____/    \ \_\
---         \/_/   \/___/      \/_/
---                                
                            
local lib = require"lib"
local the = lib.settings[[   
101.lua : an example script with help text and a test suite
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

USAGE:   101.lua  [OPTIONS]

OPTIONS:
  -d  --dump  on crash, dump stack = false
  -g  --go    start-up action      = data
  -h  --help  show help            = false
  -s  --seed  random number seed   = 937162211
  -S  --Some  some sample size     = 64
]]
local fmt,oo,per,rnd,sort,rand,norm=lib.fmt,lib.oo,lib.per,lib.rnd,lib.sort,lib.rand,lib.norm
-----------------------------------------------------------------------------------------
-- ## SYM
-- Summarize a stream of symbols.
local SYM = lib.obj"SYM"
function SYM.new(i) --> SYM; constructor
  i.n   = 0
  i.has = {}
  i.most, i.mode = 0,nil end

function SYM.add(i,x) --> nil;  update counts of things seen so far
  if x ~= "?" then 
   i.n = i.n + 1 
   i.has[x] = 1 + (i.has[x] or 0)
   if i.has[x] > i.most then
     i.most,i.mode = i.has[x], x end end end 

function SYM.mid(i,x) return i.mode end --> n; return the mode
function SYM.div(i,x) --> n; return the entropy
  local function fun(p) return p*math.log(p,2) end
  local e=0; for _,n in pairs(i.has) do e = e + fun(n/i.n) end 
  return -e end
--------------------------------------------------------------------------------
-- ## NUM
-- Summarizes a stream of numbers.
local NUM = lib.obj"NUM"
function NUM.new(i) --> NUM;  constructor; 
  i.n, i.mu, i.m2 = 0, 0, 0
  i.lo, i.hi = math.huge, -math.huge end

function NUM.add(i,n) --> NUM; add `n`, update lo,hi and stuff needed for standard deviation
  if n ~= "?" then
    i.n  = i.n + 1
    local d = n - i.mu
    i.mu = i.mu + d/i.n
    i.m2 = i.m2 + d*(n - i.mu)
    i.lo = math.min(n, i.lo)
    i.hi = math.max(n, i.hi) end end

function NUM.mid(i,x) return i.mu end --> n; return mean
function NUM.div(i,x)  --> n; return standard deviation using Welford's algorithm http://t.ly/nn_W
    return (i.m2 <0 or i.n < 2) and 0 or (i.m2/(i.n-1))^0.5  end
-----------------------------------------------------------------------------------------
-- ## SOME
-- Hold a small sample of an infinite stream.
local SOME = lib.obj"SOME"
function SOME.new(i,max)
  i.ok, i.max, i.n = true, max or the.Some or 256, 0  
  i._has = {} end -- marked private with "_" so we do not print large lists

function SOME.add(i,x) --> nil. If full, add at odds i.max/i.n (replacing old items at random)
  if x ~= "?" then
    local pos
    i.n = i.n + 1
    if     #i._has < i.max     then pos= 1+#i._has
    elseif lib.rand() < i.max/i.n then pos= lib.rint(#i._has) end
    if pos then
       i._has[pos]=x
       i.ok=false end end end

function SOME.has(i) --> t; return kept contents, sorted
  if not i.ok then i._has = sort(i._has) end -- only resort if needed
  i.ok = true
  return i._has end

function SOME.mid(x) --> n; return the number in middle of sort
  return per(i:has(),.5) end

function SOME.div(x) --> n; return the entropy
  return (per(i:has(), .9) - per(i:has(), .1))/2.58 end
--------------------------------------------------------------------------------------------
--- ## Start-up
local eg={}

function eg.crash()        return the.some.missing.nested.field end 
function eg.stillWorking() return true == true end
function eg.the()          lib.oo(the) end
function eg.rand()
  local num1,num2 = NUM(),NUM()
  lib.srand(the.seed); for i=1,10^3 do num1:add( lib.rand() ) end
  lib.srand(the.seed); for i=1,10^3 do num2:add( lib.rand() ) end
  local m1,m2 = num1:mid(), num2:mid()
  return m1==m2 and .5 == lib.rnd(m1,1) end 

function eg.norm()
  for _,n in pairs{10,10^2,10^3} do
     print""
     local t,all,x={},0
     for i = 0,20 do t[i]=0 end
     for i=1,n do x=(.5+norm(10,2)) // 1; all=all+x; t[x]=1+(t[x] or 0) end
     for i = 4,16 do x=t[i]/all*100*100//1; print(fmt("sample=%-6.0f x=%-3s seen=%-5s = %5.1f%% %s",n,i,t[i],x/10,("*"):rep(x//5))) end end end

function eg.sym()
  local sym=SYM()
  for _,x in pairs{"a","a","a","a","b","b","c"} do sym:add(x) end
  return "a"==sym:mid() and 1.379 == lib.rnd(sym:div())end

function eg.num()
  local num=NUM()
  for _,x in pairs{1,1,1,1,2,2,3} do num:add(x) end
  return 11/7 == num:mid() and 0.787 == lib.rnd(num:div()) end 

function eg.some()
  local some=SOME(32)
  for n=1,10^4 do some:add(n) end
  oo(some)
  oo(some:has()) end

function eg.somes()
  lib.srand(the.seed)
  for _,p in pairs{1,2} do 
    print""
    print("                       num   some    delta           num   some    delta")
    print("                       ---   ----    -----           ---   ----    -----")
    for _,n in pairs{10,20,40,80,150,300,600,1200,2500,5000} do
      local num=NUM()
      local some=SOME()
      for i=1,n do 
        local r=lib.rand()^p
        num:add(r)
        some:add(r) end
      local mid1,mid2= num:mid(), some:mid()
      local div1,div2= num:div(), some:div()
      print(fmt("mid n=%s p=%s\t  mid  %.2f  %.2f  %4.0f%%", 
                n,p,mid1, mid2, 100*(mid1-mid2)/mid1),
          fmt("div  %.2f  %.2f  %4.0f%%", 
                div1, div2, 100*(div1-div2)/div1)) end  end end

if lib.required() then return {STATS=STATS} else lib.main(the,eg) end 
