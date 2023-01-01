<p>&nbsp;
<a name=top></a>
<table><tr>
<td><a href="/README.md#top">Home</a>
<td><a href="http:github.com/timm/tested/issues">issues</a>
</tr></table>
<img  align=center width=600 src="/docs/img/banner.png"></p>
<p> <img src="https://img.shields.io/badge/task-ai-blueviolet"><a
href="https://github.com/timm/tested/actions/workflows/tests.yml"> <img 
 src="https://github.com/timm/tested/actions/workflows/tests.yml/badge.svg"></a> <img 
 src="https://img.shields.io/badge/language-lua-orange"> <img 
 src="https://img.shields.io/badge/purpose-teaching-yellow"> <a 
 href="https://zenodo.org/badge/latestdoi/569981645"> <img 
 src="https://zenodo.org/badge/569981645.svg" alt="DOI"></a><br>
<a href="/LICENSE.md">&copy;2022,2023</a> by <a href="http://menzies.us">Tim Menzies</a></p>


# Automated SE and Maths (just a little)

Here's the great secret about optimization and data mining
- under the hood,  they share a lot of the same structures
- data mining divides up the world
- optimizers comment where to jump between the divisions.

So here we want to talk about the data and operations relevant to
columns and rows of data.

```
            {Clndrs Volume Hpx  Lbs-  Acc+   Model   origin  Mpg+}
            ------- ------ ---  ----  -----  ------  ------  ------
t1= {cells= {4      97     52   2130  24.6   82      2       40}}
t2= {cells= {4      97     54   2254  23.5   72      2       20}}:v
t3= {cells= {4      97     78   2188  15.8   80      2       30}}
t4= {cells= {4      151    90   2950  17.3   82      1       30}}
t5= {cells= {6      200    ?    2875  17     74      1       20}}
t6= {cells= {6      146    97   2815  14.5   77      3       20}}
t7= {cells= {8      267    125  3605  15     79      1       20}}
t9= {cells= {8      307    130  4098  14     72      1       10}}
```

Things to watch for are 
- table, row, column (attribute, feature, goal)
- nominal, ratio, SYM, NUM, SOME
- mid, mean, median, mode
- div, entropy, standard deviation, IQR
- parametric (normal, Gaussian), non-parametric 
  (reservoir sampling)
- multi-goal, many-goal
  - binary, continuous domination (cdom, Ziztler)
- distance: Euclidean, $p$


## Kinds of of Attributes (aka Columns, Variables, Features)

|  | Nominal | Ordinal | Interval | Ratio |
|:--:|:--------:|:----------:|:----------:|:-------:|
|used a lot in this class|y|n|        n |  y    | 
|aka| SYMbolic | | | NUMeric|
|e.g.| eye color, genotype |small,medium |temperature  | weight,length|
| compare ${\neq},=$, | &#9989; |&#9989; |&#9989; |&#9989; |
| order, sort $\lt, \gt$ | &#10060; | &#9989; | &#9989; | &#9989; |
|add or subtract | &#10060; | &#10060; |&#9989; | &#9989;|
|multiply or divide | &#10060; | &#10060; |&#10060; | &#9989;|
|central tendency<br>(mid) | mode <br>(most common symbol)| mode | (1) mean  $(\sum_i x_i)/n$<br>(2) median (50th percentile) | mean,median|
|diversity<br>(div)  | entropy<br> (effort to recreate signal)<br> $e=-\sum_i(p_i\times log_2(p_i))$    | entropy | (1) standard deviation<br> (distances from the  mean) <br> $\sigma = \sqrt{\frac{\sum_i(x_i-\mu)^2}{n-1}}$<br>(2) IQR: inter-quartile range<br>(75th-25th) percentile | standard deviation|

### Class SYM
Here are some classes to compute the important parts of the above:

