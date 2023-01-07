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


# stats.lua

```css
false	false
true	true

true	true
true	true
false	false

true	false
true	true
false	false
1	false	false	false
1.1	false	false	false
1.2	true	false	false
1.3	true	false	false
1.4	true	false	false
1.5	true	false	false
1.6	true	true	false
1.7	true	true	false
1.8	true	true	false
1.9	true	true	false

eg4
		x5	1	-  *  ------   |                 { 0.10,  0.10,  0.20,  0.30,  0.40}
		x3	1	-   *   ----   |                 { 0.15,  0.15,  0.25,  0.35,  0.40}
		x1	2	        -     *|----             { 0.34,  0.34,  0.49,  0.51,  0.60}
		x2	3	               |   -  *    ----- { 0.60,  0.60,  0.70,  0.80,  0.90}
		x4	3	               |   -  *    ----- { 0.60,  0.60,  0.70,  0.80,  0.90}

eg5
		x1	1	*              |                 { 0.34,  0.34,  0.49,  0.51,  0.60}
		x2	2	               |   -   *   ----- { 6.00,  6.00,  7.00,  8.00,  9.00}

eg6
		x1	1	*              |                 { 0.10,  0.10,  0.20,  0.30,  0.40}
		x2	1	*              |                 { 0.10,  0.10,  0.20,  0.30,  0.40}
		x3	2	               |    -  *   ----- { 6.00,  6.00,  7.00,  8.00,  9.00}

eg7
		x1	1	--------       *               - {99.00, 99.50, 100.00, 101.00, 101.00}
		x4	1	---------------*               - {99.00, 100.00, 100.00, 101.00, 101.00}
		x2	1	---------------*               - {99.00, 100.00, 100.00, 101.00, 101.00}
		x3	1	--------       *               - {99.00, 99.50, 100.00, 101.00, 101.00}

eg8
		x1	1	*-             |                 {11.00, 11.00, 12.00, 12.00, 13.00}
		x2	1	-* -           |                 {12.00, 12.00, 13.00, 14.00, 14.00}
		x3	2	               | *---------      {23.00, 23.00, 24.00, 24.00, 31.00}
		x4	3	               |            -*-- {32.00, 32.00, 33.00, 33.00, 34.00}

eg4
		x5	1	-  *  ------   |                 { 0.10,  0.10,  0.20,  0.30,  0.40}
		x3	1	-   *   ----   |                 { 0.15,  0.15,  0.25,  0.35,  0.40}
		x1	2	        -     *|----             { 0.34,  0.34,  0.49,  0.51,  0.60}
		x2	3	               |   -  *    ----- { 0.60,  0.60,  0.70,  0.80,  0.90}
		x4	3	               |   -  *    ----- { 0.60,  0.60,  0.70,  0.80,  0.90}

eg10
		x6	1	 -*--          |                 { 8.72,  9.46, 10.01, 10.50, 11.29}
		x1	1	 -*--          |                 { 8.78,  9.52, 10.03, 10.52, 11.26}
		x7	1	 -*--          |                 { 8.74,  9.52, 10.08, 10.59, 11.40}
		x2	1	 --*-          |                 { 8.79,  9.61, 10.15, 10.60, 11.36}
		x3	1	             -*|-                {18.62, 19.46, 19.98, 20.47, 21.26}
		x8	1	             -*|-                {18.75, 19.44, 19.98, 20.53, 21.28}
		x4	1	               |         -*-     {28.73, 29.41, 29.96, 30.52, 31.21}
		x9	1	               |         -*--    {28.73, 29.47, 30.02, 30.59, 31.27}
		x5	1	               |         -*--    {28.86, 29.54, 30.09, 30.63, 31.44}
		x10	1	               |         -*--    {28.86, 29.64, 30.13, 30.70, 31.35}
```
 
## Scott-Knott tests	
If statistics gets too complicated then the solution is easy: use less stats!	
Scott-Knott is a way to find differences in N	
treatments using at most $O(log2(N))$ comparisons. This is useful since:	
- Some statistical tests are slow (e.g. bootstrap). 	
- If we run an all-pairs comparisons between	
$N$ tests at confidence $C$, then we only are $C_1=C_0^{(n*(n-1)/2)}$ confident in the results.	
This is much, much smaller than the $C_2=C_0^{log2(N)}$ confidence found from Scott-Knott;	
- e.g for N=10, $C_0=95$%, $C_1$ is less than one percent while $C_2$ is over	
75 percent (for Scott-Knott).	
 	
Scott-Knott sorts treatments on the their median values, then looks for the split	
that maximizes the difference in the split before and after the split. If statistical	
tests say that the splits are different, then we recurse on each half. This generates	
a tree of treatments where the treatments in the left-most node get ranked one, the next	
get ranked two, etc. 	
 	
As to stats tests, this code checks for difference in the splits using two non-parametric tests:	
- A MannWhitney U test that checks if the ranks of the two splits are distinguishable;	
- A CliffsDelta effect size test (which reports if there is enough difference in the splits)	
 	
## RX objects	
This code returns "rank: objects which contain	
- `name` of treatment	
- the list `t` of sorted values	
- the `rank` (computed by Scott-Knott)	
- the `show` (which is a pretty print of the output).	
 	
For example, here's data from five treatmetns:	
 	
