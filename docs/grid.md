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


# grid.lua

```css
   
gird.lua : a rep grid processor
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

USAGE: grid.lua  [OPTIONS] [-g ACTION]

OPTIONS:
  -d  --dump    on crash, dump stack   = false
  -f  --file    name of file           = ../etc/data/repgrid1.csv
  -g  --go      start-up action        = data
  -h  --help    show help              = false
  -p  --p       distance coefficient   = 2
  -s  --seed    random number seed     = 937162211

ACTIONS:
  -g  the	show settings
  -g  copy	check copy
  -g  sym	check syms
  -g  num	check nums
  -g  rep	checking repgrid

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
<dt><b> SYM.new(i, at, txt) &rArr;  SYM </b></dt><dd>

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
<dt><b> SYM.rnd(i, x, n:<tt>num</tt>) &rArr;  s </b></dt><dd>

 return `n` unchanged (SYMs do not get rounded)

</dd>
</dl>

### NUM	
Summarizes a stream of numbers.	

<dl>
<dt><b> NUM.new(i, at, txt) &rArr;  NUM </b></dt><dd>

  constructor; 

</dd>
<dt><b> NUM.add(i, n:<tt>num</tt>) &rArr;  NUM </b></dt><dd>

 add `n`, update lo,hi and stuff needed for standard deviation

</dd>
<dt><b> NUM.mid(i, x) &rArr;  n </b></dt><dd>

 return mean

</dd>
<dt><b> NUM.div(i, x) &rArr;  n </b></dt><dd>

 return standard deviation using Welford's algorithm http://.ly/nn_W

</dd>
<dt><b> NUM.rnd(i, x, n:<tt>num</tt>) &rArr;  n </b></dt><dd>

 return number, rounded

</dd>
</dl>

### COLS	
Factory for managing a set of NUMs or SYMs	

<dl>
<dt><b> COLS.new(i, t:<tt>tab</tt>) &rArr;  COLS </b></dt><dd>

 generate NUMs and SYMs from column names

</dd>
<dt><b> COLS.add(i, row:<tt>ROW</tt>) &rArr;  nil </b></dt><dd>

 update the (not skipped) columns with details from `row`

</dd>
</dl>

### ROW	
Store one record.	

<dl>
<dt><b> ROW.new(i, t:<tt>tab</tt>) &rArr;  ROW </b></dt><dd>



</dd>
</dl>

### DATA	
Store many rows, summarized into columns	

<dl>
<dt><b> DATA.new(i, src:<tt>str</tt>) &rArr;  DATA </b></dt><dd>

 A container of `i.rows`, to be summarized in `i.cols`

</dd>
<dt><b> DATA.add(i, t:<tt>tab</tt>) &rArr;  nil </b></dt><dd>

 add a new row, update column headers

</dd>
<dt><b> DATA.clone(i,   init?) &rArr;  DATA </b></dt><dd>

 return a DATA with same structure as `ii. 

</dd>
<dt><b> DATA.stats(i,   what?, cols:<tt>tab</tt>?, nPlaces:<tt>{num}</tt>?, fun:<tt>fun</tt>?) &rArr;  t </b></dt><dd>

 reports mid or div of cols (defaults to i.cols.y)

</dd>
<dt><b> DATA.dist(i, row1, row2,   cols:<tt>tab</tt>?) &rArr;  n </b></dt><dd>

 returns 0..1 distance `row1` to `row2`

</dd>
<dt><b> DATA.around(i, row1,   rows:<tt>{ROW}</tt>?, cols:<tt>tab</tt>?) &rArr;  t </b></dt><dd>

 sort other `rows` by distance to `row`

</dd>
<dt><b> DATA.furthest(i, row1,   rows:<tt>{ROW}</tt>?, cols:<tt>tab</tt>?) &rArr;  t </b></dt><dd>

 sort other `rows` by distance to `row`

</dd>
<dt><b> DATA.half(i, rows:<tt>{ROW}</tt>,   cols:<tt>tab</tt>?, above?) &rArr;  t,t,row,row,row,n </b></dt><dd>

 divides data using 2 far points

</dd>
<dt><b> DATA.cluster(i,   rows:<tt>{ROW}</tt>?, cols:<tt>tab</tt>?, above?) &rArr;  t </b></dt><dd>

 returns `rows`, recursively halved

</dd>
</dl>

## Misc support functions	

<dl>
<dt><b> show(node:<tt>num</tt>, what, cols:<tt>tab</tt>, nPlaces:<tt>{num}</tt>) &rArr;  nil </b></dt><dd>

 prints the tree generated from `DATA:tree`.

</dd>
</dl>

### Numerics	

<dl>
<dt><b> rint(lo, hi) &rArr;  n </b></dt><dd>

 a integer lo..hi-1

</dd>
<dt><b> rand(lo, hi) &rArr;  n </b></dt><dd>

 a float "x" lo<=x < x

</dd>
<dt><b> rnd(n:<tt>num</tt>,  nPlaces:<tt>{num}</tt>) &rArr;  num </b></dt><dd>

 return `n` rounded to `nPlaces`

</dd>
<dt><b> cosine(a, b, c) &rArr;  n,n </b></dt><dd>

  find x,y from a line connecting `a` to `b`

</dd>
</dl>

### Lists	
Note the following conventions for functions passed to  `map` or `kap`.	
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
<dt><b> lt(x) &rArr;  fun </b></dt><dd>

  return a function that sorts ascending on `x`

