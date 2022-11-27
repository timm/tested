#!/usr/bin/env lua
---                       _        __
---     ____ _   _____   (_)  ____/ /
---    / __ `/  / ___/  / /  / __  / 
---   / /_/ /  / /     / /  / /_/ /  
---   \__, /  /_/     /_/   \__,_/   
---   /____/                           
                                           
local lib = require"lib"
local the = lib.settings[[   
grud.lua : row/column clustering for rep grids
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

Reads a csv file where row1 is column names and col1,coln
is dimension left,right and all other cells are numerics.

USAGE:   grid.lua  [OPTIONS]

OPTIONS:
  -d  --dump  on crash, dump stack       = false
  -f  --file  csv file                   = etc/data/repgrid1.csv
  -F  --Far   where to find far things   = 1
  -g  --go    start-up action            = data
  -h  --help  show help                  = false
  -m  --min   min size for leaf clusters = .5
  -p  --p     distance coefficient       = 2
  -s  --seed  random number seed         = 937162211
  -x  --X     small x change             = .1
]]
local obj,fmt,o,oo,map,shuffle,lt,gt,sort,push,slice  =
        lib.obj,            -- object tricks
        lib.fmt, lib.o, lib.oo,     -- string tricks
        lib.map, lib.shuffle, lib.lt, lib.gt, lib.sort, -- less strings
        lib.push, lib.slice  -- list tricks
-----------------------------------------------------------------------------------------
local function cosine(a,b,c) -->  nx,ny,isStable; find x,y from a line connecting `left,right`.
  local x1 = (a^2 + c^2 - b^2) / (2*c)
  local x2 = math.max(0, math.min(1, x1)) -- in the incremental case, x1 might be outside 0,1
  local  y = (x2^2 - a^2)^.5
  return x, y, math.abs(x1 - x2) > the.X  end
-----------------------------------------------------------------------------------------
local LINE=obj"LINE"
function LINE:new(raw, cells,lhs,rhs)
  self.raw, self.cells, self.lhs, self.rhs = raw, cells, lhs or "", rhs or "" end

function LINE:__tostring()
  return self.lhs..o(self.cells)..self.rhs end

function LINE:__sub(other)
  local n,d = 0,0
  for c,x in pairs(line1.cells) do 
    n = n + 1
    d = d + math.abs(x - line2.cells[c])^the.p end
  return (d/n)^(1/the.p) end

function LINE:far(lines) --> t; return a pair that runes `the.Far` across `lines`
  local function pole(line) 
    if self._id ~= line._id then return {west=self, east=line, dist=self-line} end
  return sort(map(lines, pole), lt"dist")[(the.Far * #lines)//1] end
-----------------------------------------------------------------------------------------
local DATA=obj"DATA"
function DATA:new(t) self.lines=t end

function DATA:furthest(lines) --> POLE; return the largest POLE found in `lines`
  local n = (the.Far * #lines)//1
  return sort(map(lines, function(line) return line:far(lines) end), lt"dist")[n] end

function DATA:half(lines) --> lines1,lines2,n; divide lines on distance to 2 poles
  local cut  = furthest(lines)
  local function project(line)
    local x,y = cosine(dist(line, cut.left), dist(line, cut.right), cut.dist)
    return {line=line, x=x, y=y} end
  local wests,easts = {},{}
  for n,tmp in pairs(sort(map(lines, project), lt"x")) do
    tmp.line.x = tmp.line.x or tmp.x
    tmp.line.y = tmp.line.y or tmp.y
    push(n <= (#lines)//2 and wests or easts, tmp.line) end
  return wests, easts, cut.dist end

function DATA:tree(lines,min,    node)
  min = min or (#lines)^the.min
  local node={here=lines}
  if #rows > min then
    local wests, easts
    wests, easts, node.c = self:half(lines)
    node.west = self:tree(wests, min)
    node.east = self:tree(easts, min) end
  return node end

function show(node, b4)
  b4 = b4 or ""
  if node then
    io.write(b4..(node.c and rnd(node.c) or ""))
    print(node.c and "" or (node.here.lhs .. ":"..node.here.rhs))
    tree(node.wests,  "|.. ".. b4)
    tree(node.easts, "|.. ".. b4) end  end

local ok
function ok(t)
  local template = {rows={},cols={},domain="string"}
  for key,eg in pairs(template) do
    assert(t[key],                      fmt("[%s] missing",key))
    assert(type(t[key]) == type(eg),    fmt("[%s=%s] is not a [%s]", key,t[key], type(eg))) end 
  for r,row in pairs(t.cols) do 
    assert(#row==#t.cols[1],            fmt("row [%s] lacks [%s] cells",r,#t.rows[1])) 
    assert(type(row[1])    == "string", fmt("row [%s] lacks LHS txt",r))
    assert(type(row[#row]) == "string", fmt("row [%s] lacks RHS txt",r)) 
    for c=2,#row-1 do 
      local x = row[c]
      assert(x//1 == x,fmt("[%s] not an int",x)) end end
  return t end

local function columns(cols)
  local lo,hi={},{}
  local function lohi(col)
    local j=0
    for i=2,#col-2 do
      local v= col[i]
      j=j+1
      if v ~= "?" then lo[j] = lo[j] and math.min(v, lo[c]) or v
                       hi[j] = hi[j] and math.max(v, hi[c]) or v end end end 
  local function asLines(lo,hi,t) 
    local tmp = slice(t,2,-2)
    return LINE(raw,
                map(tmp, function(x) return (x - lo)/(hi - lo +1E-32) end),
                t[1], 
                t[#t]) end
  for _,col in pairs(cols) do
    raw,c={},0
    for i=2,#col-2 do
      c=c+1
      local v= col[i]
      raw[1+#raw]=v
      if c ~= "?" then lo[c] = lo[c] and math.min(v, lo[c]) or v
                       hi[c] = hi[c] and math.max(v, hi[c]) or v end 
      map(cols,lohi)
  return map(cols,asLines) end

------------------------------------------------------------------------------------------
--- ## Start-up
local eg={}

function eg.the()   lib.oo(the) end
function eg.ok()    ok(dofile(the.file)) end
function eg.data()  map(columns(ok(dofile(the.file))).cols,oo) end
-- function eg.half()  
--   local half = bicluster.half
--   local m=ok(dofile(the.file))
--   local rows = map(m.rows, function(row) return asConstruct(m.lo, m.hi, row) end)
--   local lefts, rights = half(rows)
--   print(#lefts, #rights) end
--
-- function eg.cluster()  
--   local m=ok(dofile(the.file))
--   local rows = map(m.rows, function(row) return asConstruct(m.lo, m.hi, row) end)
--   tree(cluster(rows,1))
-- end
--

if lib.required() then return {cluster=cluster,columns=columns} else lib.main(the,eg) end 
