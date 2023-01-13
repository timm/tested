-- vim: ts=2 sw=2 et :
local l={the={},help=[[
fetchr : find a rule to fetch good rows, after peeking at just a few rows
(c) 2023 Tim Menzies <timm@ieee.org> BSD-2 license (t.ly/74ji)

USAGE: lua fetchr.lua [OPTIONS] [-g ACTION]

OPTIONS:
  -b  --budget  max peeking budget           = 20
  -B  --Bins    how to divide data           = 16
  -f  --file    csv file to load             = ../etc/data/auto93.csv
  -F  --Far     how far is long distances    = .95
  -g  --go      start up action              = nothing
  -h  --help    show help                    = false
  -p  --p       distance coefficient         = 2
  -s  --seed    random number seed           = 937162211 
  -S  --Sample  search space for clustering  = 512

ACTIONS:]]}
--------------------------------------------------------------------------------------
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end -- used at end to find rogue locals

local function O(s,    t) --> t; create a klass and a constructor 
  t={}; t.__index = t
  return setmetatable(t, {__call=function(_,...) 
    local i=setmetatable({a=s},t); return setmetatable(t.new(i,...) or i,t) end}) end

local COL,COLS -- factories
local SYM,NUM,DATA,ROW,BIN=O"SYM",O"NUM",O"DATA",O"ROW",O"BIN" -- classes
local FetchR={l=l,COL=COL,COLS=COLS,SYM=SYM,NUM=NUM,DATA=DATA,ROW=ROW,BIN=BIN}
--------------------------------------------------------------------------
function COL(n,s,    col)
  col = (s:find"^[A-Z]+" and NUM or SYM)(n,s)
  col.isIgnored = col.txt:find"X$"
  col.isKlass   = col.txt.find"!$"
  col.isGoal    = col.txt.find"[!+-]$"
  return col end

function COLS(ss,     col,cols)
  cols={names=ss, all={},x={},y={}}
  for n,s in pairs(ss) do  
    col = l.push(cols.all, COL(n,s))
    if not col.isIgnored then
      if col.isKlass then cols.klass = col end
      l.push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end
--------------------------------------------------------------------------
-- Classes
function SYM:new(n,s)
  return {at=n, txt=s,seen={},bins={}} end

function SYM:add(s)  if s~="?" then self.seen[s]=s end end
function SYM:bucket(s) return s end
function SYM:tekcub(s) return s end
function SYM:dist(s1,s2)
  return  s1=="?" and s2=="?" and 1 or s1==s2 and 0 or 1 end
--------------------------------------------------------------------------
function NUM:new(n,s)
  return {lo=math.huge, hi=-math.huge, at=n or 0, txt=s or "",
          w=(s or ""):find"-$" and -1 or 1,
          bins={}} end

function NUM:norm(n)
  return n=="?" and n or (x-self.lo)/(self.hi - self.lo +1E-32)  end

function NUM:add(n)
  if n == "?" then self.lo = math.min(n,self.lo)
                   self.hi = math.max(n,self.hi) end end  