</dd>
<dt><b> keys(t:<tt>tab</tt>) &rArr;  ss </b></dt><dd>

 return list of table keys, sorted

</dd>
<dt><b> push(t:<tt>tab</tt>,  x) &rArr;  any </b></dt><dd>

 push `x` to end of list; return `x` 

</dd>
<dt><b> any(t:<tt>tab</tt>) &rArr;  x </b></dt><dd>

 returns one items at random

</dd>
<dt><b> many(t:<tt>tab</tt>, n:<tt>num</tt>) &rArr;  t1 </b></dt><dd>

 returns some items from `t`

</dd>
<dt><b> copy(t:<tt>tab</tt>) &rArr;  t </b></dt><dd>

 deep copy. Includes meta-table

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
<dt><b> csv(sFilename:<tt>str</tt>, fun:<tt>fun</tt>) &rArr;  nil </b></dt><dd>

 call `fun` on rows (after coercing cell text)

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
the start up actions (and before each run, it resets the random number seed and settings);	
and, finally, returns the number of test failures  to the operating system.	

<dl>
<dt><b> main(options:<tt>tab</tt>, help, funs:<tt>{fun}</tt>) &rArr;  nil </b></dt><dd>

 main program

</dd>
<dt><b> eg(key, str:<tt>str</tt>,  fun:<tt>fun</tt>) &rArr;  nil </b></dt><dd>

 register an example.

</dd>
</dl>





## Example
   
Example input
    
        local _ = " "
        return {
         domain="dissementian platforms",
         cols={   {'DevelopmentTool', 5, 3, 3, 1, 1, 1, 1, 3, 5, 5, 'Application'},
                       {'Multimedia', 2, 1, 1, 5, 5, 5, 5, 5, 1, 2, 'Programming'},
          {'CommunicationTechnology', 1, 3, 1, 3, 2, 5, 4, 3, 1, 1, 'ApplicationTechnology'},
               {'HumanOrientedTool' , 2, 1, 1, 1, 3, 5, 3, 2, 2, 2, 'SystemTool'},
        {'ConventionalCommunication', 1, 5, 3, 4, 1, 1, 4, 5, 4, 4, 'NovelCommunication'},
              {'OnlyActAsProgrammed', 1, 4, 1, 1, 1, 1, 1, 5, 3, 1, 'Semi-autonomous'},
               {'ConventionalSystem', 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 'IntelligentSystem'},
              {'TargetedOnInterface', 1, 1, 1, 1, 1, 5, 5, 5, 3, 3, 'TargetedOnOverallSystem'}},
        rows={                      { _, _, _, _, _, _, _, _, _, 'BroadbandNetworks'},
                                    { _, _, _, _, _, _, _, _, 'InformationHighway'},
                                    { _, _, _, _, _, _, _, 'IntelligentAgents'},
                                    { _, _, _, _, _, _, 'KnowledgeBasedSystems'},
                                    { _, _, _, _, _,  'ObjectOrientedSystems'},
                                    { _, _, _, _,  'CrossPlatformGUIs'},
                                    { _, _, _,  'VisualProgramming'},
                                    { _, _,  'MultimediaAndHypermedia'},
                                    { _, 'VirtualReality'},
                                    {'ElectronicPublishing'}} }
   
1. Cluster attributes to find synonyms.

        Attributes:
        87
        |.. 72
        |.. |.. 34
        |.. |.. |.. f) OnlyActAsProgrammed :: Semi-autonomous
        |.. |.. |.. g) ConventionalSystem :: IntelligentSystem
        |.. |.. 60
        |.. |.. |.. e) ConventionalCommunication :: NovelCommunication
        |.. |.. |.. a) DevelopmentTool :: Application
        |.. 64
        |.. |.. 47
        |.. |.. |.. c) CommunicationTechnology :: ApplicationTechnology
        |.. |.. |.. b) Multimedia :: Programming
        |.. |.. 25
        |.. |.. |.. h) TargetedOnInterface :: TargetedOnOverallSystem
        |.. |.. |.. d) HumanOrientedTool :: SystemTool
        
2. Cluster examples to similarities.

        Examples:
        80
        |.. 63
        |.. |.. 20
        |.. |.. |.. j) BroadbandNetworks :: 
        |.. |.. |.. i) InformationHighway :: 
        |.. |.. 48
        |.. |.. |.. e) CrossPlatformGUIs :: 
        |.. |.. |.. 28
        |.. |.. |.. |.. c) MultimediaAndHypermedia :: 
        |.. |.. |.. |.. a) ElectronicPublishing :: 
        |.. 80
        |.. |.. 48
        |.. |.. |.. d) VisualProgramming :: 
        |.. |.. |.. b) VirtualReality :: 
        |.. |.. 71
        |.. |.. |.. f) ObjectOrientedSystems :: 
        |.. |.. |.. 42
        |.. |.. |.. |.. h) IntelligentAgents :: 
        |.. |.. |.. |.. g) KnowledgeBasedSystems :: 
        
3. Map examples onto a 2-by-2 grid
  
        Place:
        {a                                 b      }
        {                                         }
        {                                         }
        {                                         }
        {                                         }
        {                                         }
        {                                         }
        {                    d c                  }
        {                                         }
        {                  h                      }
        {          e   f                          }
        PASS ✅ on [trees]
