--<!-- vim: set ts=2 sw=2 et : -->
-- <p style="text-align: left;">
-- Here, we play code golf with AI (most functionality, fewest lines).</p>
--    
-- ## How to read this code
-- <p style="text-align: left;">
-- This code starts with a help string and ends with a library of examples 
-- (see "function egs.xyz()" at end of file). 
-- Any of the examples can be run from the command line; e.g. "-g show" runs
-- all the actions that start with "show". 
-- All the settings in the help string can
-- be changed on the command line; e.g. "lua fetchr.lua -s 3" sets the seed to 3.</p>
-- <p style="text-align: left;">
-- Vars are global by default unless marked with "local" or 
-- defined in function argument lists.
-- Also,  there is only one data structure called a "table".
-- that can have numeric or symbolic keys.
-- The tables start and end with {} and #t is length of a table
-- (and empty tables have #t==0).
-- Tables can have numeric or symbolic fields. Note that
-- `for pos,x in pairs(t) do` is the same as python's 
-- `for pos,x in enumerate(t) do`.</p>
-- <p style="text-align: left;">
-- Global settings are stores in "the" table which is generated from
-- "help". E.g. From the above the.budget =16.
-- For all `key=value` in `the`, a command line flag `-k X` means `value`=X</p>
-- <p style="text-align: left;">
-- In the function arguments, the following conventions apply (usually):</p>
--   
-- -  n == number
-- -  s == string
-- -  t == table
-- -  is == boolean
-- -  x == anything
-- -  fun == function
-- -  UPPER = class (some factory for making similar things)
-- -  lower = instance; e.g. sym is an instance of SYM
-- -  xs == a table of "x"; e.g. "ns" is a list of numbers
-- -  Two spaces denote start of optional args
-- -  Four spaces denote start of local args. 
local the,help = {}, [[
    
tiny.lua : multi-objective semi-supervised explanation
(c) 2023 Tim Menzies <timm@ieee.org> BSD-2

OPTIONS:
  -b --bins     initial number of bins      = 16
  -c --cliffs   cliff's delta threshold     = .2385
  -f  --file    data file                   = ../etc/data/auto93.csv
  -F  --Far     distance to distant         = .95
  -g  --go      start-up action             = nothing
  -h  --help    show help                   = false
  -H  --Halves  search space for clustering = 512
  -m  --min     size of smallest cluster    = .5
  -M  --Max     numbers                     = 512
  -p  --p       dist coefficient            = 2
  -r  --rest    how many of rest to sample  = 4
  -s  --seed    random number seed          = 937162211
]]
-- -----------------------------------------------
-- Magic expression to match keys and values from `help`
local magic = "\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)"
  
 -- Name space trivia (so everything can call everything else).
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
local accept,accepts,adds,add,any,better,bin,bins
local contrast,copy,cli,csv,cells,cliffsDelta,clone,coerce
local diffs,dist,div,egs,extend,fmt,gt,half,has,itself
local kap,keys,lines,locals,lt
local main,many,map,merge,merged,merges,mid,norm,o,oo,per,push
local rint,rand,read,rnd,row,rogues
local Seed,showTree,sort,slice,stats,sway
local tree,value
local COL,COLS,DATA,NUM,RANGE,RULE,SYM
local m = math

-- ## Creation

-- Generate a `NUM` or a `SYM`. Column
-- names are a little language that    
-- e.g. makes `NUM`s if name starts in upper case; or
-- e.g. makes goals if the name is marked with
-- the maximize (`+`) or minimize (`-`) or klass (`!`) symbol.
function COL(n,s,    col)
   col = s:find"^[A-Z]" and NUM(n,s) or SYM(n,s) 
   col.isIgnored  = col.txt:find"X$"
   col.isKlass    = col.txt:find"!$"
   col.isGoal     = col.txt:find"[!+-]$"
   return col end

-- `NUM`s summarize a stream of numbers.
function NUM(n,s) 
  return {at= n or 0, txt= s or "", n=0,
          hi= -m.huge, lo= m.huge, 
          ok=true, has={},
          w= (s or ""):find"-$" and -1 or 1} end

-- `SYM`s summarize a stream of symbols.
function SYM(n,s)
  return {at=n or 0, txt=s or "", n=0, 
          isSym=true, has={}} end

-- Generate a set of `NUM`s or `SYM`s columns.
-- Once created, all cols are stored in `all`
-- while the non-skipped cols are also stored as
-- either `cols.x` independent input variables or
-- `cols.y` dependent goal variables.
function COLS(ss,     col,cols)
  cols={names=ss, all={},x={},y={}}
  for n,s in pairs(ss) do  
    col = push(cols.all, COL(n,s))
    if not col.isIgnored then
      if col.isKlass then cols.klass = col end
      push(col.isGoal and cols.y or cols.x, col) end end 
  return cols end

-- `DATA` contain `rows`, summarized in `cols`.
function DATA() return {rows={},cols=nil} end  -- initially, no `cols`

-- Given two columns `x,y`, `RANGE` tracks the y values seen in 
-- `x` range `lo` to `hi`. Note that for symbolic columns, `lo` is
-- always the same as `hi`.
function RANGE(at,txt,lo,hi) 
  return {at=at,txt=txt,lo=lo,hi=lo or hi or lo,y=SYM()} end

-- Read a csv file into a new `DATA`. For each line,
-- call `row` (defined below) to update the columns.
function read(sfile,    data) 
  data=DATA()
  csv(sfile, function(t) row(data,t) end); return data end

-- Replicate structure of `data`.
function clone(data,t,    data1)
  data1 = row(DATA(), data.cols.names)
  for _,t in pairs(t or {}) do row(data1,t) end
  return data1 end

-- ## Update

-- Update `data` with  row `t`. If `data.cols`
-- does not exist, the use `t` to create `data.cols`.
-- To avoid updating skipped columns, we only iterate
-- over `cols.x` and `cols.y`.
function row(data,t)
  if data.cols  then
    push(data.rows,t)
    for _,cols in pairs{data.cols.x, data.cols.y} do
      for _,col in pairs(cols) do 
	     add(col, t[col.at]) end end 
  else data.cols = COLS(t) end 
  return data end

-- Called by `row` to add one cells of data into a `col`.
-- `SYM`s just increment a symbol counts.
-- `NUM`s store `x` in a finite sized cache. When it
-- fills to more than `the.Max`, then at probability 
-- `the.Max/col.n` replace any existing item
-- (selected at random). If anything is added, the list
-- may not longer be sorted so set `col.ok=false`.
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

-- Add multiple items from `t` into `col`. This is useful when `col` is being
-- used outside of some DATA.
function adds(col,t) 
  for _,x in pairs(t or {}) do add(col,x) end; return col end

-- Extend a RANGE to cover `x` and `y`
function extend(range,x,y)
  range.lo = m.min(x, range.lo)
  range.hi = m.max(x, range.hi)
  add(range.y, y) end

-- ## Query

-- Return contents of a column. If `col` is a `NUM` with
-- unsorted contents, then sort before return the contents.
function has(col)
  if not col.isSym and not col.ok then sort(col.has); col.ok=true end
  return col.has end

-- Return a `cols`'s central tendency  
-- (mode for `SYM`s and median for `NUM`s).
function mid(col,    mode,most)
  if   col.isSym 
  then most,mode = 0 
       for x,n in pairs(col.has) do if n>most then most,mode=n,x end end
       return mode 
  else return per(has(col), .5) end end 

-- Return a `col`'s deviation from central tendency    
-- (entropy for `SYM`s and standard deviation for `NUM`s)..
function div(col,    e)
  if   col.isSym 
  then e=0; for _,n in pairs(col.has) do e= e-n/col.n*m.log(n/col.n,2) end; return e
  else return (per(has(col),.9) - per(has(col), .1))/2.58 end end

-- Report `mid` or `div` of `cols` (defaults to `data.cols.y`).
function stats(data,  fun,cols,nPlaces,     tmp)
  cols= cols or data.cols.y
  tmp = kap(cols,
            function(k,col) return rnd((fun or mid)(col),nPlaces), col.txt end)
  tmp["N"] = #data.rows
  return tmp,map(cols,mid)  end

-- Normalize `n` 0..1.
function norm(num,n)
  return x=="?" and x or (n - num.lo)/(num.hi - num.lo + 1/m.huge) end

-- Score a distribution.
function value(sym,  B,R,goal,    b,r)
  goal,B,R = goal or true, B or 1, R or 1
  b,r = 0,0
  for x,n in pairs(sym.has) do
    if x==goal then b = b + n else r = r + n end end
  b,r = b/(B+1/m.huge), r/(R+1/m.huge)
  return b^2/(b+r) end

-- ## Clustering

-- Divide `rows` in half (defaults to `data.rows`) by
-- dividing the data via their distance to two remote points.
-- To speed up finding those remote points, only look at
-- `some` of the data. Also, to avoid outliers, only look
-- `the.Far` (say, 955) of the way across the space. 
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

-- Recursively bi-divide the `rows`. 
function tree(data,  rows,cols,above,     here)
  rows = rows or data.rows
  here = {data=clone(data,rows)}
  if #rows >= 2*(#data.rows)^the.min then
    local left,right,A,B = half(data, rows, cols, above)
    here.left  = tree(data, left,  cols, A)
    here.right = tree(data, right, cols, B) end
  return here end 

-- Return distances 0..1 between rows `t1` and `t2`.   
-- If any values are unknown, assume max distances.
function dist(data,t1,t2,  cols,    d,n,dist1)
  function dist1(col,x,y)
    if x=="?" and y=="?" then return 1 end
    if   col.isSym
    then return x==y and 0 or 1 
    else x,y = norm(col,x), norm(col,y)
         if x=="?" then x= y<.5 and 1 or 1 end	
         if y=="?" then y= x<.5 and 1 or 1 end	
         return m.abs(x-y) end 
  end --------------
  d, n = 0, 1/m.huge	
  for _,col in pairs(cols or data.cols.x) do
    n = n + 1
    d = d + dist1(col, t1[col.at], t2[col.at])^the.p end 
  return (d/n)^(1/the.p) end

-- Display a tree of clusters.
function showTree(tree,  lvl,post)
  if tree then 
    lvl  = lvl or 0
    io.write(fmt("%s[%s] ",("|.. "):rep(lvl), #(tree.data.rows)))
    print((lvl==0 or not tree.left) and o(stats(tree.data)) or "")
    showTree(tree.left, lvl+1)
    showTree(tree.right,lvl+1) end end

-- ## Optimization

-- Recursively prune the worst half the data. Return
-- the survivors and some sample of the rest.
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

-- When is one `row1` better than another?
-- This is Zitzler's indicator predicate that
-- judges the domination status 
-- of pair of individuals by running a “what-if” query. 
-- It checks what we lose when we jump from one 
-- individual to another, and back again.
function better(data,row1,row2,    s1,s2,ys,x,y) 
  s1,s2,ys,x,y = 0,0,data.cols.y
  for _,col in pairs(ys) do
    x  = norm(col, row1[col.at] )
    y  = norm(col, row2[col.at] )
    s1 = s1 - m.exp(col.w * (x-y)/#ys)
    s2 = s2 - m.exp(col.w * (y-x)/#ys) end
  return s1/#ys < s2/#ys end

-- ## Discretization

-- Return RANGEs that distinguish good rows from bad rows.
-- To reduce the search space,
-- values in `col` are mapped to small number of `bin`s.
function bins(data,rowsGood,rowsBad)
  local out = {}
  for _,col in pairs(cols or data.cols.x) do
    local ranges = {}
    for _,what in pairs({{rows=rowsGood,y=true},{rows=rowsBad,y=false}}) do
      for _,row in pairs(what.rows) do
        local x,k = row[col.at]
        if x ~= "?" then
          k = bin(col,x)
          ranges[k] = ranges[k] or RANGE(col.at,col.txt,x)
          extend(ranges[k], x, what.y) end end end
    ranges = sort(map(ranges,itself),lt"lo")
    out[#out+1] = col.isSym and ranges or merges(ranges) end
  return out end

-- Map `x` into a small number of bins.
function bin(col,x,      tmp)
  if x=="?" or col.isSym then return x end
  tmp = (col.hi - col.lo)/(the.bins - 1)
  return col.hi == col.lo and 1 or m.floor(x/tmp + .5)*tmp end

-- Given a sorted list of ranges, try fusing adjacent items
-- (stopping when no more fuse-ings can be found). When done,
-- make the ranges run from minus to plus infinity
-- (with no gaps in between).
function merges(ranges0,     noGaps)
  function noGaps(t)
    for j = 2,#t do t[j].lo = t[j-1].hi end
    t[1].lo  = -m.huge
    t[#t].hi =  m.huge
    return t 
  end ------
  local ranges1,j,a,b,y = {},1
  while j <= #ranges0 do
    a, b = ranges0[j], ranges0[j+1]
    if b then
      y = merged(a.y, b.y)
      if y then
        a.hi, a.y = b.hi, y
        j = j+1 end end
    push(ranges1,a)
    j = j+1 
  end
  return #ranges0==#ranges1 and noGaps(ranges0) or merges(ranges1) end

-- If the whole is not more complex than the parts, return the
-- combination of 2 `col`s.
function merged(col1,col2,   new)
  new = merge(col1,col2)
  if div(new) <= 1.01*(div(col1)*col1.n + div(col2)*col2.n)/new.n then
    return new end end

-- Combine two `cols`.
function merge(col1,col2,    new)
  new = copy(col1)
  if   col1.isSym 
  then for x,n in pairs(col2.has) do add(new,x,n) end
  else for _,n in pairs(col2.has) do add(new,n)   end
       new.lo = m.min(col1.lo, col2.lo)
       new.hi = m.max(col1.hi, col2.hi) end 
  return new end

-- ## Contrast Sets

function contrast(data,   best,rest,out,rule,tmp,data1,data2)
  best,rest = sway(data)
  out = {}
  for k,t in pairs(bins(data,best.rows, rest.rows)) do
    for _,xy in pairs(t) do
      push(out, {x=xy.x, y=value(xy.y,xy.B,xy.R,true)}) end end
  out = sort(out,gt"y")
  oo(stats(data))
  oo(stats(data,div))
  for i=1,#out do
    rule = RULE(map(slice(out,1,i),function(xy) return xy.x end))
    tmp = accepts(rule, data.rows)
    if tmp and #tmp>#best.rows/2 then 
       data1  = clone(data,tmp) 
       print("\nall",i,o(diffs(data.cols.y, data1.cols.y)))
       if data2 then
         print("gt?",i,o(diffs(data2.cols.y, data1.cols.y))) 
         print("","",o(stats(data1))) 
         print("","",o(stats(data1,div)))
       end
       data2 = data1
end end end

function RULE(ranges,      t)
  t={}
  for _,range in pairs(ranges) do
    t[range.txt] = t[range.txt] or {}
    push(t[range.txt], range) end 
  return t end

function accepts(rule,rows,     t,fun)
  fun = function(row) if accept(rule,row) then return row end end
  t   = map(rows,fun)
  if #t < #rows then return t end end

function accept(rule,row,     ok,x)
  for _,ranges in pairs(rule)  do
    ok = false
    for _,r in pairs(ranges) do
      x = row[r.at]
      if x == "?"               then ok=true;break end 
      if r.lo==r.hi and r.lo==x then ok=true;break end
      if r.lo<=x    and x< r.hi then ok=true;break end 
    end
    if not ok then return false end end 
  return true end 
      
-- ## Lib
-- ### Meta

-- Return self.
function itself(x) return x end

-- ### Maths

-- Round numbers
function rnd(n, nPlaces) 
  local mult = 10^(nPlaces or 2)
  return math.floor(n * mult + 0.5) / mult end

-- Random number generation.
Seed=937162211 -- seed
function rint(nlo,nhi)  -- random ints  
  return m.floor(0.5 + rand(nlo,nhi)) end

function rand(nlo,nhi) -- random floats
  nlo, nhi = nlo or 0, nhi or 1
  Seed = (16807 * Seed) % 2147483647
  return nlo + (nhi-nlo) * Seed / 2147483647 end

-- Non-parametric effect-size test
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

-- Given two tables with the same keys, report if their
-- values are different.
function diffs(nums1,nums2)
  return kap(nums1,function(k,nums) return cliffsDelta(nums.has,nums2[k].has),nums.txt end) end

-- ### String to thing

-- Coerce string to boolean, int,float or (failing all else) strings.
function coerce(s,    fun) 
  function fun(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

-- Split a string `s`  on commas.
function cells(s,    t)
  t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t] = coerce(s1) end; return t end

-- Run `fun` for all lines in a file.
function lines(sFilename,fun,    src,s) 
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(s) else return io.close(src) end end end

-- Run `fun` on the cells  in each row of a csv file.
function csv(sFilename,fun)
  lines(sFilename, function(line) fun(cells(line)) end) end

-- ### Lists

-- Push an item `x` onto  a list.    
-- Return a list, sorted on `fun`.   
-- Return a function sorting down on field `x`.    
-- Return a function sorting up on field `x`.    
-- Return one item at random.    
-- Return many items, selected at random.   
-- Map a function on  table (results in items 1,2,3...)    
push = function(t,x) t[#t+1]=x; return x end
sort = function(t,f) table.sort(t,f); return t end
lt   = function(x)   return function(a,b) return a[x] < b[x] end end
gt   = function(x)   return function(a,b) return a[x] > b[x] end end
any  = function(t)   return t[rint(#t)] end
many = function(t,n,    u) u={}; for i=1,n do push(u, any(t)) end; return u end 
map  = function(t, fun) return kap(t, function(_,v) return fun(v) end) end
keys = function(t)      return sort(kap(t,function(k,_) return k end)) end

-- Map a function on table (results in items key1,key2,...)
function kap(t, fun,     u) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v; end; return u end

-- Return the `p`-ratio item in `t`; e.g. `per(t,.5)` returns the medium.
function per(t,p) 
  p=math.floor(((p or .5)*#t)+.5); return t[m.max(1,m.min(#t,p))] end

-- Deep copy of a table `t`.
function copy(t,    u) 
  if  type(t)~="table" then return t end
  u={}; for k,v in pairs(t) do u[k] = copy(v) end; return u end

-- Return a portion of `t`; go,stop,inc defaults to 1,#t,1.
-- Negative indexes are supported.
function slice(t, go, stop, inc,    u) --> t; return `t` from `go`(=1) to `stop`(=#t), by `inc`(=1)
  if go   and go   < 0 then go=#t+go     end
  if stop and stop < 0 then stop=#t+stop end
  u={}; for j=(go or 1)//1,(stop or #t)//1,(inc or 1)//1 do u[1+#u]=t[j] end; return u end

-- ### Strings

-- `fmt` means `string.format`.
fmt  = string.format

-- Print a nested table (sorted by the keys of the table).
function oo(t) print(o(t)); return t end
function o(t,    fun) 
  if type(t)~="table" then return tostring(t) end
  function fun (k,v) return fmt(":%s %s",k,o(v)) end 
  return "{"..table.concat(#t>0  and map(t,o) or sort(kap(t,fun))," ").."}" end

-- ### Main Control

-- Rune all the functions whose name matches
-- the command-line flag `-g xx`. Show the help
-- string if the `-h` flag is set. Return to the operating
-- system the number of failing `funs`.
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

-- Return any rogue locals (i.e. all those we did not
-- trap in the `b4` list at top of file).
function rogues() 
  for k,v in pairs(_ENV) do 
    if not b4[k] then print(fmt("#W ?%s %s",k,type(v))) end end end

-- Update `t` using command-line options. For boolean
-- flags, just flip the default values. For others, read
-- the new value from the command line.
function cli(t)
  for k,v in pairs(t) do
    v = tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
        v= v=="false" and "true" or v=="true" and "false" or arg[n+1] end end 
    t[k] = coerce(v) end 
  return t end

-- ## Examples

-- Place to store examples.
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
  showTree(tree(read(the.file))) end

function egs.sway(    data,best,rest)
  data = read(the.file)
  best,rest = sway(data)
  print("\nall ", o(stats(data))) 
  print("    ",   o(stats(data,div))) 
  print("\nbest", o(stats(best))) 
  print("    ",   o(stats(best,div))) 
  print("\nrest", o(stats(rest))) 
  print("    ",   o(stats(rest,div))) 
  print("\nall ~= best?", o(diffs(best.cols.y, data.cols.y)))
  print("best ~= rest?", o(diffs(best.cols.y, rest.cols.y))) end

function egs.bins(    data,best,rest)
  print(rand())
  data = read(the.file)
  best,rest = sway(data)
  for k,t in pairs(bins(data,best.rows, rest.rows)) do
    for _,range in pairs(t) do
      print(range.txt,range.lo,range.hi,
           rnd(value(range.y, #best.rows,#rest.rows))) end end end 

function egs.contrast()
  print(rand())
  contrast(read(the.file)) end

-- ## Start-up

--  Parse the `help` string to make the `the` config variables.
help:gsub(magic, function(k,v) the[k] = coerce(v) end)

-- Bundle up the locals.
local _locals,_i={},1 
while true do
  local _name, _value = debug.getlocal(1, _i)
  if not _name then break end
  if _name:sub(1,1) ~= "_" then _locals[_name]=_value end
  _i = _i + 1 end

-- If being loaded by other code, then return locals.
if pcall(debug.getlocal,4,1) then return _locals end
-- Else, return whatever `main` returns.
os.exit( main(egs,cli(the),help) ) 