function NUM:bucket(n,     gap)
  if n~="?" then gap = (self.hi - self.lo)/the.Bins 
                 return math.min(((n-self.lo)/gap//1 + 1),the.Bins) end end

function NUM:tekcub(n,   gap)
  if n~="?" then gap = (self.hi - self.lo)/the.Bins 
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
function ROW:new(t) return {cells=t} end

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
function DATA:new(src,    data,fun)
  self.rows={}
  function fun(row) self:add(row) end 
  if type(src)=="string" then l.csv(src,fun) else l.map(src or {},fun) end end

function DATA:add(row)
  if self.cols then
    row = l.push(self.rows, row.cells and row or ROW(row))
    for _,col in pairs{self.cols.x, self.cols.y} do
      for _,col in pairs(cols) do
        col:add(row.cells[col.at]) end end 
  else self.cols = COLS(row) end end  
        
function DATA:dist(row1,row2,  cols)
  local n,d = 0,0
  for _,col in pairs(cols or self.cols.x) do
    n = n + 1
    d = d + col:dist(row1.cells[col.at], row2.cells[col.at])^the.p end
  return (d/n)^(1/the.p) end

function DATA:half(  rows,cols,above)
  local left,right,far,gap,some,proj,tmp,A,B,c = {},{}
  function gap(r1,r2) return self:dist(r1, r2, cols) end
  function proj(r)    return {row=r, dist=(gap(r,A)^2 + c^2 - gap(r,B)^2)/(2*c)} end
  rows = rows or self.rows
  some = l.many(rows, the.Sample)
  A    = above or l.any(some)
  tmp  = l.sort(l.map(l.some, function(r) return {row=r,dist=gap(A,r)} end),l.lt"dist") 
  far  = tmp[(#tmp*the.Far)//1] 
  B,c  = far.row, far.dist
  for n,tmp in pairs(l.sort(l.map(rows,proj), l.lt"dist")) do
    push(n <= (rows//2) and left or right, tmp.row) end
  return left, right, A, B, c end  
-------------------------------------------------------------------------
function BIN:new(nall,lo,hi) return{nall=nall,lo=lo,hi=hi or lo,yes=0,no=0,n=0} end

function BIN:score()
  return (bin.yes/(bin.yes+bin.no)) * bin.n/bin.nall end

function BIN:reinforce(  inc)
  inc   = inc or 1
  self.n = self.n + 1
  if inc >= 0 then self.yes=self.yes + inc else self.no=self.no - inc end end

function BIN:merged(bin,  lo,hi,bins2)
   new      = l.copy(self)
   new.lo   = lo or self.lo
   new.hi   = hi or bin.hi
   new.nall = self.nall + bin.nall
   new.yes  = self.yes  + bin.yes
   new.no   = self.no   + bin.no
   new.n    = self.n    + bin.n 
  if score(new) >= .95*(score(self)+score(bin)) then return new end end

function BIN.merges(bins,    fun) -- {hi,lo,yes,no,n,     all,merge1}
  function fun(now)
    local new,j,before,a,b,c = {},1,-math.huge
    while j <= #now do
      a,b,c = now[j],now[j+1]
      if b then c = a:merged(b,before) end
	    if c then a=c; j=j+1 end 
      before = l.push(new,a).hi
      j=j+1
    end
    new[#new].hi =  math.huge
    return #now == #new and new or fun(new) 
  end -----------------------------
  return fun(sort(bins,lt"lo")) end
-------------------------------------------------------------------------
l.fmt = string.format
function l.copy(t,    u) --> t; deep copy
  if type(t) ~= "table" then return t end 
  u={}; for k,v in pairs(t) do u[k]=l.copy(v) end
  return setmetatable(u,getmetatable(t)) end 

function l.sort(t, fun) --> t; return `t`,  sorted by `fun` (default= `<`)
  table.sort(t,fun); return t end

function l.lt(x) --> fun;  return a function that sorts ascending on `x`
  return function(a,b) return a[x] < b[x] end end

function l.push(t, x) --> any; push `x` to end of list; return `x` 
  table.insert(t,x); return x end

function l.map(t, fun,     u) --> t; map a function `fun`(v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do v,k=fun(v); u[k or (1+#u)]=v end;  return u end
 
function l.kap(t, fun,     u) --> t; map function `fun`(k,v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v; end; return u end

function l.keys(t)
  return l.sort(l.kap(t,function(k,_) return k end)) end

l.Seed=937162211
function l.rint(nlo,nhi)  return math.floor(0.5 + l.rand(nlo,nhi)) end
function l.rand(nlo,nhi) --> num; return float from `nlo`..`nhi` (default 0..1)
  nlo, nhi = nlo or 0, nhi or 1
  Seed = (16807 * Seed) % 2147483647
  return nlo + (nhi-nlo) * Seed / 2147483647 end

function l.coerce(s,    fun) --> any; return int or float or bool or string from `s`
  function fun(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function l.cells(s,    t)
  t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; return t end

function l.lines(sFilename,fun,    src,s) --> nil; call `fun` on rows (after coercing cell text)
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

function l.csv(sFilename,fun)
  l.lines(sFilename, function(line) fun(l.cells(line)) end) end

function l.oo(t) print(l.o(t)); return t end
function l.o(t,    fun) --> s; convert `t` to a string. sort named keys. 
  if type(t)~="table" then return tostring(t) end
  fun= function(k,v) return string.format(":%s %s",k,l.o(v)) end 
  return "{"..table.concat(#t>0  and l.map(t,l.o) or l.sort(l.kap(t,fun))," ").."}" end

function l.cli(options,txt) --> t; update key,vals in `t` from command-line flags
  txt:gsub("\n[%s]+(-[%S])[%s]+([-][-]([%S]+))[^\n]+= ([%S]+)",function(short,long,k,v) 
    for n,x in ipairs(arg) do
      if x==short or x==long then
        v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    options[k] = l.coerce(v) end) end

function l.main(funs,settings,txt,    fails,saved)
  l.cli(settings,txt)
  fails,saved = 0,l.copy(settings)
  if   settings.help 
  then print(txt)
       for _,name in pairs(l.keys(funs)) do 
         print("  -g",(name:gsub("_"," "))) end
  else for _,name in pairs(l.keys(funs)) do
        if settings.go =="all" or name:find("^"..settings.go..".*") then
          for k,v in pairs(saved) do settings[k]=v end
          l.Seed = settings.seed
          if funs[name]()==false then print("❌ "..name); fails=fail+1
                                 else print("✅ "..name) end end end 
  end
  for k,v in pairs(_ENV) do -- LUA trivia. Looking for rogue locals
    if not b4[k] then print( string.format("#W ?%s %s",k,type(v)) ) end end 
  os.exit(fails) end  
-------------------------------------------------------------------------
local egs={}
function egs.show_config() l.oo(l.the) end
function egs.test_maths()  print(10 + 10) end
-------------------------------------------------------------------------
return pcall(debug.getlocal,4,1) and FetchR or l.main(egs,l.the,l.help)