```lua
SYM = obj"SYM"
function SYM.new(i) --> SYM; constructor
  i.n   = 0
  i.has = {}
  i.most, i.mode = 0,nil end

function SYM.add(i,x) --> nil;  update counts of things seen so far
  if x ~= "?" then 
   i.n = i.n + 1 
   i.has[x] = 1 + (i.has[x] or 0)
   if i.has[x] > i.most then
     i.most,i.mode = i.has[x], x end end end 

function SYM.mid(i,x) return i.mode end --> n; return the mode

function SYM.div(i,x) --> n; return the entropy, calculated via Shannon entropy
  local function fun(p) return p*math.log(p,2) end
  local e=0; for _,n in pairs(i.has) do e = e + fun(n/i.n) end 
  return -e end
```

<img src="https://miro.medium.com/max/720/1*mEIWwyolHOdY3TmBus7HtQ.webp" align=right width=400>

By the way, to understand SYM.div (entropy), think of it as
- the effort required by binary chop to find clumps of a signal hiding in a stream of noise

e.g. in a vector of size 4,
  - nazis have a "1" near one end
  - and England are all the other bits
- This means that 1/4% of the time we need to do binary chops to find nazies (i.e. $p_{\mathit{nazis}}=.25$)
- and 75% if the time we need to binary chops to find Englad (i.e. $p_{\mathit{england}}$=.75)
- Each chop will cost us $log2(p_i)$ so the total effort is $e=-\sum_i(p_i\times log_2(p_i))$ 
  - By convention, we  add a minus sign at the front (else all entropies will be negative).

(Actually, formally entropy has other definition: 
- The entropy of a discrete random variable is a lower bound on the expected number of bits required to transfer the result of the random variable.
- Also, entropy of continuous distributions is defined, but we do not use that in this subject.)

### Class NUM

```lua
NUM = obj"NUM"
function NUM.new(i) --> NUM;  constructor; 
  i.n, i.mu, i.m2 = 0, 0, 0
  i.lo, i.hi = math.huge, -math.huge end

function NUM.add(i,n) --> NUM; add `n`, update lo,hi and stuff needed for standard deviation
  if n ~= "?" then
    i.n  = i.n + 1
    local d = n - i.mu
    i.mu = i.mu + d/i.n
    i.m2 = i.m2 + d*(n - i.mu)
    i.lo = math.min(n, i.lo)
    i.hi = math.max(n, i.hi) end end

function NUM.mid(i,x) return i.mu end --> n; return mean

function NUM.div(i,x)  --> n; return standard deviation using Welford's algorithm http://t.ly/nn_W
    return (i.m2 <0 or i.n < 2) and 0 or (i.m2/(i.n-1))^0.5  end
```

### So-called "Normal" Curves
If we are talking standard deviation, then we had better talk about normal curves.

The French mathematician Abraham de Moivre [^deMo1718]
  notes that probabilities associated with discretely 
  generated random variables (such as are obtained by flipping a coin or rolling a die) can 
  be approximated by the area under the graph of an exponential function.

This function was generalized by  Laplace[^Lap1812] 
  into the first central limit theorem, which proved that probabilities for almost 
  all independent and identically distributed random variables converge rapidly 
  (with sample size) to the area under an exponential function—that is, to a normal 
  distribution.

This function was extended, extensively by Gauss. Now its a curve with an area under the curve of one.
  As standard deviation shrinks, the curve spikes upwards.

<p align=center><img align=center src="/etc/img/norm.png" align=right width=600></p>


To sample from a normal curve
from a Gaussian with mean `mu` and diversity `sd`

      mu + sd * sqrt(-2*log(random)) * cos(2*pi*random)


_Beware:_
Not all things are normal Gaussians. 
<img src="/etc/img/weibull.png" align=right width=300 > If you want to get fancy, you can use Weibull functions
to make a variety of shapes (just by adjusting $\lambda,k$):


<p align=center><img src="/etc/img/weibulleq.png" wdith=300 ></p>


Or you could forget all about parametric assumptions.
Many things get improved by going beyond the Gaussian guess [^dou95]:
Not everything is best represented by a smooth curve with one peek that is symmetrical around that peek:


