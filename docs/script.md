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


# script.lua

```css
   
data.lua : an example script with help text and a test suite
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

USAGE:   101.lua  [OPTIONS]

OPTIONS:
  -d  --dump  on crash, dump stack = false
  -g  --go    start-up action      = data
  -h  --help  show help            = false
  -s  --seed  random number seed   = 937162211
  -g  the	show settings
  -g  rand	generate, reset, regenerate same
  -g  sym	check syms
  -g  num	check nums

```
 
## Classes	

<dl>
<dt><b> obj(s:<tt>str</tt>) &rArr;  t </b></dt><dd>

 create a klass and a constructor 

</dd>
</dl>

### SYM	
Summarize a stream of symbols.	

<dl>
<dt><b> SYM.new(i) &rArr;  SYM </b></dt><dd>

 constructor

</dd>
<dt><b> SYM.add(i, x) &rArr;  nil </b></dt><dd>

  update counts of things seen so far

</dd>
<dt><b> SYM.mid(i, x) &rArr;  n </b></dt><dd>

 return the mode

</dd>
<dt><b> SYM.div(i, x) &rArr;  n </b></dt><dd>

 return the entropy

</dd>
</dl>

### NUM	
Summarizes a stream of numbers.	

<dl>
<dt><b> NUM.new(i) &rArr;  NUM </b></dt><dd>

  constructor; 

</dd>
<dt><b> NUM.add(i, n:<tt>num</tt>) &rArr;  NUM </b></dt><dd>

 add `n`, update lo,hi and stuff needed for standard deviation

</dd>
<dt><b> NUM.mid(i, x) &rArr;  n </b></dt><dd>

 return mean

</dd>
<dt><b> NUM.div(i, x) &rArr;  n </b></dt><dd>

 return standard deviation using Welford's algorithm http://t.ly/nn_W

</dd>
</dl>

## Misc support functions	
### Numerics	

<dl>
<dt><b> rint(lo, hi) &rArr;  n  </b></dt><dd>

 a integer lo..hi-1

</dd>
<dt><b> rand(lo, hi) &rArr;  n </b></dt><dd>

 a float "x" lo<=x < x

</dd>
</dl>

### Lists	
Note the following conventions for `map`.	
- If a nil first argument is returned, that means :skip this result"	
- If a nil second argument is returned, that means place the result as position size+1 in output.	
- Else, the second argument is the key where we store function output.	

<dl>
<dt><b> map(t:<tt>tab</tt>,  fun:<tt>fun</tt>) &rArr;  t </b></dt><dd>

 map a function `fun`(v) over list (skip nil results) 

</dd>
<dt><b> kap(t:<tt>tab</tt>,  fun:<tt>fun</tt>) &rArr;  t </b></dt><dd>

 map function `fun`(k,v) over list (skip nil results) 

</dd>
<dt><b> sort(t:<tt>tab</tt>,  fun:<tt>fun</tt>) &rArr;  t </b></dt><dd>

 return `t`,  sorted by `fun` (default= `<`)

</dd>
<dt><b> keys(t:<tt>tab</tt>) &rArr;  ss </b></dt><dd>

 return list of table keys, sorted

</dd>
</dl>

### Strings	

<dl>
<dt><b> fmt(sControl:<tt>str</tt>, ...) &rArr;  str </b></dt><dd>

 emulate printf

</dd>
<dt><b> oo(t:<tt>tab</tt>) &rArr;  t </b></dt><dd>

 print `t` then return it

</dd>
<dt><b> o(t:<tt>tab</tt>, isKeys:<tt>{bool}</tt>) &rArr;  s </b></dt><dd>

 convert `t` to a string. sort named keys. 

</dd>
<dt><b> coerce(s:<tt>str</tt>) &rArr;  any </b></dt><dd>

 return int or float or bool or string from `s`

</dd>
</dl>

### Main	

<dl>
<dt><b> settings(s:<tt>str</tt>) &rArr;  t </b></dt><dd>

  parse help string to extract a table of options

</dd>
<dt><b> cli(options:<tt>tab</tt>) &rArr;  t </b></dt><dd>

 update key,vals in `t` from command-line flags

</dd>
</dl>

`main` fills in the settings, updates them from the command line, runs	
the start up actions (and before each run, it resets the random number seed and settongs);	
and, finally, returns the number of test crashed to the operating system.	

<dl>
<dt><b> main(options:<tt>tab</tt>, help, funs:<tt>{fun}</tt>) &rArr;  nil </b></dt><dd>

 main program

</dd>
</dl>

