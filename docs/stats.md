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


# stats.lua

```css
stats.lua: nom-parametric statistical ranking of treatmentsa
(c)2022 Tim Menzies, timm@ieee.org BSD-2

USAGE:
  local sk=require("stats")
  sk(t, {nConf=95;dull=.147,fmt="%5.2s"})

  or, from the shell:
  lua stats.lua -f data [OPTIONS]

  In the above `data` is a file of words and numbers were each
  number is associated to a list defined for each proceeding
  word. E.g. "a 1 2  b 1 2 a 3" would be parsed as rx["a"]={1,2,3}
  and rx["b"]={1,2}. Data files can contain any number of 
  spaces, tabs, and new lines.

OPTIONS:
  -c --conf  hypothesis test confidence; one of 95,99 = 95
  -d --dull  effect size threshold (.147=small)       = .147
  -f --file  file to read data                        = .
  -F --Fmt   number format for display                = %5.2f
  -g --go    start-up actions                         = nothing
  -h --help  show help                                = false
  -s --seed  random number seed                       = 1
  -w --width width of ascii plots                     = 32
  
BUGS:
  To view/add known bugs, see http://github.com/timm/tested/issues.

```
 
## Scott-Knott tests	
If statistics gets too complicated then the solution is easy: use less stats!	
Scott-Knott is a way to find differences in N	
treatments using at most $O(log2(N))$ comparisons. This is useful since:	
- Some statistical tests are slow (e.g. bootstrap). 	
- If we run an all-pairs comparisons between	
  $N$ tests at confidence $C$, then we only are $C_1=C_0^{(n*(n-1)/2)}$ confident in the results.	
  This is much, much smaller than the $C_2=C_0^{log2(N)}$ confidence found from Scott-Knott;	
  - e.g for N=10, at $C_1,C_2$ at $C_0=95$% confidence is one percent versus	
   75 percent (for Scott-Knott).	
 	
Scott-Knott sorts treatments on the their median values, then looks for the split	
that maximizes the difference in the split before and after the split. If statistical	
tests say that the splits are different, then we recurse on each half. This generates	
a tree of treatments where the treatments in the left-most node get ranked one, the next	
get ranked two, etc. 	
As to stats tests, this code checks for difference in the splits using two non-parametric tests:	
- A MannWhitney U test that checks if the ranks of the two splits are distinguishable;	
- A CliffsDelta effect size test (which reports if there is enough difference in the splits)	
This code returns "rank: objects which contain	
- `name` of treatment	
- the list `t` of sorted values	
- the `rank` (computed by Scott-Knott)	
- the `show` (which is a pretty print of the output).	

<dl>
<dt><b> RX(t:<tt>tab</tt>, s:<tt>str</tt>) &rArr;  RX </b></dt><dd>  constructor for treatments. ensures treatment results are sorted </dd>
<dt><b> rank(rx:<tt>RX</tt>) &rArr;  n </b></dt><dd>  returns average range in a treatment   </dd>
<dt><b> add(rx:<tt>RX</tt>, ns:<tt>{num}</tt>) &rArr;  RX </b></dt><dd>  returns a new rank combining an old rank with a list of numbers `ns` </dd>
<dt><b> adds(rxs:<tt>{RX}</tt>, lo, hi) &rArr;  RX </b></dt><dd>  combines treatments from index `rxs[lo]` to `rxs[hi]` </dd>
</dl>

## Details	
The three main stats tests are	
- `sk` which is the top-level driver 	
- `cliffsDelta` which is the effect size test	
- `mwu` which is the Mann-Whitney U tess	

<dl>
<dt><b> sk(t:<tt>tab</tt>,   nConf:<tt>num</tt>?, nDull:<tt>num</tt>?, nWidth:<tt>num</tt>?) &rArr;  rxs </b></dt><dd>  main. ranks treatments on stats </dd>
<dt><b> cliffsDelta(ns1:<tt>num</tt>, ns2:<tt>num</tt>,  dull) &rArr;  bool </b></dt><dd>  true if different by a trivial amount </dd>
<dt><b> mwu(ns1:<tt>num</tt>, ns2:<tt>num</tt>, nConf:<tt>num</tt>) &rArr; bool </b></dt><dd>  True if ranks of `ns1,ns2` are different at confidence `nConf`  </dd>
</dl>

##  Misc	
### String to Thing	

<dl>
<dt><b> cli(help, t:<tt>tab</tt>) &rArr;  t </b></dt><dd>  update key,vals in `t` from command-line flags </dd>
<dt><b> coerce(s:<tt>str</tt>) &rArr;  any </b></dt><dd>  return int or float or bool or string from `s` </dd>
<dt><b> median(t:<tt>tab</tt>) &rArr;  n </b></dt><dd>  assumes t is sorted  </dd>
<dt><b> settings(s:<tt>str</tt>, t:<tt>tab</tt>) &rArr;  t </b></dt><dd>  extra key value pairs from the help string `s` </dd>
<dt><b> slurp(sFile:<tt>str</tt>) &rArr;  t </b></dt><dd>  for a file with words and numbers, add numbers to the proceeding word </dd>
<dt><b> words(sFile:<tt>str</tt>, fun:<tt>fun</tt>) &rArr;  nil </b></dt><dd>  call `fun` on all words (space separated) in file </dd>
</dl>

### Lists	

<dl>
<dt><b> sort(t:<tt>tab</tt>, fun:<tt>fun</tt>) &rArr;  t </b></dt><dd>  returns `t` sorted by `fun`  </dd>
<dt><b> map(t:<tt>tab</tt>, fun:<tt>fun</tt>) &rArr;  t </b></dt><dd>  returns copy of `t`, all items filtered by `fun`. </dd>
</dl>

### Thing to String	

<dl>
<dt><b> oo(t:<tt>tab</tt>) &rArr;  t </b></dt><dd>  print `t` then return `t`. </dd>
<dt><b> o(t:<tt>tab</tt>) &rArr;  s </b></dt><dd>  generate string from `t`  </dd>
<dt><b> norm(mu, sd:<tt>str</tt>) &rArr;  n </b></dt><dd>  return a sample from a Gaussian with mean `mu` and sd `sd` </dd>
</dl>

