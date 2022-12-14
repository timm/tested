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


# about.lua

```css

about.lua : summarize a table
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

USAGE:   about.lua  [OPTIONS]

OPTIONS:
  -d  --dump  on crash, print stackdump = false
  -f  --file  csv file                  = ../etc/data/auto93.csv
  -g  --go    start-up action           = data
  -h  --help  show help                 = false

```
 
## NUM	
Summarizes a stream of numbers	

<dl>
<dt><b> NUM:new(  n:<tt>num</tt>?, s:<tt>str</tt>?) &rArr;  NUM </b></dt><dd>

  constructor; optionally for column `n` named `s` 

</dd>
<dt><b> NUM:add(n:<tt>num</tt>) &rArr;  NUM </b></dt><dd>

 add `n`, update min,max,standard deviation

</dd>
<dt><b> NUM:mid(x) &rArr;  n </b></dt><dd>

 return mean

</dd>
<dt><b> NUM:div(x) &rArr;  n </b></dt><dd>

 return standard deviation

</dd>
</dl>

## SYM	
## ROW	
## DATA	

<dl>
<dt><b> DATA:new(src:<tt>str</tt>) &rArr;  DATA </b></dt><dd>

 `src` is either (a) a file name string or (b) list or rows

</dd>
</dl>

## Start-up	
