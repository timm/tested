
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



  
**_NUM:new(  n:<tt>num</tt>?, s:<tt>str</tt>?) &rArr;  NUM_**  
&nbsp;&nbsp;&nbsp;&nbsp;  constructor; optionally for column `n` named `s`     
  
**_NUM:add(n:<tt>num</tt>) &rArr;  NUM_**  
&nbsp;&nbsp;&nbsp;&nbsp; add `n`, update min,max,standard deviation    
  
**_NUM:mid(x) &rArr;  n_**  
&nbsp;&nbsp;&nbsp;&nbsp; return mean    
  
**_NUM:div(x) &rArr;  n_**  
&nbsp;&nbsp;&nbsp;&nbsp; return standard deviation    



## SYM	
## COLS	
## DATA	



  
**_DATA:new(src:<tt>str</tt>) &rArr;  DATA_**  
&nbsp;&nbsp;&nbsp;&nbsp; `src` is either (a) a file name string or (b) list or rows    



## Start-up	
