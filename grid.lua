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
local LINE=obj"LINE"
function LINE:new(cells,lhs,rhs)
  self.cells, self.lhs, self.rhs = cells, lhs or "", rhs or "" end

local dist,furthest,furthests
function dist(line1,line2)
  local n,d = 0,0
  for c,x in pairs(line1.cells) do 
    n = n + 1
    d = d + math.abs(x - line2.cells[c])^the.p end
  return (d/n)^(1/the.p) end

function furthest(l1, lines)
  local function fun(l2) 
    if l1._id ~= l2._id then return {left=l1, right=l2, dist=dist(l1,l2)} end end
  return sort(map(lines, fun), gt"dist")[1] end

function furthest2(lines)
  return sort(map(lines, function(line1) return furthest(line1,lines) end), gt"dist") end

local project, half,tree,show
function project(a,b,c) -->  nx,ny,isStable; find x,y from a line connecting `left,right`.
  x1 = (a^2 + c^2 - b^2) / (2*c)
  x2 = math.max(0, math.min(1, x1)) -- in the incremental case, x1 might be outside 0,1
  return x, (x2^2 - a^2)^.5, math.abs(x1 - x2) > the.X  end

function half(lines) --> lines1,lines2,n; all the lines, divided by distance to 2 distant points
  local far  = furthest2(lines)
  local ymax,yfar = 0
  local function fun(line)
    local x1,y1 = project( dist(line, far.left), dist(line, far.right), far.dist)
    if y1>ymax then ymax,yfar= y1,line end
    return {here=line,  x=x1,y=y1} end
  local lefts,rights = {},{}
  for n,one in pairs(sort(map(lines, fun), lt"x")) do
    one.here.x = one.here.x or one.x
    one.here.y = one.here.y or one.y/ymax 
    push(n <= (#lines)//2 and lefts or rights, one.here) end
  return lefts, rights, far.dist end

function tree(lines,min,    node)
  min = min or (#lines)^the.min
  local node={}
  if #rows > min then
    local lefts, rights
    lefts, rights, node.c = half(lines)
    node.left  = tree(lefts,min)
    node.right = tree(rights,min) end
  return node end

function show(node, b4)
  b4 = b4 or ""
  if node then
    io.write(b4..(node.c and rnd(node.c) or ""))
    print(node.left and "" or node.here.txt)
    tree(node.left,  "|.. ".. b4)
    tree(node.right, "|.. ".. b4) end  end

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
  return t,lo,hi end

local function columns(cols)
  local function asColumn(lo,hi,t) 
    local tmp = slice(t,2,-2)
    return {raw  = tmp,
            cells= map(tmp, function(x) return (x - lo)/(hi - lo +1E-32) end),
            lhs  = t[1], 
            rhs  = t[#t]} end
  return map(cols,asColumn) end

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
