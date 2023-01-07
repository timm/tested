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


# fish1.lua

```css
  
fish1,lua : sort many <X,Y> things on Y, after peeking at just a few Y things
(c)2022 Tim Menzies <timm@ieee.org> BSD-2

Note: fish1 is just a demonststraing of this kind of processing.
It is designed to be incomplete, to have flaws. If you look at this
case say say "a better way to do this wuld be XYZ", then fish1 has
been successful.

USAGE: lua fish1.lua [OPTIONS] [-g [ACTIONS

OPTIONS:
  -b  --budget  number of evaluations = 16
  -f  --file    csv data file         = ../etc/data/auto93.csv
  -g  --go      start up action       = ls
  -h  --help    show help             = false
  -p  --p       distance coefficient  = 2
  -s  --seed    random number seed    = 10019

ACTIONS:
  -g  ls	list all
  -g  the	show settings
  -g  num	can NUMs be built?
  -g  sym	can SYMs be built?
  -g  data	can we load data from disk?
  -g  clone	can we cline data?
  -g  norm	does data normalization work?
  -g  eg	can i sort examples?
  -g  learn	can i sort with minimal data?
  -g  learnssum	can i sort with minimal data?

```
 

<dl>
<dt><b> obj(s:<tt>str</tt>) &rArr;  t </b></dt><dd>

 create a klass and a constructor + print method

</dd>
</dl>

Misc support functions	

<dl>
<dt><b> fmt(sControl:<tt>str</tt>, ...) &rArr;  str </b></dt><dd>

 emulate printf

</dd>
<dt><b> shuffle(t:<tt>tab</tt>,    j?) &rArr;  t </b></dt><dd>

  Randomly shuffle, in place, the list `t`.

</dd>
<dt><b> slice(t:<tt>tab</tt>,  go,  stop:<tt>str</tt>,  inc) &rArr;  t </b></dt><dd>

 return `t` from `go`(=1) to `stop`(=#t), by `inc`(=1)

</dd>
<dt><b> sort(t:<tt>tab</tt>,  fun:<tt>fun</tt>) &rArr;  t </b></dt><dd>

 return `t`,  sorted by `fun` (default= `<`)

</dd>
</dl>

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
<dt><b> copy(t:<tt>tab</tt>) &rArr;  t </b></dt><dd>

 return a shallow copy of `t.

</dd>
<dt><b> coerce(s:<tt>str</tt>) &rArr;  any </b></dt><dd>

 return int or float or bool or string from `s`

</dd>
<dt><b> csv(sFilename:<tt>str</tt>, fun:<tt>fun</tt>) &rArr;  nil </b></dt><dd>

 call `fun` on rows (after coercing cell text)

</dd>
<dt><b> settings(s:<tt>str</tt>) &rArr;  t </b></dt><dd>

  parse help string to extract a table of options

</dd>
<dt><b> cli(options:<tt>tab</tt>) &rArr;  t </b></dt><dd>

 update key,vals in `t` from command-line flags

</dd>
</dl>

