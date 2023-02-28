

<small><p>&nbsp;
<a name=top></a>
<table><tr> 
<td><a href="/README.md#top">home</a>
<td><a href="/ROADMAP.md">roadmap</a>
<td><a href="http:github.com/timm/tested/issues">issues</a>
<td> <a href="/LICENSE.md">&copy;2022,2023</a> by <a href="http://menzies.us">tim menzies</a>
</tr></table></small>
<img  align=center width=600 src="/docs/img/banner.png"></p>
<p> <img src="https://img.shields.io/badge/task-ai-blueviolet"><a
href="https://github.com/timm/tested/actions/workflows/tests.yml"> <img 
 src="https://github.com/timm/tested/actions/workflows/tests.yml/badge.svg"></a> <img 
 src="https://img.shields.io/badge/language-lua-orange"> <img 
 src="https://img.shields.io/badge/purpose-teaching-yellow"> <a 
 href="https://zenodo.org/badge/latestdoi/569981645"> <img 
 src="https://zenodo.org/badge/569981645.svg" alt="DOI"></a></p>

# onStats.lua

## Your task this week

As a team, implement the [stats.lua](/src/stas.lua) examples shown in
[stats.out](/etc/out/stats.out)


## Today's lecture: does 42==44?

Clearly, "no", if they are point values.

But "yes", if they these are the median of a two different distributions with large variances.
- In which case we say that they are  _statistically indistinguishably_ by more more than a _small effect_

Why  are we asking this question?
- Because when we get our fishing gear working,
- we will compare results from different _treatments_
  (different fishing engines)
  - some of which use stochastic methods
  - so they will have to be re-run 20 times 
  - so we will be comparing 20 numbers from different treatments
  - welcome to stats.

## What Does "equal" Mean?

Take two stochastic search engines 
(e.g. simulated annealing and genetic algorithms).
Run them 10 times on the same problem.
Collect some scores.
Is one betters than another?

Example1

```
rx1.sa   10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
rx2.ga   12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
```

Is GA better than SA? How to find out?

When faced with new data, always chant the following mantra:

- First visualize it to get some intuitions;
- Then apply some statistics to double check those intuitions.

BTW, Sometimes, visualizations are enough:

