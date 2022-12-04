&nsbp;<p><a name=top></a><center>

[Home]() :: [Tutorial]() :: [License]() :: [Issues]() &copy; 2022 Tim Menzies   

<img width=600 src="docs/img/banner.png">

</center>

```css

consise.lua : report ranges that distinguish best rows from rest
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

USAGE:   concise.lua  [OPTIONS]

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
<dt><b> NUM:discretize(n:<tt>num</tt>) &rArr;  num </b></dt><dd>  discretize `Num`s,rounded to (hi-lo)/Bins </dd>
</dl>

## SYM	
## ROW	
## COLS	
## DATA	
## Start-up	
