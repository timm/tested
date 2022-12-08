<p>
&nbsp;
<a name=top></a>
<p>
<table><tr>
<td><a href="/README.md#top">Home</a>
<td><a href="http:github.com/timm/tested/issues">issues</a>
</tr>
</table><hr>
<img  align=center width=600 src="/docs/img/banner.png"><br clear=all>
<a href="/LICENSE.md">&copy;2022,2023</a> by <a href="http://menzies.us">Tim Menzies</a>
</p>


# about.lua

```css

about.lua : summarize a table
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

USAGE:   about.lua  [OPTIONS]

OPTIONS:
  -d  --dump  on crash, print stackdump = false
  -f  --file  csv file                  = ../data/auto93.csv
  -g  --go    start-up action           = data
  -h  --help  show help                 = false

```
 
## NUM	
Summarizes a stream of numbers	

<dl>
<dt><b> NUM:new(  n:<tt>num</tt>?, s:<tt>str</tt>?) &rArr;  NUM </b></dt><dd>   constructor; optionally for column `n` named `s`  </dd>
<dt><b> NUM:add(n:<tt>num</tt>) &rArr;  NUM </b></dt><dd>  add `n`, update min,max,standard deviation </dd>
<dt><b> NUM:mid(x) &rArr;  n </b></dt><dd>  return mean </dd>
<dt><b> NUM:div(x) &rArr;  n </b></dt><dd>  return standard deviation </dd>
</dl>

## SYM	
## COLS	
## DATA	

<dl>
<dt><b> DATA:new(src:<tt>str</tt>) &rArr;  DATA </b></dt><dd>  `src` is either (a) a file name string or (b) list or rows </dd>
</dl>

## Start-up	
