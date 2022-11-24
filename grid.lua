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
]]
local obj,fmt,o,oo,map,shuffle,lt,gt,sort,push,slice  =
        lib.obj,            -- object tricks
        lib.fmt, lib.o, lib.oo,     -- string tricks
        lib.map, lib.shuffle, lib.lt, lib.gt, lib.sort, -- less strings
        lib.push, lib.slice  -- list tricks
-----------------------------------------------------------------------------------------
local dist,furthest,x2d,y2d,half,cluster,tree,asConstruct


function cluster(all)
  local function dist(one,two)
     local n,d = 0,0
     for c,x in pairs(one.cells) do 
       n = n+1
       d = d+math.abs(x - two.cells[c])^the.p end
    return (d/n)^(1/the.p) 
  end --------------------
  local function furthest(some)
    local t={}
    for i = 1,#some do
      for j = i+1,#some do
        local left,right = all[i], all[j]
        push(t, {left=left, right=right, d=dist(left, right)}) end end
    return sort(t, gt"d")[1] 
  end ---------------------
  local function half(some)
    local far = furthest(some)
    local left,right,c = far.left, far.right, far.d
    local function project(this,    a,b,x) 
      a,b = dist(this,left), dist(this,right)
      x   = (a^2 + c^2 - b^2) / (2*c)
      x   = math.max(0, math.min(1, x))
      return {this=this,  x=x, y =(x^2 - a^2)^.5} end
    local lefts,rights = {},{}
    for n,one in pairs(sort(map(some, project), lt"x")) do
      one.this.x = one.this.x or one.x
      one.this.y = one.this.y or one.y
      push(n <= (#some)//2 and lefts or rights, one.this) end
    return lefts, rights, c 
  end ---------------------
  local function tree(some,min,    lefts,rights,node)
    min = min or (#some)^the.min
    if #rows > min then
      lefts, rights, node.c = half(some)
      node.left  = tree(lefts,min)
      node.right = tree(rights,min) end
    return node 
  end --------- 
  local function show(node, b4)
    b4 = b4 or ""
    if node then
      io.write(b4..(node.c and rnd(node.c) or ""))
      print(node.left and "" or node.txt)
      tree(node.left,  "|.. ".. b4)
      tree(node.right, "|.. ".. b4) end 
  end ---------------------------------
  return half, tree, show end

local function ok(t)
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
