local b4={}; for x,_ in pairs(_ENV) do b4[x]=x end -- trivia; used to find rogue locals
local help=[[
fishr.lua : fish for a few best in a large sea of many (basic demo)
(c)2022 Tim Menzies <timm@ieee.org> BSD-2 license
   
         /\
       _/./
    ,-'    `-:..-'/
   : o )      _  (
   "`-....,--; `-.\
       `'          Max
]]
--[[
In this code
- vars are global by default unless marked with "local"
- functions have to be defined before they are used.
- #t is length of list t (and empty lists have #t==0)
- tables start and end with {}
- tables can have numeric or symbolic fields.
- for pos,x in pairs(t) do is the same as python's 
  for pos,x in enumerate(t) do

In my pubic function arguments:
- n == number
- s == string
- t == table
- is == boolean
- x == anything
- fun == function
- UPPER = class

--]]
local the={bins=16,
           samples=20,
           seed=1} -- global config
local fmt,any,push,map,sort,want,lt,many,display,same,shuffle,copy,keys,oo,o,percents,show,obj
local _id=0
function obj(s,    t,new) --> t; create a klass and a constructor + print method
  function new(k,...) _id=_id+1; local x=setmetatable({_id=_id},k); t.new(x,...); return x end
  t={_is=s, __tostring = o}
  t.__index = t;return setmetatable(t,{__call=new}) end
--------------------------------------------------------------------------------------------------
local COL= obj"COL"
function COL:new(n,s)
  self.name = s or ""  -- column name
  self.at   = n or 0   -- column index
  self.is   = {goal    = (s or ""):find"[+-]$",
               good    = (s or ""):find"[+]$",
               num     = (s or ""):find"^[A-Z]+",
               ignored = (s or ""):find"X$"}
  self._good  = nil -- positive votes
  self._bad  = nil -- positive votes
  if    self.is.num 
  then  self.lo   =  math.huge
        self.hi   = -math.huge 
  else  self.has={} end end 

function COL:add(x)
  if x=="?" then return x end
  if   self.is.num   -- asdas 
  then self.lo = math.min(self.lo, x)
       self.hi = math.max(self.hi, x) 
  else self.has[x] = 1 + (self.has[x] or 0) end end

function COL:norm(n)
  if x=="?" or not self.is.num then return n end
  return n=="?" and n or (n - self.lo)/(self.hi - self.lo + 1E-32) end

