local the, help = {}, [[
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

ACTIONS:]]
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end -- lua trivia (used to find rogue locals)
local Seed,add,bin,cli,coerce,copy,csv,dist,half,kap,keys
local lt,main,map,norm,o,oo,push,rand,record,rint,sort 
local COL, SYM, NUM, COLS, DATA, ROW
--------------------------------------------------------------------------
-- ## Columns
function COL(n,s,    col)
  col = (s:find"^[A-Z]+" and NUM or SYM)(n,s)
  col.isIgnored = col.txt:find"X$"
  col.isKlass   = col.txt.find"!$"
  col.isGoal    = col.txt.find"[!+-]$"
  return col end

function SYM(n,s)
  return {at=n, txt=s,seen={},bins={}} end

function NUM(n,s)
  return {isNum=true, lo=math.huge, hi=-math.huge, at=n or 0, txt=s or "",
          w=(s or ""):find"-$" and -1 or 1,
          bins={}} end

function norm(num,x)
  return x=="?" and x or (x-col.lo)/(col.hi - col.lo +1E-32)  end

function bucket(col,x,     gap)
  if x~="?" and col.isNum then
    gap = (col.hi - col.lo)/the.Bins 
    x = math.min(((x-col.lo)/gap//1 + 1),the.Bins) end
  return x end 

function add(col,x)
  if x == "?" then return x end
  if col.isNum then
    col.lo = math.min(x,col.lo)
    col.hi = math.max(x,col.hi)  
  else col.seen[x] = true end end

-- function force(col,x,inc)
--   if x =="?" then return end
--   if col.isNum then
--     gap=(col.hi - col.lo)/the.Bins
--
-- ## Factory for Making Columns
function COLS(row,     cols,col)
  cols={names=row, all={}, x={}, y={}}
  for n,s in pairs(row) do  
    col = push(cols.all, COL(n,s))
    if not col.isIgnored then
      if col.isKlass then cols.klass = col end
      push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end

-- ## Row
function ROW(t) return {cells=t} end

function guess(row,data,     s,x)
  s = 0
  for _,col in pairs(data.cols.x) do
    x = row.cells[col.at]
    if x ~= "?" then
      for _,bin in pairs(col.bins) do
        if bin.lo <= x and x < bin.hi then 
          s = s + score(bin); break end end end end 
  return s end

-- ## Data
function DATA(src,    data,fun)
  data = {rows={}}
  function fun(row) record(data,row) end 
  if type(src)=="string" then csv(src,fun) else map(src or {},fun) end
  return data end

function record(data,row)
  if data.cols then
    row = push(data.rows, row.cells and row or ROW(row))
    for _,col in pairs{data.cols.x, data.cols.y} do
      for _,col in pairs(cols) do
        add(col, row.cells[col.at]) end end 
  else data.cols = COLS(row) end end  
        
function dist(data,row1,row2,  cols)
  local n,d,dist1 = 0,0
  function dist1(col,x,y)
    if x=="?" and y=="?"then return 1 
    elseif col.isNum then 
      x, y = norm(col,x), norm(col,y)
      if x=="?" then x= y<.5 and 1 or 0 end
      if y=="?" then y= x<.5 and 1 or 0 end
      return math.abs(x-y)
    else return x==y and 0 or 1 end  
  end ------------------------------
  for _,col in pairs(cols or data.cols.x) do
    n = n + 1
    d = d + dist1(row1.cells[col.at], row2.cells[col.at])^the.p end
  return (d/n)^(1/the.p) end

function half(data,rows,  cols,above)
  local left,right,far,gap,some,proj,tmp,A,B,c = {},{}
  function gap(r1,r2) return dist(data, r1, r2, cols) end
  function proj(r)    return {row=r, dist=(gap(r,A)^2 + c^2 - gap(r,B)^2)/(2*c)} end
  rows = rows or data.rows
  some = many(rows, the.Sample)
  A    = above or any(some)
  tmp  = sort(map(some, function(r) return {row=r,dist=gap(A,r)} end),lt"dist") 
  far  = tmp[(#tmp*the.Far)//1] 
  B,c  = far.row, far.dist
  for n,tmp in pairs(sort(map(rows,proj), lt"dist")) do
    push(n <= (rows//2) and left or right, tmp.row) end
  return left, right, A, B, c end  
-------------------------------------------------------------------------
function BIN(nall,lo,hi) return{nall=nall,lo=lo,hi=hi or lo,yes=0,no=0,n=0} end

function score(bin)
  return (bin.yes/(bin.yes+bin.no)) * bin.n/bin.nall end

function reinforce(bin,  inc)
  inc   = inc or 1
  bin.n = bin.n + 1
  if inc >= 0 then bin.yes=bin.yes + inc else bin.no=bin.no - inc end end

function merge(bin1,bin2,  lo,hi)
  return {lo  = lo or bin1.lo,
          hi  = hi or bin2.hi, 
          nall= math.max(bin1.nall, bin2.nall),
          yes = bin1.yes+bin2.yes, no= bin1.no+bin2.no, n= bin1.n+bin2.n} end

function merges(bins,    fun) -- {hi,lo,yes,no,n,     all,merge1}
  function fun(now)
    local new,j,before,a,b,c = {},1,-math.huge
    while j <= #now do
      a,b = now[j],now[j+1]
      if b then
	      c = merge(a,b,before)
	      if score(c) >= .95*(score(a) + score(b))
	      then a=c; j=j+1 end 
      end
      before = push(new,a).hi
      j=j+1
    end
    bins[#bins].hi =  math.huge
    return #now == #new and now or fun(new) 
  end -----------------------------
  return fun(sort(bins,lt"lo")) end
-------------------------------------------------------------------------
function copy(t,    u) --> t; deep copy
  if type(t) ~= "table" then return t end 
  u={}; for k,v in pairs(t) do u[k]=copy(v) end; return u end 

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

function coerce(s,    fun) --> any; return int or float or bool or string from `s`
  function fun(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function cells(s,    t)
  t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; return t end

function lines(sFilename,fun,    src,s) --> nil; call `fun` on rows (after coercing cell text)
  src,s,t  = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

function csv(sFilename,fun)
  lines(sFilename, function(line) fun(cells(line)) end) end

function oo(t) print(o(t)); return t end
function o(t,    fun) --> s; convert `t` to a string. sort named keys. 
  if type(t)~="table" then return tostring(t) end
  fun= function(k,v) return string.format(":%s %s",k,o(v)) end 
  return "{"..table.concat(#t>0  and map(t,o) or sort(kap(t,fun))," ").."}" end

function cli(options,txt) --> t; update key,vals in `t` from command-line flags
  txt:gsub("\n[%s]+(-[%S])[%s]+([-][-]([%S]+))[^\n]+= ([%S]+)",function(short,long,k,v) 
    for n,x in ipairs(arg) do
      if x==short or x==long then
        v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    options[k] = coerce(v) end) end

function main(funs,settings,txt,    fails,saved)
  cli(settings,txt)
  fails,saved = 0,copy(settings)
  if   settings.help 
  then print(txt)
       for _,name in pairs(keys(funs)) do print("  -g",(name:gsub("_"," "))) end
  else for _,name in pairs(keys(funs)) do
        if settings.go =="all" or name:find("^"..settings.go..".*") then
          for k,v in pairs(saved) do settings[k]=v end
          Seed = settings.seed
          if funs[name]()==false then print("❌ FAIL",name); fails=fail+1
	                                    print("✅ PASS",name) end end end 
  end
  for k,v in pairs(_ENV) do -- LUA trivia. Looking for rogue locals
    if not b4[k] then print( string.format("#W ?%s %s",k,type(v)) ) end end 
  os.exit(fails) end  
-------------------------------------------------------------------------
local egs={}
function egs.show_config() print(o(the)) end
function egs.test_maths()  print(10 + 10) end
-------------------------------------------------------------------------
main(egs,the,help)
