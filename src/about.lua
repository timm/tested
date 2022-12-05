#!/usr/bin/env lua
---               __                          __      
---              /\ \                        /\ \__   
---       __     \ \ \____    ___    __  __  \ \ ,_\  
---     /'__`\    \ \ '__`\  / __`\ /\ \/\ \  \ \ \/  
---    /\ \L\.\_   \ \ \L\ \/\ \L\ \\ \ \_\ \  \ \ \_ 
---    \ \__/.\_\   \ \_,__/\ \____/ \ \____/   \ \__\
---     \/__/\/_/    \/___/  \/___/   \/___/     \/__/

local l = require"lib"
local the = l.settings[[   
about.lua : summarize a table
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

USAGE:   about.lua  [OPTIONS]

OPTIONS:
  -d  --dump  on crash, print stackdump = false
  -f  --file  csv file                  = ../data/auto93.csv
  -g  --go    start-up action           = data
  -h  --help  show help                 = false
]]
local csv,push,kap,o,oo,obj,rnd = 
         l.csv,        -- file tricks
         l.push,l.kap, -- list tricks
         l.o,l.oo,     -- printing tricks
         l.obj,        -- object tricks
         l.rnd         -- random number tricks
--------------------------------------------------------------------------------
-- ## NUM
-- Summarizes a stream of numbers
local NUM = obj"NUM"
function NUM:new(  n,s) --> NUM;  constructor; optionally for column `n` named `s` 
  self.at, self.txt  = n or 0, s or ""
  self.n, self.mu, self.m2 = 0, 0, 0
  self.lo, self.hi = math.huge, -math.huge end

function NUM:add(n) --> NUM; add `n`, update min,max,standard deviation
  if n ~= "?" then
    self.n  = self.n + 1
    local d = n - self.mu
    self.mu = self.mu + d/self.n
    self.m2 = self.m2 + d*(n - self.mu)
    self.sd = (self.m2 <0 or self.n < 2) and 0 or (self.m2/(self.n-1))^0.5 
    self.lo = math.min(n, self.lo)
    self.hi = math.max(n, self.hi) end end

function NUM:mid(x) return self.mu end --> n; return mean
function NUM:div(x) return self.sd end --> n; return standard deviation
--------------------------------------------------------------------------------
-- ## SYM
local SYM = obj"SYM"
function SYM:new(n,s)
  self.at , self.txt = n or 0, s or ""
  self.n   = 0
  self.has = {}
  self.most, self.mode = 0,nil end

function SYM:add(x) 
  if x ~= "?" then 
   self.n = self.n + 1 
   self.has[x] = 1 + (self.has[x] or 0)
   if self.has[x] > self.most then
     self.most,self.mode = self.has[x], x end end end 

function SYM:mid(x) return self.mode end
function SYM:div(x) 
  local function fun(p) return p*math.log(p,2) end
  local e=0; for _,n in pairs(self.has) do e = e - fun(n/self.n) end 
  return e end
--------------------------------------------------------------------------------------------
-- ## COLS
local COLS = obj"COLS"
function COLS:new(t)
  self.names, self.all, self.x, self.y = t,{},{},{} 
  for n,s in pairs(t) do 
    local col = push(self.all, s:find"^[A-Z]+" and NUM(n,s) or SYM(n,s))
    if not s:find"X$" then
      push(s:find"[!+-]$" and self.y or self.x, col) end end end
    
function COLS:add(row)
  for _,cols in pairs{self.x, self.y} do
    for _,col in pairs(cols) do
      col:add(row[col.at]) end end 
  return row end
--------------------------------------------------------------------------------------------
-- ## DATA
local DATA = obj"DATA"
function DATA:new(src) --> DATA; `src` is either (a) a file name string or (b) list or rows
  self.cols, self.rows = nil,{}
  if   type(src)=="string" 
  then csv(src,       function(row) self:add(row) end)
  else map(src or {}, function(row) self:add(row) end) end end

function DATA:add(row) 
  if self.cols then push(self.rows, self.cols:add(row)) else self.cols = COLS(row) end end

function DATA:stats(  fun,cols,places)
  local t={}
  for _,col in pairs(cols or self.cols.y) do 
    local v = getmetatable(col)[fun or "mid"](col)
    t[col.txt] = type(v)=="number" and rnd(v,places) or v end
  return t end
--------------------------------------------------------------------------------------------
-- ## Start-up
local eg={}

function eg.the() oo(the) end

function eg.data() 
  local d= DATA(the.file)
  print("y mid     :  " .. o(d:stats("mid",nil,2))) 
  print("y spread  :  " .. o(d:stats("div",nil,2))) 
  print("x mid     :  " .. o(d:stats("mid", d.cols.x,2))) 
  print("x spread  :  " .. o(d:stats("div", d.cols.x,2))) end

if l.required() then return {STATS=STATS} else l.main(the,eg) end 
