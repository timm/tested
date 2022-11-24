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
local fmt,oo,per,rnd,sort=lib.fmt,lib.oo,lib.per,lib.rnd,lib.sort
-----------------------------------------------------------------------------------------
-- ## SYM
-- Summarize a stream of symbols.
local SYM = lib.obj"SYM"
function SYM:new() --> SYM; constructor
  self.n   = 0
  self.has = {}
  self.most, self.mode = 0,nil end

function SYM:add(x) --> nil;  update counts of things seen so far
  if x ~= "?" then 
   self.n = self.n + 1 
   self.has[x] = 1 + (self.has[x] or 0)
   if self.has[x] > self.most then
     self.most,self.mode = self.has[x], x end end end 

function SYM:mid(x) --> n; return the mode
  return self.mode end 

function SYM:div(x) --> n; return the entropy
  local function fun(p) return p*math.log(p,2) end
  local e=0; for _,n in pairs(self.has) do e = e - fun(n/self.n) end 
  return e end
--------------------------------------------------------------------------------
-- ## NUM
-- Summarizes a stream of numbers.
local NUM = lib.obj"NUM"
function NUM:new() --> NUM;  constructor; 
  self.n, self.mu, self.m2 = 0, 0, 0
  self.lo, self.hi = math.huge, -math.huge end

function NUM:add(n) --> NUM; add `n`, update min,max,standard deviation
  if n ~= "?" then
    self.n  = self.n + 1
    local d = n - self.mu
    self.mu = self.mu + d/self.n
    self.m2 = self.m2 + d*(n - self.mu)
    self.sd = (self.m2 <0 or self.n < 2) and 0 or (self.m2/(self.n-1))^0.5 
    self.lo = math.min(n, self.lo)
    self.hi = math.max(n, self.hi) end end

function NUM:mid(x) return self.mu end --> n; return mean
function NUM:div(x) return self.sd end --> n; return standard deviation
-----------------------------------------------------------------------------------------
-- ## SOME
-- Hold a small sample of an infinite stream.
local SOME = lib.obj"SOME"
function SOME:new(max)
  self._has, self.ok, self.max, self.n = {}, true, max or the.Some, 0  end

function SOME:add(x) --> nil. If full, add at odds i.max/i.n (replacing old items at random)
  if x ~= "?" then
    local pos
    self.n = self.n + 1
    if     #self._has < self.max     then pos= 1+#self._has
    elseif lib.rand() < self.max/self.n then pos= lib.rint(#self._has) end
    if pos then
       self._has[pos]=x
       self.ok=false end end end

function SOME:has(i) --> t; return kept contents, sorted
  if not self.ok then self._has = sort(self._has) end
  self.ok = true
  return self._has end

function SOME:mid(x) --> n; return the number in middle of sort
  return per(self:has(),.5) end

function SOME:div(x) --> n; return the entropy
  return (per(self:has(), .9) - per(self:has(), .1))/2.58 end
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
  for n=1,1000 do some:add(n) end
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
