-- vim: ts=2 sw=2 et :
local the,help={},[[
fetchr : find a rule to fetch good rows, after peeking at just a few rows
(c) 2023 Tim Menzies <timm@ieee.org> BSD-2 license (t.ly/74ji)

USAGE: lua fetchr.lua [OPTIONS] [-g ACTION]

OPTIONS:
  -b  --budget     max peeking budget           = 20
  -B  --Bins       how to divide data           = 16
  -c  --contrasts  number of contrasts          = 512
  -C  --Conf       confidence for stats         = 95
  -d  --dull       cliff's delta threshold      = .147
  -f  --file       csv file to load             = ../etc/data/auto93.csv
  -F  --Far        how far is long distances    = .95
  -g  --go         start up action              = nothing
  -h  --help       show help                    = false
  -H  --Halves     search space for clustering  = 512
  -m  --min        min size of clusters         = .5
  -p  --p          distance coefficient         = 2
  -s  --seed       random number seed           = 937162211
  -S  --Some       how many nums to keep        = 256
]]
--------------------------------------------------------------------------------------
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
local function find_rogue_locals()
  for k,v in pairs(_ENV) do -- LUA trivia. Looking for rogue locals
    if not b4[k] then print( string.format("#W ?%s %s",k,type(v)) ) end end end

local function O(s,    t) --> t; create a klass and a constructor 
  t={}; t.__index = t
  return setmetatable(t, {__call=function(_,...) 
    local i=setmetatable({a=s},t); return setmetatable(t.new(i,...) or i,t) end}) end

local any,cells,cli,cliffsDelta,coerce,copy,critical,csv,fmt,kap,keys,lines,lt
local main,many,map,mwu,o,oo,per,push,settings,rand,rank,ranks,rint,rnd,sort,Seed
--------------------------------------------------------------------------------------
--[[
About this code:

This code starts with a help string and ends with a library of examples 
(see "function egs.xyz()" at end of file). Read the help and examples before anything
else. Any of the examples can be run from the command line; e.g. "-g show" runs
all the actions that start with "show". All the settings in the help string can
be changed on the command line; e.g. "lua fetchr.lua -s 3" sets the seed to 3.

In the code:
- vars are global by default unless marked with "local" or 
  defined in function argument lists.
- There is only one data structure: a table.
  - Tables can have numeric or symbolic keys.
  - Tables start and end with {}
  - #t is length of the table t (and empty tables have #t==0)
  - Tables can have numeric or symbolic fields.
    - `for pos,x in pairs(t) do` is the same as python's 
       `for pos,x in enumerate(t) do`
- Global settings are stores in "the" table which is generated from
  "help". E.g. From the above the.budget =16
- For all `key=value` in `the`, a command line flag `-k X` means `value`=X

In the function arguments, the following conventions apply (usually):
- n == number
- s == string
- t == table
- is == boolean
- x == anything
- fun == function
- UPPER = class
- lower = instance; e.g. rx is an instance of RX
- xs == a table of "x"; e.g. "ns" is a list of numbers
- Two spaces denote start of optional args
- Four spaces denote start of local args.  ]]
-------------------------------------------------------------------------
local SYM,NUM,DATA,ROW,XY=O"SYM",O"NUM",O"DATA",O"ROW",O"XY" -- classes
local COL,COLS -- factories
--------------------------------------------------------------------------------------
function COL(n,s,    col)
  col = (s:find"^[A-Z]+" and NUM or SYM)(n,s)
  col.isIgnored = col.txt:find"X$"
  col.isKlass   = col.txt:find"!$"
  col.isGoal    = col.txt:find"[!+-]$"
  return col end

function COLS(ss,     col,cols)
  cols={names=ss, all={},x={},y={}}
  for n,s in pairs(ss) do  
    col = push(cols.all, COL(n,s))
    if not col.isIgnored then
      if col.isKlass then cols.klass = col end
      push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end
--------------------------------------------------------------------------
function SYM:new(nat,s)
  return {at=nat or 0, txt=s or "",seen={},bins={},
          n=0, mode=nil,most=0} end

function SYM:clone() return SYM(self.at,self.txt) end

function SYM:add(s,  inc)  
  if s~="?" then 
    inc = inc or 1
    self.n = self.n + 1
    self.seen[s] = inc+(self.seen[s] or 0)  
    if self.seen[s] > self.most then
      self.mode,self.most = s, self.seen[s] end  end end

