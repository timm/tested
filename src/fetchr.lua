-- vim: ts=2 sw=2 et :
local the,help={},[[
fetchr : find a rule to fetch good rows, after peeking at just a few rows
(c) 2023 Tim Menzies <timm@ieee.org> BSD-2 license (t.ly/74ji)

USAGE: lua fetchr.lua [OPTIONS] [-g ACTION]

OPTIONS:
  -b  --budget     max peeking budget           = 20
  -B  --Bins       how to divide data           = 16
  -f  --file       csv file to load             = ../etc/data/auto93.csv
  -F  --Far        how far is long distances    = .95
  -g  --go         start up action              = nothing
  -h  --help       show help                    = false
  -m  --min        min size of clusters         = .5
  -c  --contrasts  number of contrasts          = 512
  -p  --p          distance coefficient         = 2
  -s  --seed       random number seed           = 937162211 
  -S  --Sample     search space for clustering  = 512]]
--------------------------------------------------------------------------------------
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
local function find_rogue_locals()
  for k,v in pairs(_ENV) do -- LUA trivia. Looking for rogue locals
    if not b4[k] then print( string.format("#W ?%s %s",k,type(v)) ) end end end

local function O(s,    t) --> t; create a klass and a constructor 
  t={}; t.__index = t
  return setmetatable(t, {__call=function(_,...) 
    local i=setmetatable({a=s},t); return setmetatable(t.new(i,...) or i,t) end}) end

local any,cells,cli,coerce,copy,csv,fmt,kap,keys,lines,lt
local main,many,map,o,oo,push,settings,rand,rint,rnd,sort,Seed
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
- Four spaces denote start of local args.  

In my object system, instances are named `i` (since that is shorter than `self`).--]]
--------------------------------------------------------------------------
local SYM,NUM,DATA,ROW,BIN=O"SYM",O"NUM",O"DATA",O"ROW",O"BIN" -- classes
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

function SYM:add(s,  inc)  
  if s~="?" then 
    inc = inc or 1
    self.n = self.n + 1
    self.seen[s] = inc+(self.seen[s] or 0)  
    if self.seen[s] > self.most then
      self.mode,self.most = s, self.seen[s] end  end end

function SYM:mid() return self.mode end
function SYM:div(      e,fun)
   fun = function(p) return p*math.log(p,2) end
   e=0; for _,n in pairs(self.seen) do e = e + fun(n/self.n) end;
   return -e end

function SYM:bucket(s) return s end
function SYM:tekcub(s) return s end
function SYM:dist(s1,s2)
  return  s1=="?" and s2=="?" and 1 or s1==s2 and 0 or 1 end
--------------------------------------------------------------------------
function NUM:new(nat,s)
  return {lo=math.huge, hi=-math.huge, at=nat or 0, txt=s or "",
          n=0,
          mu=0, m2=0,
          w=(s or ""):find"-$" and -1 or 1,
          bins={}} end

function NUM:mid() return self.mu end
function NUM:div() return self.sd end
function NUM:norm(n)
  return n=="?" and n or (n-self.lo)/(self.hi - self.lo +1E-32)  end

function NUM:add(n,     d)
  if n ~= "?" then
    self.n  = self.n + 1
    d       = n - self.mu
    self.mu = self.mu + d/self.n
    self.m2 = self.m2 + d*(n - self.mu)
    self.sd = (self.m2/(self.n-1))^0.5  
    self.lo = math.min(n, self.lo)
    self.hi = math.max(n, self.hi) end end
  