- [CHIRP: A new classifier based on Composite Hypercubes on Iterated Random Projections](https://www.cs.uic.edu/~tdang/file/CHIRP-KDD.pdf)
- [Simpler Questions Can Lead To Better Insights](https://github.com/ds4se/chapters/blob/master/turhanb/theGraph.md), from
  Perspectives on Data Science for Software Engineering, Morgan-Kaufmann, 2015
  [Applications of Psychological Science for Actionable Analytics](https://download.arxiv.org/pdf/1803.05067v1.pdf)

But when you gotta do stats:

1. Visualize the data, somehow.
2. Check if the central tendency of one distribution is better than the other;
   e.g. compare their median values.
3. Check the different between the central tendencies is not some _small effect_.
4. Check if the distributions are _significantly different_;


## Visualize the Data

Let us look at 1000 numbers whose median value is 70 and whose 30th to 70th percentile
range is 40 to 80. We can visualize this using a horizontal percentil plot:


```
0   20   40   60    80   100
|----|----|----|----|----|

     ------       * ------ 
   
     ^   ^        ^ ^    ^
     |   |        | |    |
   q10   q30    q50 q70  q90      
```

The advantage of percentile plots is that we can show a lot of data in
very little space. E.g. the above chart could be show 30 numbers, or 30,000. 
And the chart below shows 10,000 numbers (1000 per treatment).
- Note that the _rank_ number of the LHS: 
  - this shows the treatments divided into groups.
  - Using the methods described below.

```
rank    rx       percentile plot                            10th    30th   50th    70th    90th
----    ----     --------------------------------------   --------------------------------------
    1    rx6     -*-               |                     {  8.79,   9.46,   9.97,  10.52,  11.29}
    1    rx1     -*-               |                     {  8.67,   9.43,  10.00,  10.54,  11.23}
    1    rx10     -*-              |                     {  8.75,   9.52,  10.03,  10.52,  11.33}
    1    rx7     -*-               |                     {  8.81,   9.51,  10.03,  10.51,  11.22}
    1    rx2     -*-               |                     {  8.84,   9.58,  10.04,  10.59,  11.40}
    2    rx3              -*--     |                     { 18.69,  19.45,  19.99,  20.50,  21.36}
    3    rx4                       |-*-                  { 28.71,  29.41,  29.97,  30.48,  31.22}
    3    rx5                       |-*-                  { 28.75,  29.50,  30.00,  30.58,  31.29}
    4    rx9                       |       ---* ---      { 36.13,  38.43,  39.90,  41.55,  43.83}
    4    rx8                       |         -*--        { 38.71,  39.51,  39.98,  40.46,  41.28}
```

<img align=right width=300 src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Normal_Distribution_PDF.svg/1440px-Normal_Distribution_PDF.svg.png">

Lets look another example, this time from half a dozen experiments (each experiment balding 32 numbers
ranging from 6 to 33,
with medians ranges 9.69 to 30.06). 

First we  need a place to put the treatments. Note that:
- when we store the numbers, we sort them;
- each treatment has a `show` string, initialized to "" (and we will change that, below).

```lua
function RX(t,s)  
  return {name=s or"",rank=0,t=sort(t or {}), show=""} end 
```
Then we might need to some way to find (e.g.) the median of those results `median(rx.t)`.
```lua
function mid(t,     n)    -- assime t is sorted
  t= t.has and t.has or t -- so we can find the mid of lists or RXs
  local n = #t//2
  return #t%2==0 and (t[n] +t[n+1])/2 or t[n+1] end
```
We can also find the standard deviation (`div`) of a treatment via the distance
from the 10th to the 90th percentile:
```lua
function div(t)
  t= t.has and t.has or t
  return (t[ #t*9//10 ] - t[ #t*1//10 ])/2.58 end
```
If we merge two RXs, better make sure the merged data is also sorted.
```lua
function merge(rx1,rx2,    rx3) 
  rx3 = RX({}, rx1.name)
  for _,t in pairs{rx1.has,rx2.has} do
     for _,x in pairs(t) do rx3.has[1+#rx3.has] = x end end
  table.sort(rx3.has) -- <== important step
  rx3.n = #rx3.has
  return rx3 end
```

Now, just for a demo, will create six sets of results with different means (but same standard deviations).
Note that when we create a list of treatments, we sort them by their median.
```lua
local m=math
local sq,pi,log,cos,r,gaussian = m.sqrt,m.pi,m.log,m.cos,m.random
function gaussian(mu,sd) 
  return mu + sd * sq(-2*log(r())) * cos(2*pi*r()) end

function egTiles()
  math.randomseed(the.seed)
  local data= {{},{},{},{},{},{}}
                                     -- mu     std
                                     -------   ---
  for i=1,32 do push(data[1],  gaussian(10,    1)) end
  for i=1,32 do push(data[2],  gaussian(10.1,  1)) end
  for i=1,32 do push(data[3],  gaussian(20,    1)) end
  for i=1,32 do push(data[4],  gaussian(30,    1)) end
  for i=1,32 do push(data[5],  gaussian(30.1,  1)) end
  for i=1,32 do push(data[6],  gaussian(10,    1)) end
  for k,v in pairs(data) do data[k] =  RX(sort(v),k) end
  data = sort(data,function(a,b) return median(a.t) < median(b.t) end ) -- sort via median
  for k,v in pairs(tiles(data)) do
    print("rx["..v.name.."]",o(v.show)) end end
```
The `tiles` function (shown below) pretty prints the distributions:
```
rx[1]	 -*--          |                 {  8.34,   9.06,   9.69,  10.52,  10.92}
rx[6]	---*-          |                 {  7.66,   9.24,   9.80,  10.44,  11.11}
rx[2]	---*-          |                 {  8.08,   9.38,   9.80,  10.74,  11.18}
rx[3]	             --*--               { 18.20,  19.32,  19.90,  20.66,  21.07}
rx[5]	               |           -*-   { 29.04,  29.52,  29.81,  30.27,  30.97}
rx[4]	               |           -*--  { 28.84,  29.59,  30.06,  30.26,  31.20}
```
Note we might think that these results divide into three groups (1,6,2). That is
our intuition. Lets see below if the stats works for us.

To print multiple `RX` objects:
- first find the most `lo` and `hi` values in all the treatments [1]. 
- then, for each treatment, generate a print string add it as a `.show` field.
  - by normalizing each number 0..1 from `lo` to `hi`  [2]
  - the showing it as a number somewhere between `lo` to `hi` (see the `at` function, inside `tiles`)
  - Aside: make sure all our psoitions are  integer [3]

```lua
-- in the following the.width = 32
function tiles(rxs) 
  local lo,hi = math.huge, -math.huge
  for _,rx in pairs(rxs) do 
    lo,hi = math.min(lo,rx.t[1]), math.max(hi, rx.t[#rx.t]) end  -- [1]
  for _,rx in pairs(rxs) do
    local t,u = rx.t,{}
    local function of(x,max) return math.max(1, math.min(max, x)) end
    local function at(x)  return t[ of(#t*x//1, #t) ] end   -- find the xth percentile in "rx.t" 
    local function pos(x) return math.floor(                                        -- [3]
                                  of(the.width*(x-lo)/(hi-lo+1E-32)//1, the.width)  -- [2]
                                 ) end 
    for i=1,the.width do u[1+#u]=" " end                    -- file the  the show string with blanks
    local a,b,c,d,e= at(.1), at(.3), at(.5), at(.7), at(.9) -- find the 20th percentile breaks
    local A,B,C,D,E= pos(a), pos(b), pos(c), pos(d), pos(e) -- find positions of percentiles.
    for i=A,B do u[i]="-" end                               -- add "-" to the 10th to30th range
    for i=D,E do u[i]="-" end                               -- add "-" to the 70th to 90th range
    u[ the.width//2 ] = "|"                                 -- add "|" to the middle 
    u[C] = "*"                                              -- marked "C" (the .5 pos) with "*"
    rx.show = table.concat(u)                               -- build the tile string
    rx.show = rx.show.." {"..table.concat(                  -- add the numbers for 10th,30th,50th, etc.
                               map({a,b,c,d,e},
                                 function(x) 
                                   return string.format(the.Fmt,x) end),", ") .."}"
  end
  return rxs end
```
## Statistics

As to statistical tests,   two kinds of background assumptions

| analysis| assumptions  | effect-size: different by more than a trivial amount? | significance test: how much does one overlap the other?|
|---------|--------------|--------------|------------------|
|parametric | data look like bell-shaped curves| e.g. cohen-D | t-test|
|non-parametric | nil | cliff's delta | mann-whitney U test|

<img src="https://www.rasch.org/rmt/gifs/101over.gif" align=right width=400>

Note the different kinds of test:
- effect size: 
  - are two distributions different by more than a trivial amount?
- significance test (poorly named, maybe "_distinguishable_" test would be a better name): 
  - if I pull numbers from one distribution
    -  how likely is it that that number comes from the other distribution?
- If two treatments  are significantly different _and_ are different by more than a small amunt 
  - only then can we say "worse" or "better". 
  - Otherwise, we can make no conclusions.

<br clear=all>

### Effect Size Tests

<img align=right width=300 
src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Normal_Distribution_PDF.svg/1440px-Normal_Distribution_PDF.svg.png">

Parametric methods assume that the numbers come from a bell-shaped curve 
(single max value, symmetrical distributions).
- those assumptions can be unrealistic but they do simplify the analysis.
- e.g. the `cohen-D` parametric effect-size method says that  two numbers are different if their separation is larger than `std*d`
  - As to what value of d to use, a
    widely cited paper by Sawilowsky [^saw] (this 2009 paper has 1100 citations).
    asserts that “small” and “medium” effects can be measured using
    d = 0.2 and d = 0.5 (respectively).
  - Splitting the difference, we will analyze
    this data looking for differences larger than d = (0.5 + 0.2)/2 = 0.35.
  - And finding the standard deviation is easy:   
    (90th - 10th) percentile of a sorted number, divided by 2.58.

[^saw]: Sawilowsky, S.S.: New effect size rules of thumb. Journal of Modern Applied Statistical
Methods 8(2), 26 (2009)

e.g. for papers using deep learners and the learning time is sooooo veeeeeery looooooong then we cannot
do multiple runs. Instead, we do one run with DL, other run with other methods, and look for some pattern
that holds across multiple data sets
- In the following, we find the BEST (e.g.) recall and mark in gray everything within cohen's-d of that best:
- THen see if some effect holds across multiple data sets.

<img width=600 align=center
src="https://user-images.githubusercontent.com/29195/221665722-aada3e5b-bcf2-4e2c-81f3-00203effa918.png">

If you doubt Cohen's-D (cause you doubt the normal assumption) then we can use
the non-parametric
`cliff's Delta` effect size test:
- We say say that any number `x` (from distribution1) has `gt` and `lt` numbers greater and less than it in
  distribution2 
  - So `x` is likely to belong in distribution2 if `abs(gt-lt) =0`.
    - i.e. it falls into the middle

Cliff’s d can be interpreted as negligible (<0.147), small (<0.33), medium (<0.474) and large (otheriwse) effects[^romo].
- so we will use .4 as the threshold between medium and small.

[^romo]: Romano, J., Kromrey, J. D., Coraggio, J., & Skowronek, J. (2006, February). 
  Appropriate statistics for ordinal level data: Should we really be using t-test and 
  Cohen’sd for evaluating group differences on the NSSE and other surveys. 
  In annual meeting of the Florida Association of Institutional Research (Vol. 177, p. 34).

```lua
function cliffsDelta(ns1,ns2, dull) --> bool; true if different by a trivial amount
  local n,gt,lt = 0,0,0
  for _,x in pairs(ns1) do
    for _,y in pairs(ns2) do
      n = n + 1
      if x > y then gt = gt + 1 end
      if x < y then lt = lt + 1 end end end
  return math.abs(lt - gt)/n <= (dull or the.dull) end -- 0.147
```

### Significance Tests (which should be called "Distinguisnable")

Parametric: t-tests (which I don't approve... assumes gauusians). Two normal  distributions $i,j$ are different if their means $\mu_i$
are different by more than some
threshold $t$ (looked up from some 
[table](https://statisticsbyjim.com/hypothesis-testing/t-distribution-table/)):

$$\frac{abs(\mu_i - \mu_j)}{\frac{\sigma_i}{n_i} - \frac{\sigma_j}{n_j}} > t$$

Notes:
- $\sigma$ effect: 
  - The larger the standard deviations $\sigma_i,\sigma_j$, the harder it becomes to tell them apart
  - So we see the $\sigma$ terms in a denominator attenuating the different in the means efffect.
- _sample size_ effect: 
  - The large the same size $n_i,n_j$ the more certain we become 
  - So we use the fraction $\sigma/n$ to attenuate the $\sigma$ effect

Non-parametric significance tests
- Mann-Whitney U-test (sometimes called the Mann Whitney Wilcoxon Test or the Wilcoxon Rank Sum Test)
- Don't compare numbers, compare ranks

```
RX1: 7, 5, 6, 4, 12   
RX2: 3, 6, 4, 2, 1
```
Sort the numbers

```
RX1 :          4, 5, 6, 7, 12
RX2 : 1, 2, 3, 4,    6
```

Rank them smallest to largest 1 to 10 (and tied numbers get the average rank). 
- Prundence check: for N numbers, first and last number gets 1...N (if no ties for first and last place)

```
RX1' :         4.5, 6, 7.5, 9, 10       sum = R1 = 37
RX2' :1, 2, 3, 4.5,    7.5              sum = R2 = 18
```
Now comes the mathemagic:
- $U_1 = n_1n_2 + \frac{n_1(n_1+1)}{2} - R_1$ = 5\*5 - 5\*6/2 - 37 = 3
- $U_2 = n_1n_2 + \frac{n_2(n_2+1)}{2} - R_2$ = 5\*5 - 5\*6/2 - 18 = 22
- $\text{min}(U_1,U_2) = 3$
- no difference if min $U_i$ less than some critical value:

To get critical values:
- by convention, degrees of freedom is $n_i-2$
- after some threshold, just use max values
- here is the critical value at 99 and 95 percent confidence.

```
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
```
