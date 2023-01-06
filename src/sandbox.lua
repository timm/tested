t1={bins=4,lo=10, hi=90, bins={[10]=5,[30]=3,[50]=10,[70]=20,[90]=0}}

--ins        5     3    10   20   0
--old    10    30    50   70     90 
--new  5    15    35     55    85    95
--     5 10 15 30 35  50 55 70 85 90 95

for j,new in pairs(news) do

1={lo=5,n=0},
2={lo=10,n=10}

-- small bins inside large nins
print(t1.bins[30])

for j,new in pairs(news) do
  for i,old in pairs(olds) do
    v0=new.lo
    v1=new.lo
    v2=new[i+1] or math.huge or olds[i+1].lo
    if v1 > v0 then
      a = (v1-v0)/(v2-v1)
      b = 1-a
    if v1 <= v0 and v0 <= v2 then 