function NUM:bucket(n,     gap)
  if n ~="?" then gap = (self.hi - self.lo)/the.Bins 
                  return math.min(((n-self.lo)/gap//1 + 1),the.Bins) end end

function NUM:tekcub(n,   gap)
  if n ~="?" then gap = (self.hi - self.lo)/the.Bins 
                  return n==the.Bins and self.hi - gap or self.lo + gap*(n-1) end end

function NUM:dist(n1,n2)
  if n1=="?" and n2=="?" then return 1 end 
  n1, n2 = self:norm(n1), self:norm(n2)
  if n1=="?" then n1= n2<.5 and 1 or 0 end
  if n2=="?" then n2= n1<.5 and 1 or 0 end
  return math.abs(n1-n2) end

-- function force(col,x,inc)
--   if x =="?" then return end
--   if col.isNum then
--     gap=(col.hi - col.lo)/the.Bins
--
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
  some = many(rows, the.Sample)
  A    = above or any(some)
  tmp  = sort(map(some, function(r) return {row=r,dist=gap(A,r)} end),lt"dist") 
  far  = tmp[(#tmp*the.Far)//1] 
  B,c  = far.row, far.dist
  for n,tmp in pairs(sort(map(rows,proj), lt"dist")) do
    push(n <= (#rows//2) and left or right, tmp.row) end
  return left, right, A, B, c end  

function DATA:sway() --> t; returns best half, recursively
  function fun(rows,b4,  above)
    if   #rows < (#self.rows)^the.min 
    then return rows,b4 
    else local left, right, A, B = self:half(rows,self.cols.x,above)
         if self:better(B,A) then left, right, A, B = right, left, B, A end
         for _,row in pairs(right) do push(b4,row) end
         return self:sway(left, b4,A) end end 
  return fun(rows,{}) end

function DATA:stats(  what,cols,nPlaces) --> t; reports mid or div of cols (defaults to i.cols.y)
  local fun
  function fun(k,col) return rnd(getmetatable(col)[what or "mid"](col),nPlaces),col.txt end
  return kap(cols or self.cols.all, fun) end

-------------------------------------------------------------------------
function BIN:new(lo,hi) return{lo=lo,hi=hi or lo,yes=0,no=0,n=0} end

function BIN:score(     nall)
  return (bin.yes/(bin.yes+bin.no)) * bin.n/bin.nall end

function BIN:reinforce(  inc)
  inc   = inc or 1
  self.n = self.n + 1
  if inc >= 0 then self.yes=self.yes + inc else self.no=self.no - inc end end

function BIN:merged(bin,  lo,hi,bins2)
   new      = copy(self)
   new.lo   = lo or self.lo
   new.hi   = hi or bin.hi
   new.yes  = self.yes  + bin.yes
   new.no   = self.no   + bin.no
   new.n    = self.n    + bin.n 

function BIN.merges(bins,n,    fun) -- {hi,lo,yes,no,n,     all,merge1}
  function fun(now)
    local new,j,before,a,b,c = {},1,-math.huge
    while j <= #now do
      a,b = now[j],now[j+1]
      if b then 
         c = a:merged(b,before) end
         if score(c,n) >= .95*(score(a,n) + score(b,n)) then 
	         a=c; j=j+1 end end
      before = push(new,a).hi
      j=j+1
    end
    new[#new].hi =  math.huge
    return #now == #new and new or fun(new) 
  end -----------------------------
  return fun(sort(bins,lt"lo")) end
-------------------------------------------------------------------------
fmt = string.format
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
  local mult = 10^(nPlaces or 3)
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
  fun= function(k,v) return string.format(":%s %s",k,o(v)) end 
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
       print("\nACTIONS:\n  -g",". (runs all actions)") 
       for _,name in pairs(keys(funs)) do print("  -g",name) end
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
function egs.show_config() oo(the) end
function egs.test_maths()  print(10 + 10) end
function egs.NUM_test()    oo(COL(2,"Asda+")) end

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

function egs.betters(     data,t)
  data=DATA(the.file)
  t=sort(data.rows, function(a,b) return data:better(a,b) end)
  oo(data.cols.names)
  for j= 1,#data.rows,50 do
    print(j, o(t[j].cells)) end end

function egs.half(    data)
  data=DATA(the.file)
  local left,right,A,B,c = data:half() 
  left = data:clone(left)
  right = data:clone(right) 
  print("left",o(left:stats("mid",left.cols.y)))
  print("right",o(right:stats("mid",right.cols.y))) end

-------------------------------------------------------------------------
settings(help, the)

if pcall(debug.getlocal,4,1) 
then return {l=l,the=the,COL=COL,COLS=COLS,SYM=SYM,NUM=NUM,
             DATA=DATA,ROW=ROW,BIN=BIN}
else main(egs, the, help) end
