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


# bins.lua

```css

bins.lua : report ranges that distinguish best rows from rest
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

USAGE:   bins.lua  [OPTIONS]

INFERENCE OPTIONS:
  -b  --best   coefficient on 'best'        = .5
  -B  --Bins   initial number of bins       = 16
  -c  --cohen  Cohen's small effect test    = .35
  -r  --rest   explore rest* number of best = 2

OTHER OPTIONS:
  -d  --dump   on crash, print stack dump = fals
  -f  --file   csv file                   = ../data/auto93.csv
  -g  --go     start-up action            = data
  -h  --help   show help                  = false

```
 
## NUM	

<dl>
<dt><b> NUM:discretize(n:<tt>num</tt>) &rArr;  num </b></dt><dd>

 discretize `Num`s,rounded to (hi-lo)/Bins

</dd>
</dl>

## SYM	
## ROW	
## COLS	
## DATA	
## Start-up	
