-- Some general LUA tricks.    
-- (c)2022 Tim Menzies <timm@ieee.org> BSD-2 license
local l={}
-----------------------------------------------------------------------------------------
-- ## Linting
local b4={}; for k,v in pairs(_ENV) do b4[k]=v end
function l.rogues() --> nil; report rogue locals
  for k,v in pairs(_ENV) do
    if not b4[k] then print( l.fmt("#W ?%s %s",k,type(v)) ) end end end
-----------------------------------------------------------------------------------------
-- ## Maths
function l.max(...) return math.max(...) end --> n; return max
function l.min(...) return math.min(...) end --> n; return min

function l.same(x,...) --> x; return `x` unmodified
  return x end

function l.rnd(n, nPlaces) --> num. return `n` rounded to `nPlaces`
  local mult = 10^(nPlaces or 3)
  return math.floor(n * mult + 0.5) / mult end

function  l.per(t,p) --> num; return the `p`th(=.5) item of sorted list `t`
  p=math.floor(((p or .5)*#t)+.5); return t[math.max(1,math.min(#t,p))] end

function l.pers(t,nps) --> t; return the `nps` items of sorted list `t`
   return l.map(nps,function(p) return l.per(t,p) end) end
-----------------------------------------------------------------------------------------
-- ### Random number generator
-- The LUA doco says its random number generator is not stable across platforms.
-- Hence, we use our own (using Park-Miller).
local Seed=937162211
function l.srand(n)  --> nil; reset random number seed (defaults to 937162211) 
  Seed = n or 937162211 end

function l.rand(nlo,nhi) --> num; return float from `nlo`..`nhi` (default 0..1)
  nlo, nhi = nlo or 0, nhi or 1
  Seed = (16807 * Seed) % 2147483647
  return nlo + (nhi-nlo) * Seed / 2147483647 end

function l.rint(nlo,nhi)  --> int; returns integer from `nlo`..`nhi` (default 0..1)
  return math.floor(0.5 + l.rand(nlo,nhi)) end
-----------------------------------------------------------------------------------------
-- ## Lists
function l.list(t) --> t; ensure `t` has indexes `1.. size(t)`
  local u={}; for _,x in pairs(t) do u[1+#u] = x end; return u end

function l.any(t) --> any; return any item from `t`, picked at random
  return t[l.rint(#t)] end

function l.many(t,n) --> t; return `n` items from `t`, picked at random
  local u={}; for i=1,n do l.push(u, l.any(t)) end; return u end 

function l.shuffle(t,   j) --> t;  Randomly shuffle, in place, the list `t`.
  for i=#t,2,-1 do j=math.random(i); t[i],t[j]=t[j],t[i] end; return t end

function l.copy(t) --> t; return a deep copy of `t.
  if type(t) ~= "table" then return t end
  local u={}; for k,v in pairs(t) do u[k] = l.copy(v) end
  return setmetatable(u,getmetatable(t))  end

function l.push(t, x) --> any; push `x` to end of list; return `x` 
  table.insert(t,x); return x end

function l.slice(t, go, stop, inc) --> t; return `t` from `go`(=1) to `stop`(=#t), by `inc`(=1)
  if go   and go   < 0 then go=#t+go     end
  if stop and stop < 0 then stop=#t+stop end
  local u={}; for j=(go or 1)//1,(stop or #t)//1,(inc or 1)//1 do u[1+#u]=t[j] end
  return u end
-----------------------------------------------------------------------------------------
-- ### Meta
function l.kap(t, fun) --> t; map function `fun`(k,v) over list (skip nil results) 
  local u={}; for k,v in pairs(t)do u[k]=fun(k,v) end; return u end

function l.keys(t) --> t; sort+return `t`'s keys (ignore things with leading `_`)
  local function want(k,x) if tostring(k):sub(1,1) ~= "_" then return k end end
  local u={}; for k,v in pairs(t) do if want(k) then u[1+#u] = k end end
  return l.sort(u) end

function l.map(t, fun)  --> t; map function `fun`(v) over list (skip nil results) 
  local u={}; for i,v in pairs(t)do u[1+#u]=fun(v) end;return u end
-----------------------------------------------------------------------------------------
-- ### Sorting Lists
function l.gt(s) --> fun; return a function that sorts ascending on `s'.
  return function(a,b) return a[s] > b[s] end end

function l.lt(s) --> fun; return a function that sorts descending on `s`.
  return function(a,b) return a[s] < b[s] end end

function l.sort(t, fun) --> t; return `t`,  sorted by `fun` (default= `<`)
  table.sort(t,fun); return t end
-----------------------------------------------------------------------------------------
-- ## Coercion
-- ### Strings to Things
function l.coerce(s) --> any; return int or float or bool or string from `s`
  local function fun(s1)
    if s1=="true"  then return true  end
    if s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function l.settings(s,    t) --> t;  parse help string to extract a table of options
  t={}; s:gsub("\n[%s]+[-][%S]+[%s]+[-][-]([%S]+)[^\n]+= ([%S]+)",
               function(k,v) t[k]=l.coerce(v) end)
  t._help = s
  return t end

function l.csv(sFilename,fun) --> nil; call `fun` on rows (after coercing cell text)
  local src,s,t  = io.input(sFilename)
  while true do
    s = io.read()
    if   s
    then t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t]=l.coerce(s1) end; fun(t)
    else return io.close(src) end end end
-----------------------------------------------------------------------------------------
-- ### Things to Strings
function l.fmt(sControl,...) --> str; emulate printf
  return string.format(sControl,...) end

function l.oo(t)  --> nil; print `t`'s string (the one generated by `o`)
  print(l.o(t))
  return t end

function l.o(t,  seen) --> str; table to string (recursive)
  if type(t) ~= "table" then return tostring(t) end
  local pre = t._is and l.fmt("%s%s",t._is,t._id or "") or ""
  seen=seen or {}
  if seen[t] then return l.fmt("<%s>",pre) end
  seen[t]=t
  local function filter(k) return l.fmt(":%s %s",k,l.o(t[k],seen)) end
  local u   = #t>0 and l.map(t,tostring) or l.map(l.keys(t),filter)
  return pre.."{".. table.concat(u," ").."}" end
--------------------------------------------------------------------------------
-- ## Objects
local _id=0
local function id() _id=_id+1; return _id end

function l.obj(s,    t,new) --> t; create a klass and a constructor + print method
  local function new(k,...) 
     local i=setmetatable({_id=id()},k); t.new(i,...); return i end
  t={_is=s, __tostring = l.o}
  t.__index = t;return setmetatable(t,{__call=new}) end
--------------------------------------------------------------------------------
-- ### Start-up stuff
function l.cli(options) --> t; update key,vals in `t` from command-line flags
  for k,v in pairs(options) do
    local v=tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
         v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    options[k] = l.coerce(v) end
  return options end

function l.run1(options,fun) -->x; reset seed; call `fun`; afterwards, reset config
  local was=l.copy(options)
  math.randomseed(options.seed or 937162211)
  local status, result
  if options.dump then 
    status,result=true, fun() 
  else
    status,result=pcall(fun) -- do not crash and dump on error
  end
  for k,v in pairs(was) do options[k]=v end -- undo any changes to the config
  if not status then return false else return result end end

function l.runs(options,funs)
  local fails = 0
  for _,k in pairs(l.keys(funs)) do              
    if options.go == "all" or options.go==k then 
      if   l.run1(options, funs[k]) == false      
      then print(l.fmt("FAIL ❌ on [%s]",k))
           fails = fails + 1                 
      else print(l.fmt("PASS ✅ on [%s]",k)) end end end 
  return fails end

function l.main(options,funs)
  l.cli(options)
  if options.help then os.exit(print(l.fmt("\n%s\n",options._help))) end
  local fails = l.runs(options,funs)
  for k,v in pairs(_ENV) do 
    if not b4[k] then print(l.fmt("#W ?%s %s",k,type(v))) end end 
  os.exit(fails) end

function l.required() return pcall(debug.getlocal,5,1) end
--------------------
return l
