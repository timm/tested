t1={bins=4,lo=10, hi=90, bins={[10]=5,[30]=3,[50]=10,[70]=20,[90]=0}}

--        v0
--old     10    30   50   70    90 
--new  5     15    35   55  85     95
--     v1    v2                  v1    v2
--     5 10 15 30 35 50 55 70 85 90 95



function RANGE(lo,hi) return {lo=lo, hi=hi,n=0} end

function overlap(i,j,      n) -- steal from i, add to j
  n=0
  if     j.lo  < i.lo and j.hi >= i.lo and j.hi <= i.hi                  then n= j.hi - i.lo 
  elseif j.lo >= i.lo and j.lo <= i.hi and j.hi >= i.lo and j.hi <= i.hi then n= j.hi - j.lo
  elseif j.lo >= i.lo and j.lo <= i.hi and j.hi >  i.lo                  then n= i.lo - j.hi end 
  return i.n * n/(i.hi - i.lo) end 

function transfer(olds,news)
  for _,old in pairs(olds) do 
    for _,new in pairs(news) do
      new.n = new.n + overlap(old,new) end end end 

-- small bins inside large nins
print(t1.bins[30])

for j,new in pairs(news) do   -- v1 v2
  for i,old in pairs(olds) do -- v0
    v1 = new.lo
    v2 = news[j+1] and news[j+1].lo
    v0 = old.lo
    if v0>=v1 and v2 and v0<=v2 then
      a = (v2-v0)/(v2-v1)
      b = 1-a
      new.n = new.n + old.n * a
      new.n = new.n + old.n * (1-a) end end end 