<img width=400 src="https://github.com/txt/fss17/raw/master/img/notnorm8.png">


To go fully non-parametric, use reservoir sampling (below). Then to sample, grab three numbers $a,b,c$ and use $x=a+f\times(b-c)$ for some small $f$ (say $f=0.1$).


All that said, Gaussians take up far less space and are very easy to update. So all engineers should know their gaussians.

And I find Gaussians better for small samples (under 20) than the following Reservoir Sampler


## SOME class (Reservoir Sampling)

To sample an infinite stream, only keep some of the data (and keep it in the "reservoir"):
- and as time goes on, keep less and less.
- and if the reservoir fills up, just let new things replace on things (at random)
  - and do not fret about losing important information.
  - if something is common, deleting it once will not matter since either it exists elsewhere in the reservoir, or it will soon reappear on inout.

E.g. if run on 10,000 numbers, with a reservoir of size 32, this code would keep a sample across the whose space of numbers. 

```
{  18  687 
 1545 
 2022  2324 2693 2758 
 3247  3533 
 4067 4168 4469 4570 
 5863 5907 5957 
 6147 6440 6727 
 7228 7517 7574 7598 7765 
 8311 8379 8538 
 9052 9189 9323}
```

```lua
SOME = obj"SOME"
function SOME.new(i,max)
  i.ok, i.max, i.n = true, max or the.Some or 256, 0  
  i._has = {} end -- marked private with "_" so we do not print large lists

function SOME.add(i,x) --> nil. If full, add at odds i.max/i.n (replacing old items at random)
  if x ~= "?" then
    local pos
    i.n = i.n + 1
    if     #i._has < i.max   --- note that "#i._has" means "length of the list i._has"
    then   pos= 1+#i._has    -- easy case. if cache not full, then add to end
    elseif rand() < i.max/i.n then pos= lib.rint(#i._has) end -- else, replace any at random
    if pos then
       i._has[pos]=x
       i.ok=false end end end -- "ok=false" means we may need to resort
```
There is more SOME below but before that I note that the above can handle numbers or symbolics
inside the SOME. But what happens next is all about SOMEs of nums.
```lua
function SOME.has(i) --> t; return kept contents, sorted
  if not i.ok then i._has = sort(i._has) end -- only resort if needed
  i.ok = true
  return i._has end

function SOME.mid(x) --> n; return the number in middle of sort
  return per(i:has(),.5) end

function SOME.div(x) --> n; return the standard deviation as (.9 - .1)/2.58
  return (per(i:has(), .9) - per(i:has(), .1))/2.56 end

function  per(t,p) --> num; return the `p`th(=.5) item of sorted list `t`
  p = math.floor(((p or .5)*#t)+.5) --
  return t[math.max(1,math.min(#t,p))] end
```
<img src="https://financetrain.sgp1.cdn.digitaloceanspaces.com/ci1.gif" align=right width=400>

To understand `SOME.div`, recall that in a normal curve:

- 99% of values are in 2.58 standard deviations of mean (-2.58s &lt;= X &lt;= 2.58s)
- 95% of values are in  1.96 standard deviations of mean (-1.96s &lt;= X &lt;= 1.96s)
- 90% of values are in 1.28 standard deviations of mean (-1.28s &lt;= X &lt;= 1.28s)
  - so 2\*1.28\*sd = 90th - 10th percentile
  - i.e. sd = (90th - 10th)/(2*1.28)

## Domination

Is 2 better than 3? Depends if we want to _minimimize_ of _maximize_.

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQt65J-qM4GQvPeZdvf28zLytx-x1tCXYpkfqTjTjg6jGYx8MxYVMonn8qixREdOr4duVI&usqp=CAU" align=right width=400>

Are (2 cars plus 4 clowns) better than (1 car and 5) clowns? Depends on how much we want
to minimize the number of cars and maximize the number of clowns.