data= {	
x1={0.34,0.49,0.51,0.6,.34,.49,.51,.6},	
x2={0.6,0.7,0.8,0.9,.6,.7,.8,.9},	
x3={0.15,0.25,0.4,0.35,0.15,0.25,0.4,0.35},	
x4={0.6,0.7,0.8,0.9,0.6,0.7,0.8,0.9},	
x5={0.1,0.2,0.3,0.4,0.1,0.2,0.3,0.4}}	
 	
And here's the `show` (where the first two and the last two treatments have the same rank):	
 	
for _,rx in pairs(sk(data)) do print(rx.name, rx.rank, rx.show) end	
 	
x5	1	-  *  ------   |                 ( 0.10,  0.10,  0.20,  0.30,  0.40)	
x3	1	-   *   ----   |                 ( 0.15,  0.15,  0.25,  0.35,  0.40)	
x1	2	        -     *|----             ( 0.34,  0.34,  0.49,  0.51,  0.60)	
x4	3	               |   -  *    ----- ( 0.60,  0.60,  0.70,  0.80,  0.90)	
x2	3	               |   -  *    ----- ( 0.60,  0.60,  0.70,  0.80,  0.90)	
 	

<dl>
<dt><b> RX(t:<tt>tab</tt>, s:<tt>str</tt>) &rArr;  RX </b></dt><dd>

 constructor for treatments. ensures treatment results are sorted

</dd>
<dt><b> rank(rx:<tt>RX</tt>) &rArr;  n </b></dt><dd>

 returns average range in a treatment  

</dd>
<dt><b> add(rx:<tt>RX</tt>, ns:<tt>{num}</tt>) &rArr;  RX </b></dt><dd>

 returns a new rank combining an old rank with a list of numbers `ns`

</dd>
<dt><b> adds(rxs:<tt>{RX}</tt>, lo, hi) &rArr;  RX </b></dt><dd>

 combines treatments from index `rxs[lo]` to `rxs[hi]`

</dd>
</dl>

## 3 Main functions	
The three main stats tests are	
- `sk` which is the top-level driver 	
- `cliffsDelta` which is the effect size test	
- `mwu` which is the Mann-Whitney U tess	

<dl>
<dt><b> sk(t:<tt>tab</tt>,   nConf:<tt>num</tt>?, nDull:<tt>num</tt>?, nWidth:<tt>num</tt>?) &rArr;  rxs </b></dt><dd>

 main. ranks treatments on stats

</dd>
<dt><b> cliffsDelta(ns1:<tt>num</tt>, ns2:<tt>num</tt>,  dull) &rArr;  bool </b></dt><dd>

 true if different by a trivial amount

</dd>
<dt><b> mwu(ns1:<tt>num</tt>, ns2:<tt>num</tt>, nConf:<tt>num</tt>) &rArr; bool </b></dt><dd>

 True if ranks of `ns1,ns2` are different at confidence `nConf` 

</dd>
<dt><b> ranks(ns1:<tt>num</tt>, ns2:<tt>num</tt>) &rArr; t </b></dt><dd>

 numbers of both populations are jointly ranked 

</dd>
</dl>

##  Misc	
After the above, all the rest is LUA miscellany.	
### String to Thing	

<dl>
<dt><b> cli(help, t:<tt>tab</tt>) &rArr;  t </b></dt><dd>

 update key,vals in `t` from command-line flags

</dd>
<dt><b> coerce(s:<tt>str</tt>) &rArr;  any </b></dt><dd>

 return int or float or bool or string from `s`

</dd>
<dt><b> median(t:<tt>tab</tt>) &rArr;  n </b></dt><dd>

 assumes t is sorted 

</dd>
<dt><b> settings(s:<tt>str</tt>, t:<tt>tab</tt>) &rArr;  t </b></dt><dd>

 extra key value pairs from the help string `s`

</dd>
<dt><b> slurp(sFile:<tt>str</tt>) &rArr;  t </b></dt><dd>

 for a file with words and numbers, add numbers to the proceeding word

</dd>
<dt><b> words(sFile:<tt>str</tt>, fun:<tt>fun</tt>) &rArr;  nil </b></dt><dd>

 call `fun` on all words (space separated) in file

</dd>
</dl>

### Lists	

<dl>
<dt><b> sort(t:<tt>tab</tt>, fun:<tt>fun</tt>) &rArr;  t </b></dt><dd>

 returns `t` sorted by `fun` 

</dd>
<dt><b> map(t:<tt>tab</tt>, fun:<tt>fun</tt>) &rArr;  t </b></dt><dd>

 returns copy of `t`, all items filtered by `fun`.

</dd>
</dl>

### Thing to String	

<dl>
<dt><b> oo(t:<tt>tab</tt>) &rArr;  t </b></dt><dd>

 print `t` then return `t`.

</dd>
<dt><b> o(t:<tt>tab</tt>) &rArr;  s </b></dt><dd>

 generate string from `t` 

</dd>
<dt><b> tiles(rxs:<tt>{RX}</tt>) &rArr;  ss </b></dt><dd>

 makes on string per treatment showing rank, distribution, and values

</dd>
<dt><b> norm(mu, sd:<tt>str</tt>) &rArr;  n </b></dt><dd>

 return a sample from a Gaussian with mean `mu` and sd `sd`

</dd>
</dl>

for k,v in pairs(_ENV) do if not b4[k] then print("?",k,type(v)) end end	
if   pcall(debug.getlocal,4,1) 	
then return sk	
else the=cli(help,the)	
for _,rx in pairs(sk(the.file)) do print(rx.rank,rx.name,rx.show) end end	
