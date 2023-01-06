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


# Clustering
Goal: repeat until no crap: cut the crap

<img src="https://user-images.githubusercontent.com/29195/131719589-f259227c-562c-4249-956b-4ba9c62f6bfb.png" align=right width=400>

"Every <strike>block of stone</strike> has a <strike>statue</strike> signal inside it and it is the taks of the scultpro to discover it. "       
-- <strike>Michelangelo</strike> some bald guy

“Perfection is achieved when there is nothing left to take away.”        
 -- Antoine de Saint-Exupéry 


"Less, but better."      
-- Dieter Rams

"In most applications examples are not spread uniformly throughout the instance space, but are concentrated on or near
a lower-dimensional manifold. Learners can implicitly take
advantage of this lower effective dimension."      
-- Pedro Domingoes

<br clear=all>
<img src="https://user-images.githubusercontent.com/29195/131719792-eca77ca2-b7ee-436a-9e6d-cfbe521aa157.png"  width=900>

## Motivating Examples

### Example1:   effort estiamtion

Question: is highly complex software slower to build?    
Answer: the question is irrelevant (at some sites)

![image](https://user-images.githubusercontent.com/29195/131710162-3f3869f3-95cb-4f97-93c9-e7b7e013bda6.png)

So what else can we throw away.

![image](https://user-images.githubusercontent.com/29195/131708345-b3e25f09-c4c2-4a34-8979-b96a178d26e5.png)

![image](https://user-images.githubusercontent.com/29195/131708361-1ad1e4ec-712a-4454-a90d-4d6e8a156a50.png)


https://github.com/txt/ase19/blob/master/docs/cluster.md#top

lsh
cluster

optimizer. zitler

stats on each leaf


sway

# "Clustering"

"Clustering" means grouping together  similar things
- Give goal attributes $Y$  and other attributes $X$ it is typically groupings in $X$ space.
- But as we shall see, clustering in $X$, pls a little sampling in $Y$ can be very useful.

Large amounts of data can be approximated by the centroids of a few clusters. Why?
- "In most applications examples are not spread uniformly throughout the instance space, but are concentrated on or near
  a lower-dimensional manifold. Learners can implicitly take
  advantage of this lower effective dimension."      
  -- Pedro Domingoes
- Also,  Many rows must be similar to the point of redundancy  since
 - when we build a model, 
  each part of that model should have support from multiple
  data points. 
 - This means that all the rows can be shrunk back to just a few examples.

For example, here we are clustering 398 examples of cars using the $X$ variables: 
- find two distant examples $A,B$
- divide other examples into those closest to $A$ or $B$
- recurse on each half
- As a result, we can approximate 398 examples with just 16.

```
398  {:Acc+ 15.6 :Lbs- 2970.4 :Mpg+ 23.8}
| 199
| | 99
| | | 49
| | | | 24  {:Acc+ 17.3 :Lbs- 2623.5 :Mpg+ 30.4}
| | | | 25  {:Acc+ 16.3 :Lbs- 2693.4 :Mpg+ 29.2}
| | | 50
| | | | 25  {:Acc+ 15.8 :Lbs- 2446.1 :Mpg+ 27.2}
| | | | 25  {:Acc+ 16.7 :Lbs- 2309.2 :Mpg+ 26.0}
| | 100
| | | 50
| | | | 25  {:Acc+ 16.2 :Lbs- 2362.5 :Mpg+ 32.0}
| | | | 25  {:Acc+ 16.4 :Lbs- 2184.1 :Mpg+ 34.8}
| | | 50
| | | | 25  {:Acc+ 16.2 :Lbs- 2185.8 :Mpg+ 29.6}
| | | | 25  {:Acc+ 16.3 :Lbs- 2179.4 :Mpg+ 26.4}
| 199
| | 99
| | | 49
| | | | 24  {:Acc+ 16.6 :Lbs- 2716.9 :Mpg+ 22.5}
| | | | 25  {:Acc+ 16.1 :Lbs- 3063.5 :Mpg+ 20.4}
| | | 50
| | | | 25  {:Acc+ 17.4 :Lbs- 3104.6 :Mpg+ 21.6}
| | | | 25  {:Acc+ 16.3 :Lbs- 3145.6 :Mpg+ 22.0}
| | 100
| | | 50
| | | | 25  {:Acc+ 12.4 :Lbs- 4320.5 :Mpg+ 12.4}
| | | | 25  {:Acc+ 11.3 :Lbs- 4194.2 :Mpg+ 12.8}
| | | 50
| | | | 25  {:Acc+ 13.7 :Lbs- 4143.1 :Mpg+ 18.0}
| | | | 25  {:Acc+ 14.4 :Lbs- 3830.2 :Mpg+ 16.4}
```
This data has three $Y$ variables, acceleration (which we want to maximize), weight (which
we want to minimize) and miles per hour (which we want to maximize). We print the mean of these
values at the root and at each leaf:
- Note that even though we are not trying to, our clusters do separate good from bad $Y$ values

Now here's nearly the same algorithm, but now we run a   greedy search over the splits.
When splitting on  two distance points $A,B$, we peel at the $Y$ values  
 and ignore the worse half. 
```
398  {:Acc+ 15.6 :Lbs- 2970.4 :Mpg+ 23.8}
| 199
| | 100
| | | 50
| | | | 25  {:Acc+ 17.2 :Lbs- 2001.0 :Mpg+ 33.2}
```
Note that:
- This "clustering" algorithm is now an optimizer since it can isolate the best 25 examples out of the 398
- And it does so after evaluating just 5 examples
 - two at the root, 
 - then for each sub-split, we reuse one of the $A,B$ from the parent (the one that was best)

# Applications to SE


## Application 1: Requirements Engineering

In the summer of 2011 and 2012,  Menzies spent two months working on-site at Microsoft Redmond, observing data mining analysts.
- He observed numerous meetings where Microsoft’s data scientists and business users discussed logs of defect data. 
- There was a surprising little inspection of the output of data miners as compared to another process, 
    which we will call _fishing_. 
- In fishing, analysts and users spend much time inspecting and discussing small samples of either raw or exemplary or synthesized project data. 
- For example, in _data engagement meetings_, users debated the implications of data displayed on a screen. 
-  In this way, users engaged with the data and with each other by monitoring each other’s queries and checking each other’s conclusions.

Cluster + contrast was another fishing method seen at Microsoft. 
- In this method, data was reduced to a few clusters and users were then just shown the delta between those clusters (a technique we first saw used by Sauvik Das). 
- While contrasting, if feature values are the same in both clusters, then these were pruned from the reports to the user.
-  In this way, very large data sets can be shown on one PowerPoint slide. 
-  Note that cluster+contrast is a tool that can be usefully employed within data engagement meetings.

More generally, this process is based on the manifold assumption (used extensively in semi-supervised learning) that higher-dimensional data can be mapped to a lower dimensional space without loss of signal.
- In the following examples, the first attributes already occurring in the domain and the second uses an attribute synthesized from the data (the direction of greatest spread of the data)

<img width=500 src="https://user-images.githubusercontent.com/29195/131709651-2b8f6932-023a-479f-9505-0fffa1921ba0.png">

<img width=300 src="https://user-images.githubusercontent.com/29195/131709868-4e2c7444-0e37-4a71-bd47-b171bd2679f4.png">

 Apart from simpler explanations (and hence more user engagement and more auditability), throwing data away has privacy implications.
- Instead of sharing all data, if only share the reduced data set, then all the non-shared information is 100% private, by definition.
- Also, if we deploy systems based on the reduced set, then we never need to collect the attributes removed by pruning. 
  - So less intrusion into people's lives
- [Fayola Peters](https://www.ezzoterik.com/papers/15lace2.pdf) used cluster + contrast to prune, as she passed data around a community. 
  - At east step, and anomaly detector was called about members of that community only added in theor local data that was not already in the shared cache (i.e. only if it was anomalous).
 - She ended up sharing 20% of the rows and around a third of the columns. 1 - 1/5\*1/3 thus offered 93%   privacy
 - As for the remaining 7% of the data, we ran a mutator that pushed up items up the boundary point between classes (and no further). Bu certain common measures of privacy, that made the 7% space 80% private. 
 - Net effect 93% + .8*7 = 98.4% private,

<img width=90 src="/etc/img/peters1.png">

<img width=90 src="/etc/img/peters2.png">


### Application 2:   Defect prediction

[Papakroni](https://researchrepository.wvu.edu/cgi/viewcontent.cgi?article=4403&context=etd) argued that, for that purpose,
you do not need to show models... just insightful samples from the domain.

For example, here's a summary of [POI-3.0](https://zenodo.org/record/322443#.YS-obNNuc2k). The original data set is reduced from 442 rows and
21 columns to 21 rows and 6 columns.

![image](https://user-images.githubusercontent.com/29195/131706893-d46a785a-5ce1-4999-8e08-b770d8728ecb.png)


|name | what | notes |
|---| ------|--|
|lcom3| cohesion| if m,a are the number of methods,attributes in a class number and µ(a) is the number of methods accessing an attribute,then _lcom3 = (mean(µ(a)) - m)/ (1 - m)_ |
|ce  | efferent couplings| how many other classes is used by the specific class|
|rfc |response for a class | number of methods invoked in response to a message to the object.|
|cbm |coupling between objects |total number of new/redefined methods to which all the inherited methods are coupled|
|loc |lines of code | |
|defect| defect| Binary class. Indicates whether any defect is found in a post-release bug-tracking system. |

And we know how to change these

![image](https://user-images.githubusercontent.com/29195/131706567-b348b940-c7c3-4a2f-b20b-3303e036b4db.png)

![image](https://user-images.githubusercontent.com/29195/131708447-c0f0c4af-31e9-4389-acd6-d438b9bb835b.png)

Btw, see the colors?
- One surprisingly [good defect predictor](https://home.cse.ust.hk/~hunkim/papers/nam-ase2015.pdf)
is "count how often an example has attribute values falling into the worst part of each column" (e..g which side of the emdian your fall).
- And this does not even need clss labels to impement.
  -  Defeats most other unsupervised methods (at least, on SE data). See [IVSBC in Fig8](https://yanmeng.github.io/papers/JSS203.pdf).
- And recently we've found it [useful  to look at just a few (2.5% ) of the data labels](https://arxiv.org/pdf/2108.09847.pdf)
   to refine  what we mean by "worst half"
   
# How to Cluster

## Distance (Basic)
 Here is Aha's instance-based distance algorithm,
[section 2.4](https://link.springer.com/content/pdf/10.1007/BF00153759.pdf).

(Note: slow. Ungood for large dimensional spaces. We'll fix that below.)

L-norm (L2):

- D= (&sum; (&Delta;(x,y))<sup>p</sup>))<sup>1/p</sup>
- euclidean : p=2

But what is &Delta;  ?

-  &Delta; Symbols: 
    - return 0 if x == y else 1
- &Delta;  Numbers:
    -  x - y
    - to make numbers fair with symbols, normalize x,y 0,1 using (x-min)/(max-min)

What about missing values:

- assume worst case
- if both unknown, assume &delta; = 1
- if one symbol missing, assume &delta; = 1
- if one number missing:
    - let x,y be unknown, known
    - y = normalize(y)
    - x = 0 if y > 0.5 else 1
    - &Delta; =  (x-y)

In the following recall that `DaATA` keeps column headers separately
for the `i.cols.x` (independent) columns and the
`i.cols.y` (dependent) columns. 

```lua
function DATA.dist(i,row1,row2,  cols,      n,d) --> n; returns 0..1 distance `row1` to `row2`
  n,d = 0,0
  for _,col in pairs(cols or i.cols.x) do
    n = n + 1
    d = d + col:dist(row1.cells[col.at], row2.cells[col.at])^the.p end
  return (d/n)^(1/the.p) end

function SYM.dist(i,s1,s2)
  return s1=="?" and s2=="?" and 1 or (s1==s2) and 0 or 1 end 

function NUM.dist(i,n1,n2)
  if n1=="?" and n2=="?" then return 1 end -- here's the AHA assumption (assume the max)
  n1,n2 = i:norm(n1), i:norm(n2)
  if n1=="?" then n1 = n2<.5 and 1 or 0 end -- here's the AHA assumption (assume the max)
  if n2=="?" then n2 = n1<.5 and 1 or 0 end -- here's the AHA assumption (assume the max)
  return math.abs(n1 - n2) end 

function NUM.norm(i,n)
  return n == "?" and n  or (n - i.lo)/(i.hi - i.lo + 1E-32) end
```
With the above, we can sort other rows by their distance to `row1`:
```lua
function DATA.around(i,row1,  rows,cols) --> t; sort other `rows` by distance to `row`
  return sort(map(rows or i.rows, 
                  function(row2)  return {row=row2, dist=i:dist(row1,row2,cols)} end),lt"dist") end
```
In the above, `sort` is a table sort function that controls the sorting via a second sorting function.
In this case, the secondary function is `lt` which is a function that returns a function that sorts
items ascending on some argument:

```lua
function lt(x) --> fun;  return a function that sorts ascending on `x`
  return function(a,b) return a[x] < b[x] end end

function sort(t, fun) --> t; return `t`,  sorted by `fun` (default= `<`)
  table.sort(t,fun); return t end
```
## Recursive Bi-Clustering

<img align=right src="/etc/img/abc.png">
Once we know distance, then we  project things in $N$ dimensions down to one dimension (being a line between 2 distant points).

```lua
function cosine(a,b,c,    x1,x2,y) --> n,n;  find x,y from a line connecting `a` to `b`
  x1 = (a^2 + c^2 - b^2) / (2*c)
  x2 = math.max(0, math.min(1, x1)) -- in the incremental case, x1 might be outside 0,1
  y  = (a^2 - x2^2)^.5
  return x2, y end

function DATA.half(i,rows,  cols,above) --> t,t,row,row,row,n; divides data using 2 far points
  local A,B,left,right,c,dist,mid,some,project
  function project(row)    return {row=row, dist=cosine(dist(row,A), dist(row,B), c)} end
  function dist(row1,row2) return i:dist(row1,row2,cols) end
  rows = rows or i.rows
  some = many(rows,the.Sample)
  A    = above or any(some)  -- if a parent found a distant point, use that
  B    = i:around(A,some)[(the.Far * #rows)//1].row
  c    = dist(A,B)
  left, right = {}, {}
  for n,tmp in pairs(sort(map(rows, project), lt"dist")) do
    if   n <= #rows//2 
    then push(left,  tmp.row); mid = tmp.row
    else push(right, tmp.row) end end
  return left, right, A, B, mid, c end
```

Once we can divide some data in two, then recursive clustering is just recursive division.

```lua
function DATA.cluster(i,  rows,min,cols,above) --> t; returns `rows`, recursively halved
  local node,left,right,A,B,mid
  rows = rows or i.rows
  min  = min or (#rows)^the.min
  cols = cols or i.cols.x
  node = {data=i:clone(rows)} --xxx cloning
  if #rows > 2*min then
    left, right, node.A, node.B, node.mid = i:half(rows,cols,above)
    node.left  = i:cluster(left,  min, cols, node.A)
    node.right = i:cluster(right, min, cols, node.B) end
  return node end

```
Which, just to remind us, gives us this:
```
398  {:Acc+ 15.6 :Lbs- 2970.4 :Mpg+ 23.8}
| 199
| | 99
| | | 49
| | | | 24  {:Acc+ 17.3 :Lbs- 2623.5 :Mpg+ 30.4}
| | | | 25  {:Acc+ 16.3 :Lbs- 2693.4 :Mpg+ 29.2}
| | | 50
| | | | 25  {:Acc+ 15.8 :Lbs- 2446.1 :Mpg+ 27.2}
| | | | 25  {:Acc+ 16.7 :Lbs- 2309.2 :Mpg+ 26.0}
| | 100
| | | 50
| | | | 25  {:Acc+ 16.2 :Lbs- 2362.5 :Mpg+ 32.0}
| | | | 25  {:Acc+ 16.4 :Lbs- 2184.1 :Mpg+ 34.8}
| | | 50
| | | | 25  {:Acc+ 16.2 :Lbs- 2185.8 :Mpg+ 29.6}
| | | | 25  {:Acc+ 16.3 :Lbs- 2179.4 :Mpg+ 26.4}
| 199
| | 99
| | | 49
| | | | 24  {:Acc+ 16.6 :Lbs- 2716.9 :Mpg+ 22.5}
| | | | 25  {:Acc+ 16.1 :Lbs- 3063.5 :Mpg+ 20.4}
| | | 50
| | | | 25  {:Acc+ 17.4 :Lbs- 3104.6 :Mpg+ 21.6}
| | | | 25  {:Acc+ 16.3 :Lbs- 3145.6 :Mpg+ 22.0}
| | 100
| | | 50
| | | | 25  {:Acc+ 12.4 :Lbs- 4320.5 :Mpg+ 12.4}
| | | | 25  {:Acc+ 11.3 :Lbs- 4194.2 :Mpg+ 12.8}
| | | 50
| | | | 25  {:Acc+ 13.7 :Lbs- 4143.1 :Mpg+ 18.0}
| | | | 25  {:Acc+ 14.4 :Lbs- 3830.2 :Mpg+ 16.4}
```

## From Clustering to Optimization
With very little work, the above can become an optimizer.

```lua
function DATA.better(i,row1,row2,    s1,s2,ys,x,y) --> bool; true if `row1` dominates (via Zitzler04).
  s1,s2,ys,x,y = 0,0,i.cols.y
  for _,col in pairs(ys) do
    x  = row1.cells[col.at]
    y  = row2.cells[col.at]
    s1 = s1 - math.exp(col.w * (x-y)/#ys)
    s2 = s2 - math.exp(col.w * (y-x)/#ys) end
  return s1/#ys < s2/#ys end

function DATA.sway(i,  rows,min,cols,above) --> t; returns best half, recursively
  local node,left,right,A,B,mid
  rows = rows or i.rows
  min  = min or (#rows)^the.min
  cols = cols or i.cols.x
  node = {data=i:clone(rows)} --xxx cloning
  if #rows > 2*min then
    left, right, node.A, node.B, node.mid = i:half(rows,cols,above)
    if i:better(node.B,node.A) then left,right,node.A,node.B = right,left,node.B,node.A end
    node.left  = i:sway(left,  min, cols, node.A) end
  return node end
```

# Notes on Distanec

Btw, distance calcualtions are really slow
- heuristic for faster distance: divde up the space into small pieces (e.g. &sqrt;(N)
- Space between pieces = &infty;
- Space inside pieces: L2

Distance gets weird for high dimensions

- for an large dimensional orange, most of the mass is in the skin
- volume of the space increases so fast that the available data become sparse.
- amount of data needed to support the result grows exponentially with dimensions
 
[Distance is wierd](https://haralick.org/ML/useful_things_about_machine_learning.pdf):

- "Generalizing correctly becomes
exponentially harder as the dimensionality (number of features) of the examples grows, because a fixed-size training
set covers a dwindling fraction of the input space. Even with
a moderate dimension of 100 and a huge training set of a trillion examples, the latter covers only a fraction of about
10<sup>−18<sup> of the input space"
- "Our intuitions, which come from a three-dimensional world, often do not apply in high-dimensional
ones. In high dimensions, most of the mass may not be near the mean, but in an
increasingly distant “shell” around it; and most of the volume of a high-dimensional orange is in the skin, not the pulp."

# Standard Algorithms

k-meams

min-batch k-menas

E.g. [mini-batch k-means](https://www.eecs.tufts.edu/~dsculley/papers/fastkmeans.pdf)
- Pick first 20 examples (at random) as _controids_
- for everything else, run thrugh in batches of size (say 500,2000,etc)
  - mark each item with its nearest centroid
  - between batch B and B+1, move centroid towards its marked examples
    - "n" stores how often this centroid has been picked by new data
    - Each item "pulls" its centroid  attribute "c" towards its own attribute "x"  by an amount weighted   `c = (1-1/n)*c + x/n`. 
    - Note that when "n" is large, "c" barely moves at all.
   

random projectsion eg. wsay
 
![](https://ars.els-cdn.com/content/image/1-s2.0-S0031320315003945-gr2.jpg)

- Method one: Guassian random projections
   - Matrix = rows \* cols
   - Matrix A,B
   - A =        m × n 
   - B =        n × p 
   - C = A\*B = m x  p
   - So we can reduce n=1000 cols in matrix A to p=30 cols in C via a matrix
      - 1000 row by 30 cols
   - Initialize B by filling each column with a random number pulled from a normal bell curve
   - Only works if all the data is numeric
   - Requires all the data in RAM (bad for big data sets)
- Method two:  LSH: locality sensitivity hashing
   - Find a way to get an approximate position for a row, in a reduced space
      - e.g. repeat d times
          -  Find  two  distant (\*) "pivots"  = (p,o)
              - Pick, say, 30 rows at random then find within them, the most distant rows
          - the i-th dimension:
              - this row's d.i = 0 if (row closer to p than o) else 1
      - repeat d=log(sqrt(N))+1 pivots to get  d random projectsion
   - If you want not 0,1 on each dimension but a continuous number then:
      - given pivots (p,o) seperated by "c"
      - a = dist(row,p)
      - b = dist(row,o)
      - this row's d.i = (a^2 + c^2 - b^2) / (2c)
          - Cosine rule
   - Can be done via random sampling over some of the data.
      - Better for bigger data
      - But less exact
      - still, darn useful

 

(\*) beware outliers :  

- A safe thing might be to sort the pivots  by their distance and take something that is
  90% of max distance
