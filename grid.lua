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
local obj,fmt,o,oo,map,shuffle,lt,gt,sort,push,slice,rnd  =
        lib.obj,            -- object tricks
        lib.fmt, lib.o, lib.oo,     -- string tricks
        lib.map, lib.shuffle, lib.lt, lib.gt, lib.sort, -- less strings
        lib.push, lib.slice,  -- list tricks
        lib.rnd
-----------------------------------------------------------------------------------------
local function cosine(a,b,c) -->  nx,ny,isStable; find x,y from a line connecting `left,right`.
  local x1 = (a^2 + c^2 - b^2) / (2*c)
  local x2 = math.max(0, math.min(1, x1)) -- in the incremental case, x1 might be outside 0,1
  local  y = (x2^2 - a^2)^.5
  return x1, y, math.abs(x1 - x2) > the.X  end
-----------------------------------------------------------------------------------------
local LINE=obj"LINE"
function LINE:new(raw,cooked,lhs,rhs)
  self.raw, self.cells, self.lhs, self.rhs = raw, cooked, lhs or "", rhs or "" end

function LINE:__tostring()
  return fmt("[%s] %s %s", o(self.cells), self.lhs, self.rhs ) end

function LINE:__sub(other)
  local n,d = 0,0
  for c,x in pairs(self.cells) do 
    n = n + 1
    d = d + math.abs(x - other.cells[c])^the.p end
  return (d/n)^(1/the.p) end

function LINE:far(lines) --> t; return a pair that runes `the.Far` across `lines`
  local function pole(line) return {west=self, east=line, dist=self-line} end 
  return sort(map(lines, pole), lt"dist")[(the.Far * #lines)//1] end
-----------------------------------------------------------------------------------------
local DATA=obj"DATA"
function DATA:new(t) self.lines=t end

function DATA:furthest(lines) --> t; return the largest west,east found in `lines`
  local n = (the.Far * #lines)//1
  return sort(map(lines, function(line) return line:far(lines) end), lt"dist")[n] end

function DATA:half(lines) --> lines1,lines2,n; divide lines on distance to 2 poles
  local cut = self:furthest(lines)
  local function project(line)
    local x,y = cosine(line - cut.west, line - cut.east, cut.dist)
    return {line=line, x=x, y=y} end
  local wests,easts = {},{}
  for n,tmp in pairs(sort(map(lines, project), lt"x")) do
    tmp.line.x = tmp.line.x or tmp.x
    tmp.line.y = tmp.line.y or tmp.y
    push(n <= (#lines)//2 and wests or easts, tmp.line) end
  return wests, easts, cut.dist end

function DATA:tree(  lines,min,    node)
  lines = lines or self.lines
  min = min or (#lines)^the.min
  local node={here=lines}
  if #lines > min then
    local wests, easts
    wests, easts, node.c = self:half(lines)
    node.west            = self:tree(wests, min)
    node.east            = self:tree(easts, min) end
  return node end
-----------------------------------------------------------------------------------------
local function show(node, b4)
  local function mode(t) return t[#t//2 + (#t%2==1 and 1 or 0)] end
  b4 = b4 or ""
  if node then
    print(b4..(node.c and rnd(node.c) or o(mode(node.here).raw))) 
    show(node.west, "|.. ".. b4)
    show(node.east, "|.. ".. b4) end end

local function ok(t)
  local lo,hi={},{}
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
      assert(x//1 == x,fmt("[%s] not an int",x)) 
      lo[c-1] = math.min(x, (lo[c-1] or  math.huge))
      hi[c-1] = math.max(x, (hi[c-1] or -math.huge)) end end
  return t,lo,hi end

local function prep(cols,lo,hi)
  local lines = {}
  for _,t in pairs(cols) do
    local raw,cooked = {},{}
    for c=2,#cols-2 do
      local lo1, hi1 = lo[c-1], hi[c-1]
      local v = t[c]
      raw[c-1]    = v
      cooked[c-1] = v == "?" and v or (v - lo1)/(hi1 - lo1) end
    lines[ 1+#lines ] = LINE(raw,cooked,t[1],t[#t]) end 
  return lines end
------------------------------------------------------------------------------------------
--- ## Start-up
local eg={}

function eg.the()   lib.oo(the) end
function eg.ok()    
  local t,lo,hi = ok(dofile(the.file)) 
  for _,line in pairs(prep(t.cols,lo,hi)) do
    oo(line) end end 

function eg.dist()    
  local t,lo,hi = ok(dofile(the.file)) 
  local d=DATA(prep(t.cols,lo,hi))  
  map(d:furthest(d.lines),oo)end 

function eg.tree()    
  local t,lo,hi = ok(dofile(the.file)) 
  local d=DATA(prep(t.cols,lo,hi))  
  show(d:tree(d.lines,1)) end 

if lib.required() then return {cluster=cluster,columns=columns} else lib.main(the,eg) end 