function SYM:mid() return self.mode end
function SYM:div(      e,fun)
  local e,fun = 0,function(p) return p*math.log(p,2) end
  for _,n in pairs(self.seen) do e = e + fun(n/self.n) end
  return -e end

function SYM:bin(s) return s end

function SYM:dist(s1,s2)
  return  s1=="?" and s2=="?" and 1 or s1==s2 and 0 or 1 end

function SYM:merge(other,     new)
  new=SYM(self.at,self.txt)
  for _,t in pairs{self.seen,other.seen} do
    for k,n in pairs(t) do new:inc(k.n) end end
  new.n = self.n + other.n 
  return new end

--------------------------------------------------------------------------
function NUM:new(nat,s)
  return {lo=math.huge, hi=-math.huge, at=nat or 0, txt=s or "",
          n=0,
          _seen={}, max=the.Some, ok=false,
          w=(s or ""):find"-$" and -1 or 1} end

function NUM:clone() return NUM(self.at,self.txt) end

function NUM:add(n) --> nil. If full, add at odds i.max/i.n (replacing old items at random)
  if n ~= "?" then
    local pos
    self.n  = self.n + 1
    self.lo = math.min(n, self.lo)
    self.hi = math.max(n, self.hi)
    if     #self._seen < self.max   then pos= 1+#self._seen
    elseif rand() < self.max/self.n then pos= rint(#self._seen) end
    if pos then
       self._seen[pos]=n
       self.ok=false end end end

function NUM:merge(other,     new)
  new=NUM(self.at,self.txt)
  for _,t in pairs{self._seen,other._seen} do
    for _,n in pairs(t) do new:add(n) end end
  self.lo = math.min(self.lo, other.lo)
  self.hi = math.max(self.hi, other.ho)
  return new end

function NUM:seen() --> t; return kept contents, sorted
  if not self.ok then self._seen = sort(self._seen) end 
  self.ok = true
  return self._seen end

function NUM:mid(x) --> n; return the number in middle of sort
  return per(self:seen(),.5) end

function NUM:div(x) --> n; return the entropy
  return (per(self:seen(), .9) - per(self:seen(), .1))/2.58 end

function NUM:norm(n)
  return n=="?" and n or (n-self.lo)/(self.hi - self.lo +1E-32)  end

function NUM:bin(n,     gap)
  if n=="?" then return n end
  gap = (self.hi - self.lo)/the.Bins 
  if n == self.hi then return self.hi - gap end
  return (n - self.lo) // gap * gap + self.lo end

function NUM:dist(n1,n2)
  if n1=="?" and n2=="?" then return 1 end 
  n1, n2 = self:norm(n1), self:norm(n2)
  if n1=="?" then n1= n2<.5 and 1 or 0 end
  if n2=="?" then n2= n1<.5 and 1 or 0 end
  return math.abs(n1-n2) end
--------------------------------------------------------------------------
function ROW:new(t) return {cells=t,yused=false} end

function ROW:guess(data,     s,x)
  s = 0
  for _,col in pairs(data.cols.x) do
    x = self.cells[col.at]
    if x ~= "?" then
      for _,bin in pairs(col.bins) do
        if bin.lo <= x and x < bin.hi then 
          s = s + bin:score(); break end end end end 
  return s end
--------------------------------------------------------------------------
function DATA:new(src,    fun)
  self.rows={}
  function fun(row) self:add(row) end 
  if type(src)=="string" then csv(src,fun) else map(src or {},fun) end end 

function DATA:add(row)
  if self.cols then
    row = row.cells and row or ROW(row)
    push(self.rows, row)
    for _,cols in pairs{self.cols.x, self.cols.y} do
      for _,col in pairs(cols) do
        col:add(row.cells[col.at]) end end 
  else self.cols = COLS(row) end end  
  
function DATA:clone(  init,     new)
  new=DATA({self.cols.names})
  for _,row in pairs(init or {}) do new:add(row) end
  return new end

function DATA:better(row1,row2,    s1,s2,ys,x,y) --> bool; true if `row1` dominates (via Zitzler04).
  row1.yused=true
  row2.yused=true
  s1,s2,ys,x,y = 0,0,self.cols.y
  for _,col in pairs(ys) do
    x  = col:norm( row1.cells[col.at] )
    y  = col:norm( row2.cells[col.at] )
    s1 = s1 - math.exp(col.w * (x-y)/#ys)
    s2 = s2 - math.exp(col.w * (y-x)/#ys) end
  return s1/#ys < s2/#ys end

function DATA:dist(row1,row2,  cols)
  local n,d,x1,x2,inc = 0,0
  for _,col in pairs(cols or self.cols.x) do
    n = n + 1
    d = d+ col:dist(row1.cells[col.at],row2.cells[col.at])^the.p end
  return (d/n)^(1/the.p) end

function DATA:half(  rows,cols,above)
  local left,right,far,gap,some,proj,tmp,A,B,c = {},{}
  function gap(r1,r2) return self:dist(r1, r2, cols) end
  function proj(r)    return {row=r, dist=(gap(r,A)^2 + c^2 - gap(r,B)^2)/(2*c)} end
  rows = rows or self.rows
  some = many(rows, the.Halves)
  A    = above or any(some)
  tmp  = sort(map(some, function(r) return {row=r,dist=gap(A,r)} end),lt"dist") 
  far  = tmp[(#tmp*the.Far)//1] 
  B,c  = far.row, far.dist
  for n,tmp in pairs(sort(map(rows,proj), lt"dist")) do
    push(n <= (#rows//2) and left or right, tmp.row) end
  return left, right, A, B, c end  

function DATA:sway(  rows,other,above) --> t; returns best half, recursively
  rows  = rows or self.rows
  if   #rows < (#self.rows)^the.min 
  then return rows,other 
  else local as, bs, a, b = self:half(rows,self.cols.x,above)
       if self:better(b,a) then as,bs,a,b = bs,as,b,a end
       other= other or bs
       return self:sway(as,other,a) end end 

function DATA:stats(  what,cols,nPlaces) --> t; reports mid or div of cols (defaults to i.cols.y)
  local fun,tmp
  function fun(k,col) return rnd(getmetatable(col)[what or "mid"](col),nPlaces),col.txt end
  tmp= kap(cols or self.cols.all, fun) 
  tmp["N"]=#self.rows
  return tmp end

function DATA:evaled(  rows)
  n=0; map(rows or self.rows, function(r) n=n+(r.yused and 1 or 0) end); return n end

function DATA:diffs(data,  cols,     diff)
  function diff(col,    x) 
    function x(row) local z = row.cells[col.at]; if z~="?" then return z end end
    local x1s,x2s = map(self.rows, x), map(data.rows, x) 
    local n1,n2 = #x1s, #x2s
    local m = math.min(n1,n2)
    if n1>10*m then x1s = many(x1s,10*m) end
    if n2>10*m then x2s = many(x2s,10*m) end
    return mwu(x1s,x2s) and not cliffsDelta(x1s,x2s),col.txt 
  end -------------------------------------
  return map(cols or self.cols.y, diff) end

-------------------------------------------------------------------------
function XY:new(at,lo,hi) 
  sselfxlef.x=UM(at)
  self.y=SYM()
  i.y=NUM(), y=SYM()} end

function XY:score(  nall) return self.ys:div() end

function XY:add(y,  inc,x)
  inc    = inc or 1
  self.n = self.n + 1
  self.ys[y] = inc + (self.ys[y] or 0) 
  if x then self.xlo = math.min(x,self.xlo)
            self.xhi = math.max(x,self.xhi) end end

function XY:merge(xy,  lo,hi,    a,b,c)
  a,b = self,xy
  c   = XY(lo or a.xlo, hi or b.xhi)
  c.n = a.n + b.n
  for _,t in pair{a.ys,b.ys} do
    for y,seen in pairs(t) do c.ys[y] = seen+(c.ys[y] or 0) end end
  return c end 

function XY.merges(xys,n,    fun,fill) -- {hi,lo,yes,no,n,     all,merge1}
  function bridge(xys)
    for j=2,#xys do xys[j].lo = xys[j-1].hi end
    xys[1].lo    = - math.huge
    xys[#xys].hi =   math.huge
    return xys end
  function fun(xys0)
    local xys1,j = {},1
    while j <= #xys0 do
      local a,b
      a,b = xys0[j],xys0[j+1]
      if b then 
         local c,sa,sb,sc
         c = a:merge(b) 
         sa,sb,sc = a:score(n), b:score(n), c:score(n)
         if sc >= .95*(a.n*sa + b.n*sb)/(a.n + b.n) then 
           a=c
           j=j+1 end end
      push(xys1,a)
      j=j+1
    end
    return #xys0 == #xys1 and xys1 or fun(xys1) 
  end -----------------------------------
  return bridge(fun(sort(xys,lt"lo"))) end
-------------------------------------------------------------------------
function cliffsDelta(ns1,ns2, dull) --> bool; true if different by a trivial amount
  local n,gt,lt = 0,0,0
  for _,x in pairs(ns1) do
    for _,y in pairs(ns2) do
      n = n + 1
      if x > y then gt = gt + 1 end
      if x < y then lt = lt + 1 end end end
  return math.abs(lt - gt)/n <= (dull or the.dull) end
---------------------------------------------------------------------------------------------------
function rank(rx) return rx.ranks/rx.n end --> n; returns average range in a treatment  

function mwu(ns1,ns2,nConf) -->bool; True if ranks of `ns1,ns2` are different at confidence `nConf` 
  local t,r1,r2,u1,u2,c = ranks(ns1,ns2)
  local n1,n2= #ns1, #ns2
  assert(n1>=3,"must be 3 or more")
  assert(n2>=3,"must be 3 or more")
  c  = critical(nConf or the.Conf or 95,n1,n2)
  r1=0; for _,x in pairs(ns1) do r1=r1+ rank(t[x]) end
  r2=0; for _,x in pairs(ns2) do r2=r2+ rank(t[x]) end
  u1 = n1*n2 + n1*(n1+1)/2 - r1
  u2 = n1*n2 + n2*(n2+1)/2 - r2
  local word = math.min(u1,u2)<=c 
  return math.min(u1,u2)<=c  end  -- not evidence evidence to say they are the same

function critical(c,n1,n2)
  local t={
    [99]={{0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2,  2,  2,  3,  3},
          {0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5,  6,  6,  7,  8},
          {0, 0, 0, 1, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 10, 11, 12, 13},
          {0, 0, 1, 2, 3, 4, 5, 6, 7, 9,10,11,12,13, 15, 16, 17, 18},
          {0, 0, 1, 3, 4, 6, 7, 9,10,12,13,15,16,18, 19, 21, 22, 24},
          {0, 1, 2, 4, 6, 7, 9,11,13,15,17,18,20,22, 24, 26, 28, 30},
          {0, 1, 3, 5, 7, 9,11,13,16,18,20,22,24,27, 29, 31, 33, 36},
          {0, 2, 4, 6, 9,11,13,16,18,21,24,26,29,31, 34, 37, 39, 42},
          {0, 2, 5, 7,10,13,16,18,21,24,27,30,33,36, 39, 42, 45, 48},
          {1, 3, 6, 9,12,15,18,21,24,27,31,34,37,41, 44, 47, 51, 54},
          {1, 3, 7,10,13,17,20,24,27,31,34,38,42,45, 49, 53, 56, 60},
          {1, 4, 7,11,15,18,22,26,30,34,38,42,46,50, 54, 58, 63, 67},
          {2, 5, 8,12,16,20,24,29,33,37,42,46,51,55, 60, 64, 69, 73},
          {2, 5, 9,13,18,22,27,31,36,41,45,50,55,60, 65, 70, 74, 79},
          {2, 6,10,15,19,24,29,34,39,44,49,54,60,65, 70, 75, 81, 86},
          {2, 6,11,16,21,26,31,37,42,47,53,58,64,70, 75, 81, 87, 92},
          {3, 7,12,17,22,28,33,39,45,51,56,63,69,74, 81, 87, 93, 99},
          {3, 8,13,18,24,30,36,42,48,54,60,67,73,79, 86, 92, 99,105}},
    [95]={{0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6,  6,  7,  7,  8},
          {0, 0, 1, 2, 3, 4, 4, 5, 6, 7, 8, 9,10,11, 11, 12, 13, 14},
          {0, 1, 2, 3, 5, 6, 7, 8, 9,11,12,13,14,15, 17, 18, 19, 20},
          {1, 2, 3, 5, 6, 8,10,11,13,14,16,17,19,21, 22, 24, 25, 27},
          {1, 3, 5, 6, 8,10,12,14,16,18,20,22,24,26, 28, 30, 32, 34},
          {2, 4, 6, 8,10,13,15,17,19,22,24,26,29,31, 34, 36, 38, 41},
          {2, 4, 7,10,12,15,17,20,23,26,28,31,34,37, 39, 42, 45, 48},
          {3, 5, 8,11,14,17,20,23,26,29,33,36,39,42, 45, 48, 52, 55},
          {3, 6, 9,13,16,19,23,26,30,33,37,40,44,47, 51, 55, 58, 62},
          {4, 7,11,14,18,22,26,29,33,37,41,45,49,53, 57, 61, 65, 69},
          {4, 8,12,16,20,24,28,33,37,41,45,50,54,59, 63, 67, 72, 76},
          {5, 9,13,17,22,26,31,36,40,45,50,55,59,64, 67, 74, 78, 83},
          {5,10,14,19,24,29,34,39,44,49,54,59,64,70, 75, 80, 85, 90},
          {6,11,15,21,26,31,37,42,47,53,59,64,70,75, 81, 86, 92, 98},
          {6,11,17,22,28,34,39,45,51,57,63,67,75,81, 87, 93, 99,105},
          {7,12,18,24,30,36,42,48,55,61,67,74,80,86, 93, 99,106,112},
          {7,13,19,25,32,38,45,52,58,65,72,78,85,92, 99,106,113,119},
          {8,14,20,27,34,41,48,55,62,69,76,83,90,98,105,112,119,127}}}
    n1,n2 = n1-2,n2-2
    local u=t[c]
    assert(u,"confidence level unknown")
    local n1 = math.min(n1,#u[1])
    local n2 = math.min(n2,#u)
    return u[n2][n1] end

function ranks(ns1,ns2) -->t; numbers of both populations are jointly ranked 
  local x,t,u = 0,{},{}
  for _,ns in pairs{ns1,ns2} do
    for _,x in pairs(ns) do t[1+#t] = x end end
  t = sort(t)
  x = t[1]
  u[x] = {x=x,n=1,ranks=1}
  for i=2,#t do
    if t[i-1] ~= t[i] then x=t[i]; u[x] = {x=x, n=0,ranks=0}  end    
    u[x].x     = t[i]
    u[x].ranks = u[x].ranks + i -- for repeated numbers, they share the rank of all the repeats
    u[x].n     = u[x].n + 1 end
  return u end
-------------------------------------------------------------------------
fmt = string.format
function per(t,p) --> num; return the `p`th(=.5) item of sorted list `t`
  p=math.floor(((p or .5)*#t)+.5); return t[math.max(1,math.min(#t,p))] end

function any(t) --> any; return any item from `t`, picked at random
  return t[rint(#t)] end

function many(t,n) --> t; return `n` items from `t`, picked at random
  local u={}; for i=1,n do push(u, any(t)) end; return u end 

function copy(t,    u) --> t; deep copy
  if type(t) ~= "table" then return t end 
  u={}; for k,v in pairs(t) do u[k]=copy(v) end
  return setmetatable(u,getmetatable(t)) end 

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

function keys(t)
  return sort(kap(t,function(k,_) return k end)) end

Seed=937162211
function rint(nlo,nhi)  return math.floor(0.5 + rand(nlo,nhi)) end
function rand(nlo,nhi) --> num; return float from `nlo`..`nhi` (default 0..1)
  nlo, nhi = nlo or 0, nhi or 1
  Seed = (16807 * Seed) % 2147483647
  return nlo + (nhi-nlo) * Seed / 2147483647 end

function rnd(n, nPlaces) --> num. return `n` rounded to `nPlaces`
  local mult = 10^(nPlaces or 2)
  return math.floor(n * mult + 0.5) / mult end

function coerce(s,    fun) --> any; return int or float or bool or string from `s`
  function fun(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function cells(s,    t)
  t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; return t end

function lines(sFilename,fun,    src,s) --> nil; call `fun` on rows (after coercing cell text)
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

function csv(sFilename,fun)
  lines(sFilename, function(line) fun(cells(line)) end) end

function oo(t) print(o(t)); return t end

function o(t,    fun) --> s; convert `t` to a string. sort named keys. 
  if type(t)~="table" then return tostring(t) end
  function fun (k,v) 
    if tostring(k):sub(1,1)~="_" then return string.format(":%s %s",k,o(v)) end end
  return "{"..table.concat(#t>0  and map(t,o) or sort(kap(t,fun))," ").."}" end

function settings(txt,t) --> t; update key,vals in `t` from command-line flags
  txt:gsub("\n[%s]+-[%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)",
           function(k,v) t[k] = coerce(v) end)  end

function cli(t)
  for k,v in pairs(t) do
    v = tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) then
        v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end 
    t[k] = coerce(v) end end

function main(funs,settings,txt,    fails,saved)
  cli(settings)
  fails,saved = 0,copy(settings)
  if   settings.help 
  then print(txt)
       print("ACTIONS:\n  -g  .  (runs all actions)") 
       for _,name in pairs(keys(funs)) do print("  -g   "..name) end
  else for _,name in pairs(keys(funs)) do
        if name:find(".*"..settings.go..".*") then
          for k,v in pairs(saved) do settings[k]=v end
          Seed = settings.seed
          if funs[name]()==false then print("❌ "..name); fails=fail+1
                                 else print("✅ "..name) end end end end
  find_rogue_locals()
  os.exit(fails) end  

-------------------------------------------------------------------------
local egs={}
function egs.alternatives() oo(the) end
function egs.COL()    oo(COL(2,"Asda+")) end

function egs.NUM(     num)
  num=NUM()
  num.max=32
  for i=1,10000 do num:add(i) end
  oo(num:seen()) end

function egs.cols_test(     t) 
  t={"aa","bbX","Funds+","Wght-","Age-"}
  oo(t)
  map(COLS(t).y,oo) end

function egs.csv_test(     n) 
  n=0
  csv(the.file, function(t) n=n+#t end)
  return n==3192 end

function egs.data_test(      data)
  data = DATA(the.file)
  map(data.cols.y,oo)
  print(#data.rows) end

function egs.data_clone(     data1,data2)
  data1 = DATA(the.file)
  data2 = data1:clone(data1.rows) 
  oo(data1.cols.y[1])
  oo(data2.cols.y[1])
end

function egs.dists(    data)
  data=DATA(the.file)
  for j=1,#data.rows,30 do 
    print(j,fmt("%s",data:dist(data.rows[1],data.rows[j]),
                     o(data.rows[j].cells))) end end

function egs.row_sort(     data,t)
  data=DATA(the.file)
  t=sort(data.rows, function(a,b) return data:better(a,b) end)
  oo(data.cols.names)
  for j= 1,#data.rows,50 do
    print(j, o(t[j].cells)) end end

function egs.row_split(    data)
  data=DATA(the.file)
  local left,right,A,B,c = data:half() 
  left = data:clone(left)
  right = data:clone(right) 
  print("left",o(left:stats("mid",left.cols.y)))
  print("right",o(right:stats("mid",right.cols.y))) end

function egs.row_sway(    data,a,b,c)
  local function p(s) return fmt("%-10s",s) end
  local function fun(s,d)
    print(p(s), o(d:stats("mid",d.cols.y)), o(d:stats("div",d.cols.y))) end
  data = DATA(the.file)
  a,b  = data:sway() 
  a    = data:clone(a) 
  b    = data:clone(b)
  c    = data:clone(many(data.rows, data:evaled()))
  fun("a= all", data)
  fun("\nr= rand", c)
  fun("b= best", a)
  fun("w= worst", b)
  print(p"b vs w", o(a:diffs(b, b.cols.y)))
  print(p"b vs r", o(a:diffs(c, c.cols.y)))
end

function egs.stats_eg1()
  print("false",mwu( {8,7,6,2,5,8,7,3},{8,7,6,2,5,8,7,3}))
  print("true",mwu( {8,7,6,2,5,8,7,3}, {9,9,7,8,10,9,6})) end

function egs.stats_eg2()
  print("false",mwu( {8,7,6,2,5,8,7,3},{8,7,6,2,5,8,7,3}))
  print("true",mwu( {8,7,6,2,5,8,7,3}, {9,9,7,8,10,9,6})) end

 -------------------------------------------------------------------------
settings(help, the)

if pcall(debug.getlocal,4,1) 
then return {l=l,the=the,COL=COL,COLS=COLS,SYM=SYM,NUM=NUM,
             DATA=DATA,ROW=ROW,BIN=BIN}
else main(egs, the, help) end