function COL:bins()
  local t={}
  if self.is.num then
    local gap = (self.hi - self.lo)/the.bins 
    for i=1,the.bins do  
      local lo = self.lo+gap*(i-1)
      push(t,{n=0, lo=lo, hi=lo+gap})  end
    t[ 1].lo = -math.huge
    t[#t].hi =  math.huge
  else 
    for k,_ in pairs(self.has) do 
      t[k] = {n=0, lo=k, hi=k} end end 
  return t end 

function COL:reinforce(bins, x, nForce)
  if x=="?" then return end
  for i,bin in pairs(bins) do 
     if  bin.lo <= x and x <= bin.hi then
       local l0    = bin
       local l1,l2 = bins[i-1] or l0, bins[i-2] or l0
       local r1,r2 = bins[i+1] or l0, bins[i+2] or l0
       l0.n = l0.n + nForce*.4
       l1.n = l1.n + nForce*.2; 
       r1.n = r1.n + nForce*.2; 
       l2.n = l2.n + nForce*.1
       r2.n = r2.n + nForce*.1
       return end end
  assert(false,"bad lookup for ".. x) end
--------------------------------------------------------------------------------------------------
local COLS =obj"COLS"
function COLS:new(t)    
  self.names,self.all,self.x,self.y = t,{},{},{}
  for n,s in pairs(t) do
    local col = push(self.all, COL(n,s))
    if not col.is.ignored then
      push(col.is.goal and self.y or self.x, col) end end end

function COLS:height(row)
  row.evaluated = true
  map(self.y, function(col) col:add(row.cells[col.at]) end) 
  local height,n,sq = 0,0,math.sqrt
  for _,col in pairs(self.y) do 
    local x = row.cells[col.at]
    if x ~= "?" then
      n   = n+1
      height = height + math.abs(col:norm(x) - (col.is.good and 0 or 1))^2 end end 
  return sq(height)/sq(n) end

function COLS:reinforce(row1,row2)
  local h1,h2 = self:height(row1), self:height(row2)
  local gap = math.abs(h1 - h2)
  if h2>h1 then row1,row2,h1,h2 = row2,row1,h2,h1 end
  for _,col in pairs(self.x) do
    print(333,col.name)
    col._good = col._good or col:bins()
    col._bad = col._bad or col:bins()
    print(444)
    col:reinforce(col._good, row1.cells[col.at], gap)
    col:reinforce(col._bad,  row2.cells[col.at], gap) end end 
--------------------------------------------------------------------------------------------------
local ROW=obj"ROW"
function ROW:new(t) self.cells = t; self.evaluated = false; self.truth=0 end

function ROW:rank(cols)
  local pos,neg = 0,0
  for _,col in pairs(cols.x) do
    local x = col:bin(self.cells[col.at])
    if x ~= "?" then 
      pos = pos + (col.pos[x] or 1E-31)
      neg = neg + (col.neg[x] or 1E-31) end end
  return  -neg end -- ==pos^2/(pos+neg+1E-32)  end --pos^2/(pos+neg) end
--------------------------------------------------------------------------------------------------
local DATA = obj"DATA"
function DATA:new(t)
  self.rows, self.cols = {}, COLS(table.remove(t,1))
  for _,t1 in pairs(t or {}) do self:add(t1) end end

function DATA:add(t)
  local row = t.cells and t or ROW(t)
  push(self.rows, row)
  for _,col in pairs(self.cols.x) do col:add(row.cells[col.at]) end end 

function DATA:clone(inits)
  local data1=DATA({self.cols.names})
  map(inits or {}, function(t) data1:add(t)  end)
  return data1 end

function DATA:descending(t)
  local function fun(row1,row2) return self.cols:height(row1) > self.cols:height(row2) end
  return sort(t or self.rows,fun) end

function DATA:truth()
  for rank,row in pairs(self:descending()) do row.truth = math.floor(100*rank/(#self.rows)) end 
  return self:clone(self.rows) end 

function DATA:guess(t)
  return sort(t or self.rows, function(r1,r2) return r1:rank(self.cols) > r2:rank(self.cols) end) end

function DATA:learn(rows) 
  local n = the.samples
  local some = many(rows or self.rows, the.samples)
  for i=1,n do
    for j=i+1,n do  self.cols:reinforce(some[i], some[j]) ; print(22) end end end
--------------------------------------------------------------------------------------------------
-- library functions
fmt=string.format
function same(x)    return x end
function any(t)     return t[math.random(#t)] end
function many(t,n)  local u={}; for i=1,n do push(u,any(t)) end; return u end
function push(t,x)  t[1+#t]=x; return x end
function map(t,fun) local u={}; for _,x in pairs(t) do u[1+#u] = fun(x) end; return u end
function shuffle(t,   j) --> t;  Randomly shuffle, in place, the list `t`.
  for i=#t,2,-1 do j=math.random(i); t[i],t[j]=t[j],t[i] end; return t end

function percents(t)
  local n= 0
  for k,v in pairs(t) do n=n+v end
  local u={}; for k,v in pairs(t) do u[k] = math.floor(100*v/n) end; return u end

function sort(t,fun) table.sort(t,fun); return t end
function lt(x) return function(a,b) return a[x] < b[x] end end
function copy(t)
  if type(t) ~= "table" then return t end
  local u={}; for k,v in pairs(t) do u[k] = copy(v) end
  return u end

function show(k) if tostring(k):sub(1,1) ~= "_" then return k end end
function keys(t,    u) u={};for k,v in pairs(t) do if show(k) then u[1+#u]=k end end; return u end

function oo(x) print(o(x)); return x end
function o(t,     u,key)
  if type(t) ~= "table" then return tostring(t) end
  function key(k) return fmt(":%s %s",k,o(t[k])) end
  u= #t>0 and map(t,o) or map(sort(keys(t)), key)
  return (t._is or "").."{".. table.concat(u," ").."}" end
--------------------------------------------------------------------------------------------------
local function auto93() return copy{
{"clndrs","Volume","HpX","Lbs-","Acc+","Model","origin","Mpg+"},
{8,304.0,193,4732,18.5,70,1,10},
{8,360,215,4615,14,70,1,10},
{8,307,200,4376,15,70,1,10},
{8,318,210,4382,13.5,70,1,10},
{8,429,208,4633,11,72,1,10},
{8,400,150,4997,14,73,1,10},
{8,350,180,3664,11,73,1,10},
{8,383,180,4955,11.5,71,1,10},
{8,350,160,4456,13.5,72,1,10},
{8,429,198,4952,11.5,73,1,10},
{8,455,225,4951,11,73,1,10},
{8,400,167,4906,12.5,73,1,10},
{8,350,180,4499,12.5,73,1,10},
{8,400,170,4746,12,71,1,10},
{8,400,175,5140,12,71,1,10},
{8,350,165,4274,12,72,1,10},
{8,350,155,4502,13.5,72,1,10},
{8,400,190,4422,12.5,72,1,10},
{8,307,130,4098,14,72,1,10},
{8,302,140,4294,16,72,1,10},
{8,350,175,4100,13,73,1,10},
{8,350,145,3988,13,73,1,10},
{8,400,150,4464,12,73,1,10},
{8,351,158,4363,13,73,1,10},
{8,440,215,4735,11,73,1,10},
{8,360,175,3821,11,73,1,10},
{8,360,170,4654,13,73,1,10},
{8,350,150,4699,14.5,74,1,10},
{8,302,129,3169,12,75,1,10},
{8,318,150,3940,13.2,76,1,10},
{8,350,145,4055,12,76,1,10},
{8,302,130,3870,15,76,1,10},
{8,318,150,3755,14,76,1,10},
{8,454,220,4354,9,70,1,10},
{8,440,215,4312,8.5,70,1,10},
{8,455,225,4425,10,70,1,10},
{8,340,160,3609,8,70,1,10},
{8,455,225,3086,10,70,1,10},
{8,350,165,4209,12,71,1,10},
{8,400,175,4464,11.5,71,1,10},
{8,351,153,4154,13.5,71,1,10},
{8,318,150,4096,13,71,1,10},
{8,400,175,4385,12,72,1,10},
{8,351,153,4129,13,72,1,10},
{8,318,150,4077,14,72,1,10},
{8,304,150,3672,11.5,73,1,10},
{8,302,137,4042,14.5,73,1,10},
{8,318,150,4237,14.5,73,1,10},
{8,318,150,4457,13.5,74,1,10},
{8,302,140,4638,16,74,1,10},
{8,304,150,4257,15.5,74,1,10},
{8,351,148,4657,13.5,75,1,10},
{8,351,152,4215,12.8,76,1,10},
{8,350,165,3693,11.5,70,1,20},
{8,429,198,4341,10,70,1,20},
{8,390,190,3850,8.5,70,1,20},
{8,383,170,3563,10,70,1,20},
{8,400,150,3761,9.5,70,1,20},
{8,318,150,4135,13.5,72,1,20},
{8,304,150,3892,12.5,72,1,20},
{8,318,150,3777,12.5,73,1,20},
{8,350,145,4082,13,73,1,20},
{8,318,150,3399,11,73,1,20},
{6,250,100,3336,17,74,1,20},
{6,250,72,3432,21,75,1,20},
{6,250,72,3158,19.5,75,1,20},
{8,350,145,4440,14,75,1,20},
{6,258,110,3730,19,75,1,20},
{8,302,130,4295,14.9,77,1,20},
{8,304,120,3962,13.9,76,1,20},
{8,318,145,4140,13.7,77,1,20},
{8,350,170,4165,11.4,77,1,20},
{8,400,190,4325,12.2,77,1,20},
{8,351,142,4054,14.3,79,1,20},
{8,304,150,3433,12,70,1,20},
{6,225,105,3439,15.5,71,1,20},
{6,250,100,3278,18,73,1,20},
{8,400,230,4278,9.5,73,1,20},
{6,250,100,3781,17,74,1,20},
{6,258,110,3632,18,74,1,20},
{8,302,140,4141,14,74,1,20},
{8,400,170,4668,11.5,75,1,20},
{8,318,150,4498,14.5,75,1,20},
{6,250,105,3897,18.5,75,1,20},
{8,318,150,4190,13,76,1,20},
{8,400,180,4220,11.1,77,1,20},
{8,351,149,4335,14.5,77,1,20},
{6,163,133,3410,15.8,78,2,20},
{6,168,120,3820,16.7,76,2,20},
{8,350,180,4380,12.1,76,1,20},
{8,351,138,3955,13.2,79,1,20},
{8,350,155,4360,14.9,79,1,20},
{8,302,140,3449,10.5,70,1,20},
{6,250,100,3329,15.5,71,1,20},
{8,304,150,3672,11.5,72,1,20},
{6,231,110,3907,21,75,1,20},
{8,260,110,4060,19,77,1,20},
{6,163,125,3140,13.6,78,2,20},
{8,305,130,3840,15.4,79,1,20},
{8,305,140,4215,13,76,1,20},
{6,258,95,3193,17.8,76,1,20},
{8,305,145,3880,12.5,77,1,20},
{6,250,110,3520,16.4,77,1,20},
{8,318,140,4080,13.7,78,1,20},
{8,302,129,3725,13.4,79,1,20},
{6,225,85,3465,16.6,81,1,20},
{6,231,165,3445,13.4,78,1,20},
{8,307,130,3504,12,70,1,20},
{8,318,150,3436,11,70,1,20},
{6,199,97,2774,15.5,70,1,20},
{6,232,100,3288,15.5,71,1,20},
{6,258,110,2962,13.5,71,1,20},
{6,250,88,3139,14.5,71,1,20},
{4,121,112,2933,14.5,72,2,20},
{6,225,105,3121,16.5,73,1,20},
{6,232,100,2945,16,73,1,20},
{6,250,88,3021,16.5,73,1,20},
{6,232,100,2789,15,73,1,20},
{3,70,90,2124,13.5,73,3,20},
{6,225,105,3613,16.5,74,1,20},
{6,250,105,3459,16,75,1,20},
{6,225,95,3785,19,75,1,20},
{6,171,97,2984,14.5,75,1,20},
{6,250,78,3574,21,76,1,20},
{6,258,120,3410,15.1,78,1,20},
{8,302,139,3205,11.2,78,1,20},
{8,318,135,3830,15.2,79,1,20},
{6,250,110,3645,16.2,76,1,20},
{6,250,98,3525,19,77,1,20},
{8,360,150,3940,13,79,1,20},
{6,225,110,3620,18.7,78,1,20},
{6,232,100,2634,13,71,1,20},
{6,250,88,3302,15.5,71,1,20},
{6,250,100,3282,15,71,1,20},
{3,70,97,2330,13.5,72,3,20},
{4,122,85,2310,18.5,73,1,20},
{4,121,112,2868,15.5,73,2,20},
{6,232,100,2901,16,74,1,20},
{6,225,95,3264,16,75,1,20},
{6,232,90,3211,17,75,1,20},
{4,120,88,3270,21.9,76,2,20},
{6,156,108,2930,15.5,76,3,20},
{6,225,100,3630,17.7,77,1,20},
{6,225,90,3381,18.7,80,1,20},
{6,231,105,3535,19.2,78,1,20},
{8,305,145,3425,13.2,78,1,20},
{8,267,125,3605,15,79,1,20},
{8,318,140,3735,13.2,78,1,20},
{6,232,90,3210,17.2,78,1,20},
{6,200,85,2990,18.2,79,1,20},
{8,260,110,3365,15.5,78,1,20},
{4,140,90,2408,19.5,72,1,20},
{4,97,88,2279,19,73,3,20},
{4,114,91,2582,14,73,2,20},
{6,156,122,2807,13.5,73,3,20},
{6,198,95,3102,16.5,74,1,20},
{8,262,110,3221,13.5,75,1,20},
{6,232,100,2914,16,75,1,20},
{6,225,100,3651,17.7,76,1,20},
{4,130,102,3150,15.7,76,2,20},
{8,302,139,3570,12.8,78,1,20},
{6,200,85,2965,15.8,78,1,20},
{6,232,90,3265,18.2,79,1,20},
{6,200,88,3060,17.1,81,1,20},
{4,131,103,2830,15.9,78,2,20},
{6,231,105,3425,16.9,77,1,20},
{6,200,95,3155,18.2,78,1,20},
{6,225,100,3430,17.2,78,1,20},
{6,231,105,3380,15.8,78,1,20},
{6,225,110,3360,16.6,79,1,20},
{6,200,85,3070,16.7,78,1,20},
{6,200,85,2587,16,70,1,20},
{6,199,90,2648,15,70,1,20},
{4,122,86,2226,16.5,72,1,20},
{4,120,87,2979,19.5,72,2,20},
{4,140,72,2401,19.5,73,1,20},
{6,155,107,2472,14,73,1,20},
{6,200,"?",2875,17,74,1,20},
{6,231,110,3039,15,75,1,20},
{4,134,95,2515,14.8,78,3,20},
{4,121,110,2600,12.8,77,2,20},
{3,80,110,2720,13.5,77,3,20},
{6,231,115,3245,15.4,79,1,20},
{4,121,115,2795,15.7,78,2,20},
{6,198,95,2833,15.5,70,1,20},
{4,140,72,2408,19,71,1,20},
{4,121,76,2511,18,72,2,20},
{4,122,86,2395,16,72,1,20},
{4,108,94,2379,16.5,73,3,20},
{4,121,98,2945,14.5,75,2,20},
{6,225,100,3233,15.4,76,1,20},
{6,250,105,3353,14.5,76,1,20},
{6,146,97,2815,14.5,77,3,20},
{6,232,112,2835,14.7,82,1,20},
{4,140,88,2890,17.3,79,1,20},
{6,231,110,3415,15.8,81,1,20},
{6,232,90,3085,17.6,76,1,20},
{4,122,86,2220,14,71,1,20},
{4,97,54,2254,23.5,72,2,20},
{4,120,97,2506,14.5,72,3,20},
{6,198,95,2904,16,73,1,20},
{4,140,83,2639,17,75,1,20},
{4,140,78,2592,18.5,75,1,20},
{4,115,95,2694,15,75,2,20},
{4,120,88,2957,17,75,2,20},
{8,350,125,3900,17.4,79,1,20},
{4,151,"?",3035,20.5,82,1,20},
{4,156,105,2745,16.7,78,1,20},
{6,173,110,2725,12.6,81,1,20},
{4,140,"?",2905,14.3,80,1,20},
{3,70,100,2420,12.5,80,3,20},
{4,151,85,2855,17.6,78,1,20},
{4,119,97,2405,14.9,78,3,20},
{8,260,90,3420,22.2,79,1,20},
{4,113,95,2372,15,70,3,20},
{4,107,90,2430,14.5,70,2,20},
{4,113,95,2278,15.5,72,3,20},
{4,116,75,2158,15.5,73,2,20},
{4,121,110,2660,14,73,2,20},
{4,90,75,2108,15.5,74,2,20},
{4,120,97,2489,15,74,3,20},
{4,134,96,2702,13.5,75,3,20},
{4,119,97,2545,17,75,3,20},
{6,200,81,3012,17.6,76,1,20},
{4,140,92,2865,16.4,82,1,20},
{6,146,120,2930,13.8,81,3,20},
{4,151,90,3003,20.1,80,1,20},
{4,98,60,2164,22.1,76,1,20},
{4,151,88,2740,16,77,1,20},
{4,110,87,2672,17.5,70,2,30},
{4,104,95,2375,17.5,70,2,30},
{4,113,95,2228,14,71,3,30},
{4,98,"?",2046,19,71,1,30},
{4,97.5,80,2126,17,72,1,30},
{4,140,75,2542,17,74,1,30},
{4,90,71,2223,16.5,75,2,30},
{4,121,115,2671,13.5,75,2,30},
{4,116,81,2220,16.9,76,2,30},
{4,140,92,2572,14.9,76,1,30},
{6,181,110,2945,16.4,82,1,30},
{4,140,88,2720,15.4,78,1,30},
{4,183,77,3530,20.1,79,2,30},
{6,168,116,2900,12.6,81,3,30},
{4,122,96,2300,15.5,77,1,30},
{4,140,89,2755,15.8,77,1,30},
{4,156,92,2620,14.4,81,1,30},
{4,97,46,1835,20.5,70,2,30},
{4,121,113,2234,12.5,70,2,30},
{4,91,70,1955,20.5,71,1,30},
{4,96,69,2189,18,72,2,30},
{4,97,46,1950,21,73,2,30},
{4,98,90,2265,15.5,73,2,30},
{4,122,80,2451,16.5,74,1,30},
{4,79,67,1963,15.5,74,2,30},
{4,97,78,2300,14.5,74,2,30},
{4,116,75,2246,14,74,2,30},
{4,108,93,2391,15.5,74,3,30},
{4,98,79,2255,17.7,76,1,30},
{4,97,75,2265,18.2,77,3,30},
{4,156,92,2585,14.5,82,1,30},
{4,140,88,2870,18.1,80,1,30},
{4,140,72,2565,13.6,76,1,30},
{4,151,84,2635,16.4,81,1,30},
{8,350,105,3725,19,81,1,30},
{6,173,115,2700,12.9,79,1,30},
{4,97,88,2130,14.5,70,3,30},
{4,97,88,2130,14.5,71,3,30},
{4,97,60,1834,19,71,2,30},
{4,97,88,2100,16.5,72,3,30},
{4,101,83,2202,15.3,76,2,30},
{4,112,88,2640,18.6,82,1,30},
{4,151,90,2735,18,82,1,30},
{4,151,90,2950,17.3,82,1,30},
{4,140,86,2790,15.6,82,1,30},
{4,119,97,2300,14.7,78,3,30},
{4,141,71,3190,24.8,79,2,30},
{4,135,84,2490,15.7,81,1,30},
{4,121,80,2670,15,79,1,30},
{4,134,95,2560,14.2,78,3,30},
{4,156,105,2800,14.4,80,1,30},
{4,140,90,2264,15.5,71,1,30},
{4,116,90,2123,14,71,2,30},
{4,97,92,2288,17,72,3,30},
{4,98,80,2164,15,72,1,30},
{4,90,75,2125,14.5,74,1,30},
{4,107,86,2464,15.5,76,2,30},
{4,97,75,2155,16.4,76,3,30},
{4,151,90,2678,16.5,80,1,30},
{4,112,88,2605,19.6,82,1,30},
{4,120,79,2625,18.6,82,1,30},
{4,141,80,3230,20.4,81,2,30},
{4,151,90,2670,16,79,1,30},
{6,173,115,2595,11.3,79,1,30},
{4,68,49,1867,19.5,73,2,30},
{4,98,83,2219,16.5,74,2,30},
{4,97,75,2171,16,75,3,30},
{4,90,70,1937,14,75,2,30},
{4,85,52,2035,22.2,76,1,30},
{4,90,70,1937,14.2,76,2,30},
{4,97,78,1940,14.5,77,2,30},
{4,135,84,2525,16,82,1,30},
{4,97,71,1825,12.2,76,2,30},
{4,98,68,2135,16.6,78,3,30},
{4,134,90,2711,15.5,80,3,30},
{4,89,62,1845,15.3,80,2,30},
{4,98,65,2380,20.7,81,1,30},
{4,79,70,2074,19.5,71,2,30},
{4,88,76,2065,14.5,71,2,30},
{4,111,80,2155,14.8,77,1,30},
{4,97,67,1985,16.4,77,3,30},
{4,98,68,2155,16.5,78,1,30},
{4,146,67,3250,21.8,80,2,30},
{4,135,84,2385,12.9,81,1,30},
{4,98,63,2051,17,77,1,30},
{4,97,78,2190,14.1,77,2,30},
{6,145,76,3160,19.6,81,2,30},
{4,105,75,2230,14.5,78,1,30},
{4,71,65,1773,19,71,3,30},
{4,79,67,1950,19,74,3,30},
{4,76,52,1649,16.5,74,3,30},
{4,79,67,2000,16,74,2,30},
{4,112,85,2575,16.2,82,1,30},
{4,91,68,1970,17.6,82,3,30},
{4,119,82,2720,19.4,82,1,30},
{4,120,75,2542,17.5,80,3,30},
{4,98,68,2045,18.5,77,3,30},
{4,89,71,1990,14.9,78,2,30},
{4,120,74,2635,18.3,81,3,30},
{4,85,65,2020,19.2,79,3,30},
{4,89,71,1925,14,79,2,30},
{4,71,65,1836,21,74,3,30},
{4,83,61,2003,19,74,3,30},
{4,85,70,1990,17,76,3,30},
{4,91,67,1965,15.7,82,3,30},
{4,144,96,2665,13.9,82,3,30},
{4,135,84,2295,11.6,82,1,30},
{4,98,70,2120,15.5,80,1,30},
{4,108,75,2265,15.2,80,3,30},
{4,97,67,2065,17.8,81,3,30},
{4,107,72,2290,17,80,3,30},
{4,108,75,2350,16.8,81,3,30},
{6,168,132,2910,11.4,80,3,30},
{4,78,52,1985,19.4,78,3,30},
{4,119,100,2615,14.8,81,3,30},
{4,91,53,1795,17.5,75,3,30},
{4,91,53,1795,17.4,76,3,30},
{4,105,74,2190,14.2,81,2,30},
{4,85,70,1945,16.8,77,3,30},
{4,98,83,2075,15.9,77,1,30},
{4,151,90,2556,13.2,79,1,30},
{4,107,75,2210,14.4,81,3,30},
{4,97,67,2145,18,80,3,30},
{4,112,88,2395,18,82,1,30},
{4,108,70,2245,16.9,82,3,30},
{4,86,65,1975,15.2,79,3,30},
{4,91,68,1985,16,81,3,30},
{4,105,70,2200,13.2,79,1,30},
{4,97,78,2188,15.8,80,2,30},
{4,98,65,2045,16.2,81,1,30},
{4,105,70,2150,14.9,79,1,30},
{4,100,"?",2320,15.8,81,2,30},
{4,105,63,2215,14.9,81,1,30},
{4,72,69,1613,18,71,3,40},
{4,122,88,2500,15.1,80,2,40},
{4,81,60,1760,16.1,81,3,40},
{4,98,80,1915,14.4,79,1,40},
{4,79,58,1825,18.6,77,2,40},
{4,105,74,1980,15.3,82,2,40},
{4,98,70,2125,17.3,82,1,40},
{4,120,88,2160,14.5,82,3,40},
{4,107,75,2205,14.5,82,3,40},
{4,135,84,2370,13,82,1,40},
{4,98,66,1800,14.4,78,1,40},
{4,91,60,1800,16.4,78,3,40},
{4,121,67,2950,19.9,80,2,40},
{4,119,92,2434,15,80,3,40},
{4,85,65,1975,19.4,81,3,40},
{4,91,68,2025,18.2,82,3,40},
{4,86,65,2019,16.4,80,3,40},
{4,91,69,2130,14.7,79,2,40},
{4,89,62,2050,17.3,81,3,40},
{4,105,63,2125,14.7,82,1,40},
{4,91,67,1965,15,82,3,40},
{4,91,67,1995,16.2,82,3,40},
{6,262,85,3015,17,82,1,40},
{4,89,60,1968,18.8,80,3,40},
{4,86,64,1875,16.4,81,1,40},
{4,79,58,1755,16.9,81,3,40},
{4,85,70,2070,18.6,78,3,40},
{4,85,65,2110,19.2,80,3,40},
{4,85,"?",1835,17.3,80,2,40},
{4,98,76,2144,14.7,80,2,40},
{4,90,48,1985,21.5,78,2,40},
{4,90,48,2335,23.7,80,2,40},
{4,97,52,2130,24.6,82,2,40},
{4,90,48,2085,21.7,80,2,40},
{4,91,67,1850,13.8,80,3,40},
{4,86,65,2110,17.9,80,3,50}
} end

local eg={}
eg["--all"] = {"run all actions", function() 
  local b4 = copy(the)
  for _,key in pairs(sort(keys(eg))) do 
    if key:sub(1,1)  ~="-" then
      print("seed",the.seed)
      math.randomseed(the.seed)
      eg[key][2]()  end end end }

eg["-h"] = {"show help", function() 
  print("\n"..help)
  print("USAGE: lua stats.lua ACTION [SEED]\n\nACTIONS:")
  for _,key in pairs(sort(keys(eg))) do  print(fmt("   %-10s  %s",key, eg[key][1])) end end}

eg.cols = {"test cols creation", function()
    local header={"Clndrs","Volume","HpX","Lbs-","Acc+","Model","origin","Mpg+"}
    print(o(header),"==>\n")
    map(COLS(header).all,oo) end}

eg.one = {"test basic load", function() DATA(map(auto93(),same)) end}
eg.load= {"test reading data", function() 
  oo(DATA(map(auto93(),same)).cols.x[4]) end}
eg.clone = {"test cloning data", function() 
  local data1=DATA(auto93())
  oo(data1.cols.x[4]) 
  local data2=data1:clone(data1.rows)
  oo(data2.cols.x[4]) 
  oo(data2.cols.y[1]) 
end}

eg.learn={"learn from 1 example",function() 
  local data= DATA(auto93())
  data:learn() 
end}

function display(prompt, data,n,t)
  print""
  for i=1,the.samples,2 do 
    print(i,fmt("%s\ttruth=[%3s] %s",
                 prompt, 
                 t[i].truth, 
                 o(t[i].cells))) end end

eg["learns"] = {"learn from different in a few examples", function() 
  local data= DATA(map(auto93(),same))

  -- just look at the differences between a few examples
  data = data:truth()
  data.rows=shuffle(data.rows)
  data:learn()
  for _,col in pairs(data.cols.x) do
    local pos,neg = percents(col.pos), percents(col.neg)
    for _,k in pairs(sort(keys(neg))) do 
      local b=pos[k] or 0
      local r=neg[k] or 0
     print(col.name,fmt("%8.3f",k), neg[k],("*"):rep(neg[k])) end end
  local tmp={}
  for i,row in pairs(data:guess()) do if i <= the.samples then tmp[1+#tmp] = row end end 
  display("guess       ",data,32,data:descending(tmp))
  -- use all the information
  --data.rows=shuffle(data.rows)
  --display("ground truth",data,the.samples,data:truth(data.rows))

  -- baseline against just trying a few examples random
  data.rows=shuffle(data.rows)
  display("random      ",data,the.samples, sort(many(data.rows,the.samples),lt"truth"))

end}

if arg[2] then the.seed=tonumber(arg[2]) end

if arg[1] then 
  assert(eg[arg[1]],"unknown action "..arg[1]) 
  math.randomseed(the.seed)
  print("seed",the.seed)
  eg[arg[1]][2]()  end

for x,y in pairs(_ENV) do if not b4[x] then print("?",x,type(y)) end end

