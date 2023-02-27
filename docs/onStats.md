

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
range is 30 to 80
```
   -----      *   ------- 
   
   ^   ^      ^   ^     ^
   |   |      |   |     |
 q10   q30    q50 q70   q90      
   20  30     70  80    100
```
The advantage of percentile charts is that we can show a lot of data in
very little space.

<img align=right width=300 src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Normal_Distribution_PDF.svg/1440px-Normal_Distribution_PDF.svg.png">

Lets look even more looking at 6 sets of results (where results
have 32 values) ranging from 6 to 33,
with medians ranges 9.69 to 30.06. 
```lua
local m=math
local sq,pi,log,cos,r,gaussian = m.sqrt,m.pi,m.log,m.cos,m.random

function gaussian(mu,sd) 
  return mu + sd * sq(-2*log(r())) * cos(2*pi*r()) end

function median(t) --> n; assumes t is sorted 
  local n = #t//2
  return #t%2==0 and (t[n] +t[n+1])/2 or t[n+1] end

function RX(t,s)  --> `t` is all the numbers, sorted
  return {name=s or"",rank=0,t=sort(t or {})} end 

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
  data = sort(data,function(a,b) return median(a.t) < median(b.t) end )
  for k,v in pairs(tiles(data)) do
    print("rx["..v.name.."]",o(v.show)) end end
```

And this produces:
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

We'll store the numbers in an `RX` object (rx=treatments).
```lua
function RX(t,s)  --> `t` is all the numbers, sorted
  return {name=s or"",rank=0,t=sort(t or {})} end 
```
To print multiple `RX` objects:
- first find the most `lo` and `hi` values in all the treatments. 
- then, for each treatment, generate a print string add it as a `.show` field.
  - by normalizing each number 0..1 from `lo` to `hi`
  - the showing it as a number somewhere between `lo` to `hi` (see `at`)
  - show the `A=10`,`B=30` percentile as `-` and
  - show the `D=70`,`E=90` percentile as `-` and
  - show the `C=50th` median as `\*`
  - then, at the end, show the numbers for the `A,B,C,D,E` numbers.

```lua
function median(t) --> n; assumes t is sorted 
  local n = #t//2
  return #t%2==0 and (t[n] +t[n+1])/2 or t[n+1] end

-- in the following the.width = 32
function tiles(rxs) 
  local lo,hi = math.huge, -math.huge
  for _,rx in pairs(rxs) do 
    lo,hi = math.min(lo,rx.t[1]), math.max(hi, rx.t[#rx.t]) end
  for _,rx in pairs(rxs) do
    local t,u = rx.t,{}
    local function of(x,max) return math.max(1, math.min(max, x)) end
    local function at(x)  return t[of(#t*x//1, #t)] end
    local function pos(x) return math.floor(of(the.width*(x-lo)/(hi-lo+1E-32)//1, the.width)) end
    for i=1,the.width do u[1+#u]=" " end
    local a,b,c,d,e= at(.1), at(.3), at(.5), at(.7), at(.9) 
    local A,B,C,D,E= pos(a), pos(b), pos(c), pos(d), pos(e)
    for i=A,B do u[i]="-" end
    for i=D,E do u[i]="-" end
    u[the.width//2] = "|" 
    u[C] = "*"
    rx.show = table.concat(u) 
    rx.show = rx.show.." {"..table.concat(
                               map({a,b,c,d,e},
                                 function(x) 
                                   return string.format(the.Fmt,x) end),", ") .."}"
  end
  return rxs end
```
## Statistics

As to statistical tests,   two kinds of background assumptions

| analysis| assumptions  | effect-size  | significance test|
|---------|--------------|--------------|------------------|
|parametric | data look like bell-shaped curves| e.g. cohen's D | t-test|
|non-parametric | nil | cliff's delta | mann-whitney U test|

<img src="https://www.rasch.org/rmt/gifs/101over.gif" align=right width=400>

Note the different kinds of test:
- effect size: are two distributions different by more than a trivial amount?
- significance test (poorly named, maybe "_distinguishable_" test would be a better name): 
    if I pull numbers from one distribution, how likely
    is it that that number comes from the other distribution?
- recommended: show that this is NOT a small effect and the distributions ARE distinguishable

<br clear=all>

<img align=right width=300 
src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Normal_Distribution_PDF.svg/1440px-Normal_Distribution_PDF.svg.png">

Parametric methods assume that the numbers come from a bell-shaped curve 
(single max value, symmetrical distributions).
- those assumptions can be unrealistic but they do simplify the analysis.
- e.g. cohen-D: two numbers are different if their separation is larger than `std*d`
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

A non
