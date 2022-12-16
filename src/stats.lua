---          __                 __              
---         /\ \__             /\ \__           
---   ____  \ \ ,_\     __     \ \ ,_\    ____  
---  /',__\  \ \ \/   /'__`\    \ \ \/   /',__\ 
--- /\__, `\  \ \ \_ /\ \L\.\_   \ \ \_ /\__, `\
--- \/\____/   \ \__\\ \__/.\_\   \ \__\\/\____/
---  \/___/     \/__/ \/__/\/_/    \/__/ \/___/ 
                                            
-- ## Scott-Knott tests
-- If statistics gets too complicated then the solution is easy: use less stats!
-- Scott-Knott is a way to find differences in N
-- treatments using at most $O(log2(N))$ comparisons. This is useful since:
-- - Some statistical tests are slow (e.g. bootstrap). 
-- - If we run an all-pairs comparisons between
--   N tests at confidence C, then we only are $C_1=C_0^{(n*(n-1)/2}$ confident in the results.
--   This is far less than the $C_2=Ci_0^{log2(N)}$ confidence found from Scott-Knott;
--   - e.g for N=10, at $C_1,C_2$ at $C_0=95$% confidence is one percent versus
--    75 percent (for Scott-Knott).
--  
-- Scott-Knott sorts treatments on the their median values, then looks for the split
-- that maximizes the difference in the split before and after the split. If statistical
-- tests say that the splits are different, then we recurse on each half. This generates
-- a tree of treatments where the treatments in the left-most node get ranked one, the next
-- get ranked two, etc. 
--
-- As to stats tests, this code checks for difference in the splits using two non-parametric tests:
-- - A MannWhitney U test that checks if the ranks of the two splits are distinguishable;
-- - A CliffsDelta effect size test (which reports if there is enough difference in the splits)

--- In this code:
--- - vars are global by default unless marked with "local"
--- - functions have to be defined before they are used.
--- - #t is length of list t (and empty lists have #t==0)
--- - tables start and end with {}
--- - tables can have numeric or symbolic fields.
--- - for pos,x in pairs(t) do is the same as python's 
---   for pos,x in enumerate(t) do
--- 
--- In the function arguments, the following conventions apply:
--- - n == number
--- - s == string
--- - t == table
--- - is == boolean
--- - x == anything
--- - fun == function
--- - UPPER = class
--- - lower = instance; e.g. rx is an instance of RX
--- - xs == a table of "x"; e.g. "ns" is a list of numbers

local b4={}; for k,_ in pairs(_ENV) do b4[k]=k end
local lt,sort,fmt,map,oo,o,median,tiles
---------------------------------------------------------------------------------------------------
local cliffsDelta
function cliffsDelta(ns1,ns2, dull) --> bool; true if different by a trivial amount
  local n,gt,lt = 0,0,0
  for _,x in pairs(ns1) do
    for _,y in pairs(ns2) do
      n = n + 1
      if x > y then gt = gt + 1 end
      if x < y then lt = lt + 1 end end end
  return math.abs(lt - gt)/n <= dull end
---------------------------------------------------------------------------------------------------
local RX,add,adds,rank
function RX(t,s)  --> RX; constructor for treatments. ensures treatment results are sorted
  return {name=s or"",rank=0,t=sort(t or {})} end 

function rank(rx) return rx.ranks/rx.n end --> n; returns average range in a treatment  

function add(rx,ns) --> RX; returns a new rank combining an old rank with a list of numbers `ns`
  rx = rx or RX()
  ns = ns and (ns.rank and ns.t or ns) or {} -- ensure ns is a list
  local u={}
  for _,x in pairs(rx.t) do u[1+#u]=x end
  for _,x in pairs(ns)   do u[1+#u]=x end
  return RX(u) end

function adds(rxs,lo,hi) --> RX; combines treatments from index `rxs[lo]` to `rxs[hi]`
  local rx=RX(); for i=lo,hi do rx = add(rx,rxs[i]) end; return rx end
---------------------------------------------------------------------------------------------------
local ranks,mwu,critical
function critical(c,n1,n2)
  local t={
    [99]={{0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 2, 2,  2,  2,  3,  3},
          {0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 5, 5,  6,  6,  7,  8},
          {0, 0, 0, 1, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 10, 11, 12, 13},
          {0, 0, 1, 2, 3, 4, 5, 6, 7, 9,10,11,12,13, 15, 16, 17, 18},
          {0, 0, 1, 3, 4, 6, 7, 9,10,12,13,15,16,18, 19, 21, 22, 24},
          {0, 1, 2, 4, 6, 7, 9,11,13,15,17,18,20,22, 24, 26, 28, 30},
          {0, 1, 3, 5, 7, 9,11,13,16,18,20,22,24,27, 29, 31, 33, 36},
          {0, 2, 4, 6, 9,11,13,16,18,21,24,26,29,31, 34, 37, 39, 42},
          {0, 2, 5, 7,10,13,16,18,21,24,27,30,33,36, 39, 42, 45, 48},
          {1, 3, 6, 9,12,15,18,21,24,27,31,34,37,41, 44, 47, 51, 54},
          {1, 3, 7,10,13,17,20,24,27,31,34,38,42,45, 49, 53, 56, 60},
          {1, 4, 7,11,15,18,22,26,30,34,38,42,46,50, 54, 58, 63, 67},
          {2, 5, 8,12,16,20,24,29,33,37,42,46,51,55, 60, 64, 69, 73},
          {2, 5, 9,13,18,22,27,31,36,41,45,50,55,60, 65, 70, 74, 79},
          {2, 6,10,15,19,24,29,34,39,44,49,54,60,65, 70, 75, 81, 86},
          {2, 6,11,16,21,26,31,37,42,47,53,58,64,70, 75, 81, 87, 92},
          {3, 7,12,17,22,28,33,39,45,51,56,63,69,74, 81, 87, 93, 99},
          {3, 8,13,18,24,30,36,42,48,54,60,67,73,79, 86, 92, 99,105}},
    [95]={{0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6,  6,  7,  7,  8},
          {0, 0, 1, 2, 3, 4, 4, 5, 6, 7, 8, 9,10,11, 11, 12, 13, 14},
          {0, 1, 2, 3, 5, 6, 7, 8, 9,11,12,13,14,15, 17, 18, 19, 20},
          {1, 2, 3, 5, 6, 8,10,11,13,14,16,17,19,21, 22, 24, 25, 27},
          {1, 3, 5, 6, 8,10,12,14,16,18,20,22,24,26, 28, 30, 32, 34},
          {2, 4, 6, 8,10,13,15,17,19,22,24,26,29,31, 34, 36, 38, 41},
          {2, 4, 7,10,12,15,17,20,23,26,28,31,34,37, 39, 42, 45, 48},
          {3, 5, 8,11,14,17,20,23,26,29,33,36,39,42, 45, 48, 52, 55},
          {3, 6, 9,13,16,19,23,26,30,33,37,40,44,47, 51, 55, 58, 62},
          {4, 7,11,14,18,22,26,29,33,37,41,45,49,53, 57, 61, 65, 69},
          {4, 8,12,16,20,24,28,33,37,41,45,50,54,59, 63, 67, 72, 76},
          {5, 9,13,17,22,26,31,36,40,45,50,55,59,64, 67, 74, 78, 83},
          {5,10,14,19,24,29,34,39,44,49,54,59,64,70, 75, 80, 85, 90},
          {6,11,15,21,26,31,37,42,47,53,59,64,70,75, 81, 86, 92, 98},
          {6,11,17,22,28,34,39,45,51,57,63,67,75,81, 87, 93, 99,105},
          {7,12,18,24,30,36,42,48,55,61,67,74,80,86, 93, 99,106,112},
          {7,13,19,25,32,38,45,52,58,65,72,78,85,92, 99,106,113,119},
          {8,14,20,27,34,41,48,55,62,69,76,83,90,98,105,112,119,127}}}
    n1,n2 = n1-2,n2-2
    local u=t[c]
    assert(u,"confidence level unknown")
    local n1 = math.min(n1,#u[1])
    local n2 = math.min(n2,#u)
    return u[n2][n1] end

function ranks(pop1,pop2)
  local x,t,u = 0,{},{}
  for _,pop in pairs{pop1,pop2} do
    for _,x in pairs(pop) do t[1+#t] = x end end
  t = sort(t)
  x = t[1]
  u[x] = {x=x,n=1,ranks=1}
  for i=2,#t do
    if t[i-1] ~= t[i] then x=t[i]; u[x] = {x=x, n=0,ranks=0}  end    
    u[x].x     = t[i]
    u[x].ranks = u[x].ranks + i 
    u[x].n     = u[x].n + 1 end
  return u end

function mwu(ns1,ns2,nConf) -->bool; True if ranks of `ns1,ns2` are different at confidence `nConf` 
  local t,r1,r2,u1,u2,c = ranks(ns1,ns2)
  local n1,n2= #ns1, #ns2
  assert(n1>=3,"must be 3 or more")
  assert(n2>=3,"must be 3 or more")
  c  = critical(nConf or 95,n1,n2)
  r1=0; for _,x in pairs(ns1) do r1=r1+ rank(t[x]) end
  r2=0; for _,x in pairs(ns2) do r2=r2+ rank(t[x]) end
  u1 = n1*n2 + n1*(n1+1)/2 - r1
  u2 = n1*n2 + n2*(n2+1)/2 - r2
  local word = math.min(u1,u2)<=c 
  return math.min(u1,u2)<=c  end  -- not evidence evidence to say they are the same
---------------------------------------------------------------------------------------------------
local sk
function sk(t,  nConf,nDull,nWidth) --> rxs; return treatments, sorted on median, ranked by stats
  nDull = nDull or 0.147 -- for effect size test; threshold for "small effect"
  nWidth = nWidth or 40  -- width of text display of numbers
  nConf  = nConf  or 95  -- for significance test; confidence for testing 'distinguish-ability'
  local ranking,rxs,argmax
  function argmax(lo,hi) -- find `cut` in `rxs` that maximizes difference in medians
    local b4,max,mid,n,cut -- if cut always remains `nil` then no cut found
    b4 = adds(rxs,lo,hi)
    max, mid, n = -1, median(b4.t), #b4.t
    for i=lo,hi-1 do
      local l,r,n1,n2,tmp
      l = adds(rxs,lo,i)
      r = adds(rxs,i+1,hi)
      n1,n2 = #l.t, #r.t
      tmp = n1/n*math.abs(mid - median(l.t)) + n2/n*math.abs(mid - median(r.t))
      if tmp > max then max,cut = tmp,i end 
    end  
    if   cut 
    then local l,r = adds(rxs,lo,cut), adds(rxs,cut+1,hi)
         if mwu(r.t,l.t,nConf) and not cliffsDelta(r.t, l.t, nDull) then
           argmax(lo,cut)
           return argmax(cut+1,hi)  end end -- return here (so we skip over the next 2 lines) 
    for i=lo,hi do rxs[i].rank = ranking end -- if we did not cut, label all current `rx` as `rank`
    ranking = ranking+1 -- increment `rank` (so next thing has rank+1)
  end --------------------------------------------------------------------
  ranking = 1
  rxs = {}
  for k,t1 in pairs(t) do rxs[1+#rxs]= RX(t1,k) end
  rxs = sort(rxs, function(a,b) return median(a.t) < median(b.t) end) -- sorted on median
  argmax(1, #rxs) -- recursively split
  return tiles(rxs,nWidth) end 
  --return rxs end 
---------------------------------------------------------------------------------------------------
-- ##  Lib
function sort(t,fun) table.sort(t,fun) return t end --> t; returns `t` sorted by `fun` 

function map(t,fun) --> t; returns copy of `t`, all items filtered by `fun`.
  local u={}; for _,x in pairs(t) do u[1+#u]=fun(x) end; return u end

function oo(t)  print(o(t)); return t end 
function o(t,     ok,out,show,shows)
  function ok(k)     return  tostring(k):sub(1,1) ~= "_" end
  function out(t)    return '{'..table.concat(map(t,o),", ")..'}' end
  function show(k,v) return string.format(":%s %s",k,o(v)) end 
  function shows(t)  
    local u={}; for k,v in pairs(t) do if ok(k) then u[1+#u]=show(k,v) end end;  return u end
  return type(t) ~= "table" and tostring(t) or out(#t>1 and t or sort(shows(t))) end

function median(t) --> n; assumes t is sorted 
  local n = #t//2
  return #t%2==0 and (t[n] +t[n+1])/2 or t[n+1] end

function tiles(rxs,width,fmt)
  width=width or 32
  fmt=fmt or "%5.2s"
  local lo,hi = math.huge, -math.huge
  for _,rx in pairs(rxs) do 
    lo,hi = math.min(lo,rx.t[1]), math.max(hi, rx.t[#rx.t]) end
  local function of(x,max) return math.max(1, math.min(max, x)) end
  local function norm(x) 
     return math.floor(of(width*(x-lo)/(hi-lo+1E-32)//1,width)) end
  for _,rx in pairs(rxs) do
    local t,u,a,b,c,d,e = rx.t,{}
    for i=1,width do u[1+#u]=" " end
    a,b,c,d,e= #t*.1, #t*.3, #t*.5, #t*.7, #t*.9
    a,b,c,d,e= of(a//1,#t), of(b//1,#t), of(c//1,#t), of(d//1,#t), of(e//1,#t)
    a,b,c,d,e= t[a], t[b], t[c], t[d], t[e]
    a,b,c,d,e= norm(a), norm(b), norm(c), norm(d), norm(e) 
    for i=a,b,1 do u[i]="-" end
    for i=d,e,1 do u[i]="-" end
    u[width//2] = "|" 
    u[c] = "*"
    rx.show = table.concat(u) .. 
              " {"..table.concat(
                      map({a,b,c,d,e},function(x) 
                                      return string.format(fmt,x) end),
                           ", ") .."}"
  end
  return rxs end
--------------------------------------------------------------------------------------------------
--- TESTS
local norm,eg0,eg1,eg2,eg3,eg4,eg5,eg6,eg7,eg8
function norm(mu,sd) 
  local sq,pi,log,cos,R = math.sqrt,math.pi,math.log,math.cos,math.random
  return  mu + sd * sq(-2*log(R())) * cos(2*pi*R()) end

local d1={placebo={7,5,6,4,12},
      data={3,6,4,2,1}}

local d2={x={3,4,2,6,2,5},
    y={9,7,5,10,6,8}}

local d3={usual={8,7,6,2,5,8,7,3},
    new={  9,9,7,8,10,9,6}}

function eg1()
  print("false",mwu(d3.usual,d3.usual))
  print("true",mwu(d3.usual,d3.new)) end

function eg2()
  print""
  print("true",mwu({0.34,0.49,0.51,0.6,.34,.49,.51,.6},{0.6,0.7,0.8,0.9,.6,.7,.8,.9}))
  print("true",mwu({0.15,0.25,0.4,0.35,0.15,0.25,0.4,0.35},{0.6,0.7,0.8,0.9,0.6,0.7,0.8,0.9}))
  print("false",mwu({0.6,0.7,0.8,0.9,.6,.7,.8,.9},{0.6,0.7,0.8,0.9,0.6,0.7,0.8,0.9}))
  print""
  print("true",mwu({0.34,0.49,0.51,0.6},{0.6,0.7,0.8,0.9}))
  print("true",mwu({0.15,0.25,0.4,0.35},{0.6,0.7,0.8,0.9}))
  print("false",mwu({0.6,0.7,0.8,0.9},{0.6,0.7,0.8,0.9})) end

function eg3()
  local d=1
  math.randomseed(1)
  for i=1,10 do
    local t1,t2={},{}
    for j=1,2560 do t1[1+#t1]=norm(10,1); t2[1+#t2]=norm(d*10,1) end
    print(d,d<1.15 and "false" or "true",mwu(t1,t2),mwu(t1,t1))
    d=d+0.1 end end

function eg0(txt,data)
  print("\n"..txt)
  for _,rx in pairs(sk(data)) do print("\t",rx.rank, rx.show) end end

function eg4()
  eg0("eg4",{
         x1={0.34,0.49,0.51,0.6,.34,.49,.51,.6},
         x2={0.6,0.7,0.8,0.9,.6,.7,.8,.9},
         x3={0.15,0.25,0.4,0.35,0.15,0.25,0.4,0.35},
         x4={0.6,0.7,0.8,0.9,0.6,0.7,0.8,0.9},
         x5={0.1,0.2,0.3,0.4,0.1,0.2,0.3,0.4}}) end

function eg5()
  eg0("eg5",{
        x1= { 0.34,0.49,0.51,0.6,0.34,0.49,0.51,0.6},
        x2={ 6,7,8,9 ,6,7,8,9}}) end

function eg6()
  eg0("eg6",{
   x1={ 0.1,0.2,0.3,0.4,0.1,0.2,0.3,0.4},
   x2={ 0.1,0.2,0.3,0.4,0.1,0.2,0.3,0.4},
   x3={6,7,8,9,6,7,8,9}}) end

function eg7()
  eg0("eg7",{
    x1={101,100,99,101,99.5,101,100,99,101,99.5},
    x2={101,100,99,101,100,101,100,99,101,100},
    x3={101,100,99.5,101,99,101,100,99.5,101,99},
    x4={101,100,99,101,100,101,100,99,101,100}}) end

function eg8()
  eg0("eg8",{
    x1={11,12,13,11,12,13},
    x2={14,13,15 ,14,12,12},
    x3={23,24,31,23,24,31},
    x4={32,33,34,32,33,34}}) end

eg4(); eg5(); eg6(); eg7();eg8()

for k,v in pairs(_ENV) do if not b4[k] then print("?",k,type(v)) end end