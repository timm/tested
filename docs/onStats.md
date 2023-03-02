

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

As a team, implement the [stats.lua](/src/stats.lua) examples shown in
[stats.out](/etc/out/stats.out)


## Today's lecture: does 42==44?

Clearly, "no", if they are point values.

But "yes", if they these are the median of a two different distributions with large variances.
- In which case we say that they are  _statistically insignificantly distinguishable_ by more more than a _small effect_
- For example, in the following, is "control" equal to "education"?

![image](https://user-images.githubusercontent.com/29195/221987767-8508aed3-c6bd-4350-a1cb-427c8c0259d7.png)


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
range is 40 to 80. We can visualize this using a horizontal percentile plot:


```
                        0   20   40   60    80   100
                        |----|----|----|----|----|
                        
percentile plot ==>          ------       * ------ 
                           
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

Note one small detail in the above:
- One RX (e.g. Rx6)  may run from 8 to 12
- But before we can draw it, we need to know everyone's `lo` and `hi` 
  - So we can draw them on the same playing field
  - In this example, around 8 to 42

Now before we can report treatments, we first we  need a place to put the treatments. Note that:
- when we store the numbers, we sort them;
- each treatment has a `show` string, initialized to "" (and, later, this will hold the lines above)

```lua
function RX(t,s)  
  return {name=s or"",rank=0,has=sort(t or {}), show=""} end 
```
We might need to some way to find (e.g.) the median of those results `median(rx.t)`.
```lua
function mid(t,     n)    -- assime t is sorted
  t= t.has and t.has or t -- so we can find the mid of lists or RXs
  local n = #t//2
  return #t%2==0 and (t[n] +t[n+1])/2 or t[n+1] end
```
We can also find the standard deviation (`div`) of a treatment via the distance
from the 10th to the 90th percentile.
```lua
function div(t)
  t= t.has and t.has or t
  return (t[ #t*9//10 ] - t[ #t*1//10 ])/2.56 end
```
Why 2.56? well:
- Anyone who has done a stats course knows that ±2, 3 standard deviations covers 66,95%, 
    <img src="/etc/img/128.png" align=right width=300>
    of the mass.  
- A lesser known threshold is that ±2.56 standard deviations covers 90% of the mass
- So one standard deviation is (90-10)th divide by 2.56 times σ. 


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
To print multiple `RX` objects:
- first find the most `lo` and `hi` values in all the treatments [1]. 
- then, for each treatment, generate a print string add it as a `.show` field.
  - fill the `show` string with blanks.   [2]
  - normalizing each number 0..1 from `lo` to `hi`  [3]
  - the showing it as a number somewhere between `lo` to `hi` (see the `at` function, inside `tiles`)
  - Aside: make sure all our positions are  integer [4]

(If you do not understand the following code, just start from [5] and read downwards. Then
look at the above ascii plot to work out what the `of,at,pos` functions do.)
```lua
-- in the following the.width = 32
-- THis code assumes `rxs` is pre-sorted on `mid`.
function tiles(rxs) --> ss; makes on string per treatment showing rank, distribution, and values
  local huge,min,max,floor = math.huge,math.min,math.max,math.floor
  local lo,hi = huge, -huge
  for _,rx in pairs(rxs) do 
    lo,hi = min(lo,rx.has[1]), max(hi, rx.has[#rx.has]) end  ----- [1]
  for _,rx in pairs(rxs) do
    local t,u = rx.has,{}
    local function of(x,most) return max(1, min(most, x)) end
    local function at(x)  return t[of(#t*x//1, #t)] end     ------ [3,4]
    local function pos(x) 
       return floor(of(the.width*(x-lo)/(hi-lo+1E-32)//1, the.width)) end
    ----- [5]
    for i=1,the.width do u[1+#u]=" " end                   ------- [2]
    local a,b,c,d,e= at(.1), at(.3), at(.5), at(.7), at(.9) 
    local A,B,C,D,E= pos(a), pos(b), pos(c), pos(d), pos(e)
    for i=A,B do u[i]="-" end
    for i=D,E do u[i]="-" end
    u[the.width//2] = "|" 
    u[C] = "*"
    rx.show = table.concat(u)  -- equivalent to python ', '.join(lst)
    rx.show = rx.show .." {"..string.format(the.Fmt,a)
    for _,x in pairs{b,c,d,e} do 
      rx.show=rx.show.. ", "..string.format(the.Fmt,x) end
    rx.show = rx.show .."}"
  end
  return rxs end
```
To demo this code, we need a quick way to generate some sample data.
```lua
local m=math
local sq,pi,log,cos,r,gaussian = m.sqrt,m.pi,m.log,m.cos,m.random
function gaussian(mu,sd) 
  return mu + sd * sq(-2*log(r())) * cos(2*pi*r()) end
```
Now we can build treatments of 1000 numbers taken from different distributions.
Note, in the third last line, the all important sort f the treatments:
```lua
eg={}
eg.tiles =function(        rxs,a,b,c,d,e,f,g,h,j,k)
  rxs,a,b,c,d,e,f,g,h,j,k={},{},{},{},{},{},{},{},{},{},{}
  for i=1,1000 do a[1+#a] = gaussian(10,1) end
  for i=1,1000 do b[1+#b] = gaussian(10.1,1) end
  for i=1,1000 do c[1+#c] = gaussian(20,1) end
  for i=1,1000 do d[1+#d] = gaussian(30,1) end
  for i=1,1000 do e[1+#e] = gaussian(30.1,1) end
  for i=1,1000 do f[1+#f] = gaussian(10,1) end
  for i=1,1000 do g[1+#g] = gaussian(10,1) end
  for i=1,1000 do h[1+#h] = gaussian(40,1) end
  for i=1,1000 do j[1+#j] = gaussian(40,3) end
  for i=1,1000 do k[1+#k] = gaussian(10,1) end
  for k,v in pairs{a,b,c,d,e,f,g,h,j,k} do rxs[k] =  RX(v,"rx"..k) end
  table.sort(rxs,function(a,b) return mid(a) < mid(b) end)
  for _,rx in pairs(tiles(rxs)) do
    print("",rx.name,rx.show) end end
```
This almost generated the above display, except for the LHS ranking numbers.
And for that, we'll need a little more theory (about statistics)
```
	rx6	 -*-               |                     {  8.79,   9.46,   9.97,  10.52,  11.29}
	rx1	 -*-               |                     {  8.67,   9.43,  10.00,  10.54,  11.23}
	rx10	 -*-               |                     {  8.75,   9.52,  10.03,  10.52,  11.33}
	rx7	 -*-               |                     {  8.81,   9.51,  10.03,  10.51,  11.22}
	rx2	 -*-               |                     {  8.84,   9.58,  10.04,  10.59,  11.40}
	rx3	          -*--     |                     { 18.69,  19.45,  19.99,  20.50,  21.36}
	rx4	                   |-*-                  { 28.71,  29.41,  29.97,  30.48,  31.22}
	rx5	                   |-*-                  { 28.75,  29.50,  30.00,  30.58,  31.29}
	rx9	                   |       ---* ---      { 36.13,  38.43,  39.90,  41.55,  43.83}
	rx8	                   |         -*--        { 38.71,  39.51,  39.98,  40.46,  41.28}
```
## Statistics
Remember our stats' result above?
- _statistically insignificantly distinguishable_ by more more than a _small effect_

This result tells us that there are two kinds of statistical tests:

| analysis| assumptions  | effect-size:<br>different by more than a trivial amount? | significance test:<br>how much does one overlap the other?|
|---------:|:-------------:|:------------:|:----------------:|
|parametric | data look like bell-shaped curves| e.g. cohen-D | t-test|
|non-parametric | nil | cliff's delta | mann-whitney U test,<br>bootstrap(see below)|

Parametric methods assume that the numbers come from a bell-shaped curve 
(single max value, symmetrical distributions).
- those assumptions can be unrealistic but they do simplify the analysis (see below)

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

Recall thatarametric methods assume that the numbers come from a bell-shaped curve 
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
    (90th - 10th) percentile of a sorted number, divided by 2.56.

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

Cliff’s d can be interpreted as negligible (&lt;0.147), small (&lt;0.33), medium (&lt;0.474) and large (otheriwse) effects[^romo].
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
are different if their `delta` is large that some
threshold $t$ (looked up from some 
[table](https://statisticsbyjim.com/hypothesis-testing/t-distribution-table/)):


```lua
local function delta(i, other,      y,z,e)
  e, y, z= 1E-32, i, other
  return math.abs(y.mu - z.mu) / ((e + y.sd^2/y.n + z.sd^2/z.n)^.5) end
```
$$\Delta= \frac{abs(\mu_i - \mu_j)}{\frac{\sigma_i}{n_i} - \frac{\sigma_j}{n_j}} $$

Notes:
- $\sigma$ effect: 
  - The larger the standard deviations $\sigma_i,\sigma_j$, the harder it becomes to tell them apart
  - So we see the $\sigma$ terms in a denominator attenuating the different in the means efffect.
- _sample size_ effect: 
  - The large the same size $n_i,n_j$ the more certain we become 
  - So we use the fraction $\sigma/n$ to attenuate the $\sigma$ effect

Non-parametric significance test that two distributions $y_0,z_0$ are different.
- Here is the _bootstrap_ procedure recommended by
  p220 to 223 of the Efron text ‘Introduction to the Boostrap’ https://bit.ly/3iSJz8B
- $B$ times (say $B=512$)
  - build a sample of $y_0$ and a sample of $z_0$  (sampling with replacement, may be repeats)
  - Count "plus one "  if  their `delta` is different to the `delta` from all the data
- Use that count to report if the distributions are difference"

![image](https://user-images.githubusercontent.com/29195/221997957-a8ebc7e8-ed5c-4ff6-8b59-8c641e4166f6.png)


Here's sampling with replacement (don't use this one... unless your `the.seed` updates
the system's random number generator):
```lua
local function samples(t,n,    u)
  u= {}; for i=1,n or #t do u[i]=t[math.random(#t)] end; return u end
```
Here's something that can summarize a set of numbers:
```lua
local add,NUM
function NUM(  t,    i) 
  i= {n=0,mu=0,m2=0,sd=0}
  for _,x in pairs(t or {}) do add(i,x) end 
  return i end

function add(i,x)  -- how to update a "NUM"
  i.n  = i.n+1
  d    = x-i.mu
  i.mu = i.mu + d/i.n
  i.m2 = i.m2 + d*(x-i.mu)
  i.sd = i.n<2 and 0 or (i.m2/(i.n - 1))^.5 end
```
And finally, here's the bootstrap:
```lua
-- the.bootstrap=512
-- the.conf = 0.05 (95% confidence)
local function bootstrap(y0,z0)
  local n, x,y,z,xmu,ymu,zmu,yhat,zhat,tobs
  x, y, z, yhat, zhat = NUM(), NUM(), NUM(), {}, {}
  -- x will hold all of y0,z0
  -- y contains just y0
  -- z contains just z0
  for _,y1 in pairs(y0) do add(x,y1); add(y,y1) end
  for _,z1 in pairs(z0) do add(x,z1); add(z,z1) end
  xmu, ymu, zmu = x.mu, y.mu, z.mu
  -- yhat and zhat are y,z fiddled to have the same mean (recommended by Efrom)
  for _,y1 in pairs(y0) do yhat[1+#yhat] = y1 - ymu + xmu end
  for _,z1 in pairs(z0) do zhat[1+#zhat] = z1 - zmu + xmu end
  -- tobs is some delta seen in the whole space
  tobs = delta(y,z)
  n = 0
  for _= 1,the.bootstrap do
    -- here we look at some delta from just part of the space
    -- it the part delta is bigger than the whole, then increment n
    if delta(NUM(samples(yhat)), NUM(samples(zhat))) > tobs then n = n + 1 end end
  -- if we have seen enough n, then we are the same
  return n / the.bootstrap >= the.conf end
```
FYI: On Tuesdays and Thursdays I lie awake at night convinced this should be "_&lt; the.conf_"
- And the above "> obs" should be     
  _abs(delta - tobs) &gt; someCriticalValue_. 
- But then I try it the next morning and the above works. Which tells me that Dr. Efron
  knows more about stats that I do.

### Ranking Multiple Treatments

So far we have only compared two treatments but, in reality, we often have to compare many more.
For example, here's Chen et al. [^chen] comparing dozens of different learners. Those learners fall into
two groups:
- supervised learners that have all the labels
- unsupervised learners that have none.
- Here, higher $t$ axis values are _better_
  - yes, supervised beats unsupervised
    - but overall, you got to say, the unsupervised methods are doing pretty well.
- The horizontal box plots here are similar to the above horizonal percentile plots
  - these box lots show 100,75,50,25,0.
  - mine plots show 10,30,50,70.90
    - I prefer not show show outliers since they are, well, outliers.

![image](https://user-images.githubusercontent.com/29195/222006150-536b19aa-735e-4fe9-8bef-dc0b1ec9f7c3.png)

Note some standard patterns in the above:
- many treatments get the same rank
  - so we may be excited by some idea, take weeks to code it up, then the data just laughs at us.
- the total number of ranks is rather small
  - so we run through the world with many dubious distinctions.

[^chen]: Xiang Chen, Yingquan Zhao, Qiuping Wang, Zhidan Yuan,
  MULTI: Multi-objective effort-aware just-in-time software defect prediction,
  Information and Software Technology,
  Volume 93,
  2018,
  Pages 1-13,
 ISSN 0950-5849,
  https://doi.org/10.1016/j.infsof.2017.08.004.

This plot was generated by a Scott-Knot procedure:
- Scott-Knott sorts  treatments by their
median scores
- Scott-Knott method recursively splits the
sorted treatments $c$  into two sub-lists $c_1,c_2$ at the point that _maximizes_ the
expected value of differences in the median  performance $\overline{c_i}$
before and after division :

$$ E(\Delta) = \frac{\textrm{len}(c_1) * |\overline{c_1}-\overline{c}| + \textrm{len}(c_2) * |\overline{c_2}-\overline{c}|}{\textrm{len}(c)}$$


- Effect size and signifnce tests are then then applied to check if two sub-lists are really different.
- If not, recursion stops.
- One reason to use choose Scott-Knott because
  - it can be made fully non-parametric (by selecting non-paramettic effect size and significance tests)
  -  it reduces the number of potential errors in the statistical analysis since it only requires at most $O(log2(N))$ statistical 
      tests (rather than some $O(N^2)$ comparions of all pairs of treatments).
  - Other researchers also advocate for the use of this test:
    - Since it   overcomes a common limitation of alternative multiple-comparisons statistical tests (e.g., the Friedman test)
        here   treatments are assigned to multiple groups (making it hard for an experimenter to   distinguish the real groups  
        where the means should belong.

The code for scott-knot is a top-down clustering algorithm,
```lua
function scottKnot(rxs,      all,cohen)
  local function merges(i,j,    out)
    out = RX({},rxs[i].name)
    for k = i, j do out = merge(out, rxs[j]) end 
    return out 
  end --------
  local function same(lo,cut,hi)
    l= merges(lo,cut)
    r= merges(cut+1,hi)
    return cliffsDelta(l.has, r.has) and bootstrap(l.has, r.has) 
  end --------------------------
  local function recurse(lo,hi,rank)
    local cut,best,l,l1,r,r1,now,b4
    b4 = merges(lo,hi)
    best = 0
    for j = lo,hi do
      if j < hi  then
        l   = merges(lo,  j)  -- [2]
        r   = merges(j+1, hi) -- [3]
        now = (l.n*(mid(l) - mid(b4))^2 + r.n*(mid(r) - mid(b4))^2) / (l.n + r.n) --[4]
        if now > best then
          if math.abs(mid(l) - mid(r)) >= cohen then -- [10]
            cut, best = j, now
    end end end end
    if cut and not same(lo,cut,hi) then
      rank = recurse(lo,    cut, rank) + 1        --- [6,8]
      rank = recurse(cut+1, hi,  rank)            --- [8]
    else
      for i = lo,hi do rxs[i].rank = rank end end  -- [5]
    return rank 
  end --------- 
  table.sort(rxs, function(x,y) return mid(x) < mid(y) end)  --- [1]
  cohen = div(merges(1,#rxs)) * the.cohen                    -- [9]
  recurse(1, #rxs, 1)                                        -- [7]
  return rxs end
```
In the above:
- we sort $n$ treatments on their median [1], then we call some nested functions
- `merges` combines set of treatment (using the `merge` function,defined above)
- `same` checks if two merged treatments are the same (using `cliffsDelta` and `bootstrap`)
- `recurse` finds some `cut` point that best splits the treatments
  - initially is searches from _1 to length(rxs)_
    - and as we find cuts, the recursive calls to `recurse` explores smaller and smaller ranges. [6,8]
  - `l` (for left) [2] is everything from `lo` to `cut` 
  - `r` (for right) [3] is everything from `cut+1` to `hi`
  - `now` computes the above equation [4]
  - if no cut is found that all the treatments from `lo` to `hi` get the same rank [5]
    - to say that another way, if you can't split the treatments, then they are the same
  - else, the right hand side treatments get a rank at least one greater than the left [6]

Note one numerical methods thing:
- sometimes, SK will endorse very silly, very small cuts
- to avoid that, we add a prudence check
  - cuts have to separate treatments by at least cohen's D (35% of standard deviation) [9,10]

