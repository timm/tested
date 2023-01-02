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


# Automated SE and Reservoir Sampling


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