The standard _boolean domination_ (bdom) predicate says one thing dominates another
if
- RULE1: it never worse on any goals, and  
- RULE2: it is better for at least one goal. 

So if we want to minimize
cars and maximize clowns then compared to 2cars,4clowns
- 1car + 5clowns is better  (since better on all)
- 1car + 3clowns is not better  (since worse on one)

The great thing about boolean domination is that a single
point can wipe out thousands, millions of rivals. E.g. suppose
we are guessing what is the equation of a pendulum. A good
equation has to:
- cover the data (be accurate)
- without being too complex

<img src="/etc/img/pendulm.png" width=600>

The few points on the thick black line dominate the rest. Which is cool
since, to find a better solution, we only need to search around those few.

<img src="/etc/img/2dplot.png" width=600>

But when the number of goals 
grows over three[^wag07][^sayyad], 
boolean domination can fail to distinguish different things.
Why?
- Well, it is RULE1: "never worse on any goal" condition. 
- The more goals there are, the more ways you can be a tiny bit worse on at least one goal.
- So nothing seems to be better than anything else.  

[^wag07]: T. Wagner, N. Beume, and B. Naujoks, 
  ["Pareto-, Aggregation-, and Indicator-Based Methods in Many-Objective Optimization,"](https://link.springer.com/content/pdf/10.1007/978-3-540-70928-2.pdf?pdf=button)
  in Proc. EMO, LNCS Volume 4403/2007, 2007, pp. 742-756.

[^sayyad]:  Sayyad, Abdel Salam, Tim Menzies, and Hany Ammar. 
  ["On the value of user preferences in search-based software engineering: A case study in software product lines."](https://fada.birzeit.edu/bitstream/20.500.11889/4528/1/dcb6eddbdac1c26b605ce3dff62e27167848.pdf)
  2013 35Th international conference on software engineering (ICSE). IEEE, 2013.

So we often distinguish
- Multi-goal reasoning (up to 3 goals) where boolean domination works ok
- Many-goal reasoning (4 or more) [^many], which needs something else called continuous domination (cdom, see below)
  - Not that continuous domination also works for multi-goal.

[^many]: Aurora Ramírez, José Raúl Romero, Sebastián Ventura,
  [A survey of many-objective optimisation in search-based software engineering](https://www.researchgate.net/publication/329736475_A_survey_of_many-objective_optimisation_in_search-based_software_engineering)
  Journal of Systems and Software, Volume 149, 2019, Pages 382-395,
  ISSN 0164-1212, https://doi.org/10.1016/j.jss.2018.12.015.

Before we get to cdom, we need a little trick: change  `NUM`  and `SYM` so its accepts a name string
- and if the name starts in uppercase, we have a number
- and if the name ends with "-" or "+" then its a goal we want to minimize or maximize
  - and for such items, we will set "w" to 1.

We will need a factory that can take a list of names name produce a list of NUMs or SYMs. E.g.

```
list of names      call                 weight    goal?
--------------     ----------------     ------    -----

{ "Clndrs",        NUM(1, "Clndrs")     1         n
  "Volume",        NUM(2, "Volume")     1         n
  "HpX",           NUM(3, "HpX")        1         n
  "Lbs-",          NUM(4, "Lbs-")         -1         y
  "Acc+",          NUM(5, "Acc+")       1            y
  "Model",         NUM(6, "Model")      1         n
  "origin",        SYM(7, "origin")               n
  "Mpg+"}          NUM(8, "Mgp+")       1            y
```
The important thing in the above is now we have weights that tell us if we are maximizing or minimizing.

Here is the factory. Goals are stored in `i.y` (and 
the other columns are found in `i.x`).
```lua
COLS=obj"COLS"
function COLS.new(i,t,     col,cols)
  i.names, i.all, i.x, i.y = t, {}, {}, {}
  for n,s in pairs(t) do  -- like PYTHONS's for n,s in enumerate(t) do..
    col = s:find"^[A-Z]+" and NUM(n,s) or SYM(n,s)
    push(i.all, col)
    if not s:find"X$" then
      push(s:find"[!+-]$" and i.y or i.x, col) end end end
```
And we will adjust NUM and SYM to accept more information (like the column name):

```lua
function SYM.new(i,n,s) --> SYM; constructor
  i.at, i.txt = n or 0, s or "" -- <== NEW
  i.n   = 0
  i.has = {}
  i.most, i.mode = 0,nil end

function NUM.new(i,n,s) --> NUM;  constructor; 
  i.at, i.txt = n or 0, s or ""           -- <== NEW
  i.w         = i.s:find"-$" and -1 or 1  -- <== NEW
  i.n, i.mu, i.m2 = 0, 0, 0
  i.lo, i.hi = math.huge, -math.huge end

function NUM.norm(i,n)
  return n == "?" and n  or (n - i.lo)/(i.hi - i.lo + 1E-32) end
```
Now we can look at the goal columns to sort examples.
For example, here we sort
first for
- the  lighter  light cars that run faster with more miles per gallon

```
            {Clndrs Volume Hpx  Lbs-  Acc+   Model   origin  Mpg+}
            ------- ------ ---  ----  -----  ------  ------  ------
t1= {cells= {4      97     52   2130  24.6   82      2       40}}
t2= {cells= {4      97     54   2254  23.5   72      2       20}}
t3= {cells= {4      97     78   2188  15.8   80      2       30}}
t4= {cells= {4      151    90   2950  17.3   82      1       30}}
t5= {cells= {6      200    ?    2875  17     74      1       20}}
t6= {cells= {6      146    97   2815  14.5   77      3       20}}
t7= {cells= {8      267    125  3605  15     79      1       20}}
t9= {cells= {8      307    130  4098  14     72      1       10}}
```

This is Zitzler's multi-objective cdom predicate [^zizt]. This
runs a little what-if analysis that asks "if we go here to there,
or there to here", what losses most?
- e.g. in one dimension, 
  - suppose we are moving between 10 pounds and 2 pounds
  - and we want to maximize (`i.w=1`)
  - here to there is `i.w\*(10-2) = 8`
  - there to here is `i.e\*(2-10) = -8`
  - leaving here loses worst
  - so here is better than there
- and the point of Zitzler is that it works for comparing on $N \ge 1$ dimensions.

```lua
-- cdom, continuous domination:
function DATA:sort(t1,t2,  cols)
  local s1,s2,cols = 0,0, cols or self.cols.y
  for _,col in pairs(cols) do
    local x = col:norm( t1.cells[col.at] ) -- we normalize first
    local y = col:norm( t2.cells[col.at] )
    s1      = s1 - math.exp(col.w * (x-y)/#cols) -- note use of col.x
    s2      = s2 - math.exp(col.w * (y-x)/#cols) end
  return s1/#ys < s2/#cols end
```

### Aggregation Functions

An alternate scheme to Zitzler is an _aggregation functions_
that  adds a little weights to each dimension and
add all the goals up; e.g.
- mph times four plus  acceleration times two
- Everyone who has every studied this reports that such objective functions
  get stuck in local maxima[^chen22]  and that other schemes (e.g. Zitzler) are better.
  - worse, you have to start re-running your analysis, 
    jiggling the magic weights in the objective function.
 
[^zizt]: Zitzler, E., Künzli, S. (2004). 
  [Indicator-Based Selection in Multiobjective Search](https://www.simonkuenzli.ch/docs/ZK04.pdf),
  In: , et al. Parallel Problem Solving from Nature - 
  PPSN VIII. PPSN 2004. Lecture Notes in Computer Science, 
  vol 3242. Springer, Berlin, Heidelberg. https://doi.org/10.1007/978-3-540-30217-9_84

[^chen22]: Tao Chen and Miqing Li. 2022. 
  [The Weights can be Harmful: Pareto Search versus Weighted Search in Multi-Objective Search-Based Software i Engineering.](https://arxiv.org/pdf/2202.03728.pdf
  ACM Trans. Softw. Eng. Methodol. Just Accepted (April 2022). https://doi.org/10.1145/3514233

## Distance Functions
```
            {Clndrs Volume Hpx  Lbs-  Acc+   Model   origin  Mpg+}
            ------- ------ ---  ----  -----  ------  ------  ------
t1= {cells= {4      97     52   2130  24.6   82      2       40}}
t2= {cells= {4      97     54   2254  23.5   72      2       20}}
t3= {cells= {4      97     78   2188  15.8   80      2       30}}
t4= {cells= {4      151    90   2950  17.3   82      1       30}}
t5= {cells= {6      200    ?    2875  17     74      1       20}}
t6= {cells= {6      146    97   2815  14.5   77      3       20}}
t7= {cells= {8      267    125  3605  15     79      1       20}}
t9= {cells= {8      307    130  4098  14     72      1       10}}
```

With the above, we nearly have everything we need to distance calculations.
Here's Aha's distance measure that work for combinations of numeric and symbolic
attributes. 

$$\mathit{Distance}(a, b) = \left( \sum_i^n \left( f(a_i,b_i)^p \right) \right)^{1/p} $$

where the instances are described by $n$ attributes. 
- We define 
$f(a_i, b_i) = (a_i - b_i)$ for
numeric-valued attributes 
- We define $f(a_i, b_i) = (a_i \neq b_i)$ 
for boolean and symbolic-valued attributes. 
- Missing attribute values are assumed to be maximally 
different from the value present.
- If they are both missing, then $f(a_i, b_i)=1$. 
- Numerics are normalized 0..1 prior to computing distance  (so symbolics
  are scored on the space width as numerics)

Formally, the above is the Minkowsk distance, which is really a family
of distance functions.
As the what value of $p$ to use:
- $p=1$ is the  Manhattan distance  (taxicab distance);
- $p=2$ is the standard Euclidean distance.
- officially [^agg01]  in High dimensions (20 for synthetic data, 168 for the Musk Dataset,  
      32 for the breast cancer, 34 for Ionosphere)
  - fractional norm distance metrics ($p\lt 1$) work better than large $p$. 

[^agg01]: Aggarwal, Charu & Hinneburg, Alexander & Keim, Daniel. (2002). 
  [On the Surprising Behavior of Distance Metric in High-Dimensional Space](https://www.researchgate.net/publication/30013021_On_the_Surprising_Behavior_of_Distance_Metric_in_High-Dimensional_Space)
  First publ. in: Database theory, ICDT 200, 8th International Conference, 
  London, UK, January 4 - 6, 2001 / Jan Van den Bussche ... (eds.). 
  Berlin: Springer, 2001, pp. 420-434

Note that in the following, we can pass in a `cols` list that includes
all the `x` cols or `y` cols (so we can do distance between just
the goals or just the other columns):

```lua
the={p=2}

function DATA.dist(i,row1,row2,cols,       d,n)
  d,n = 0,1E-32
  for _,col in pairs(cols or i.cols.x) do
    d = d + col:dist(row1.cells[col.at], row2.cells[col.at])^the.p
    n = n + 1 end
  return d^(1/the.p)/n^(1/the.p) end

function SYM.dist(i,s1,s2)
  return s1=="?" and s2=="?" and 1 or (s1==s2) and 0 or 1 end 

function NUM.norm(i,n)
  return n == "?" and n  or (n - i.lo)/(i.hi - i.lo + 1E-32) end

function NUM.dist(i,n1,n2)
  if n1=="?" and n2=="?" then return 1 end
  n1,n2 = i:norm(n1), i:norm(n2)
  if n1=="?" then n1 = n2<.5 and 1 or 0 end
  if n2=="?" then n2 = n1<.5 and 1 or 0 end
  return math.abs(n1 - n2) end 
```
