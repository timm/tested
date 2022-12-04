 
# alfold.lua
 
![](docs/img/banner.png)      
[Home]() :: [Tutorial]() :: [License]() :: [Issues]() &copy; 2022 Tim Menzies
 
```css
  
alfold.lua (v2.0) LUA to Markdown. Assumes a little Hungarian notation.
(c) 2022 Tim Menzies <timm@ieee.org> BSD-2clause license

Usage: lua readme.lua  [-h] [file1.lua file2.lua ...] > doco.md

Options:
 -h --help Show help 
```
 
> Extract doco from LUA files to Markdown. Assumes a plain Hungarian notation.	
 	
The Little Hungarian Plain or Little Alföld is a plain tectonic	
basin of approximately 8,000 km² shared by Hunary, Slovakia and	
Austria.	
Alfold.lua, on the other hand,  uses a little Hungarian notation	
to document LUA code. In this ALFOLD language, `n`, `s`, `fun`,	
`is`, `t` denotes numbers, strings, functions, booleans and tables	
(respectively).  Also, `s` as a suffix denotes a table of other	
types;  words in UPPERCASE are classes; and instances use lower	
case versions of the classes.	
       	
For example, this file was generated via	
 	
         lua alfold.lua alfold.lua > docs/alfold.md	
 	
## Conventions	
 	
1. Anything after four dashes (`----`) is not included in the output.	
2. Any line starting with two dashes and a space(`-- `( **is** included in the output.	
3. We only show help on public function.	
4. In function argument lists, 2,4 spaces denotes optional,local arguments.	
5. `XXX:new(...)` functions are assumed to be constructors and are reported as `XXX(...)	
6. Public functions are denoted with a  trailing "-->", followed by 	
   return type then some comment text. e.g.<br> 	
   `function fred(s) --> str; Returns `s`, written as a string`<br>   	
   Note the semi-colon. Do not skip it (its important).	
7. In public function arguments, lower case versions of class type 	
   (e.g. `data`) are instances of that type (e.g.  `data` are `DATA` 	
   so `datas` is a list of `DATA` instances).	
8  Built in types are num, str, tab, bool, fun denoted with prefixes `n,s,t,is`	
9. User-defined types are any word starting with two upper case 	
   leading letters is a class; e.g. DATA	
10. Public function arguments have the type hints shown in the following table.	
11. All other variable names can be anything at all.	
 	
What        | Notes                                                                            	
:-----------|:------------------------------------------------------------------	
----        | Anything after three dashes is deleted.	
"-- "       | Any line starting with two dashes and a space is printed to output.	
2 blanks    | 2 blanks denote start of optional arguments 	
4 blanks    | 4 blanks denote start of local arguments   	
n           | prefix for numerics                       	
is          | prefix for booleans                   	
s           | prefix for strings                   	
suffix s    | list of thing (so `sfiles` is list of strings)	
suffix fun  | suffix for functions                                            	
 	
## Some Design Rationale	
  	
Alfold has no third party libraries (so installing it is just a matter of downloading one file).	
   	
A wider range of numbers was considered instead of just `n` (e.g. `p,z,i` for posint, zeroOne, integer 	
respectfully) but on balance, the overhead of those details seemed more than their benefit.	
   	
Version 2 of Alfold stopped using two column tables of signatures and documentation 	
since these did not work so well when browsing Github markdown files on a phone.	
## Guessing types	

<dl>
<dt><b> are.of(s:<tt>str</tt>) &rArr;  ?str </b></dt><dd>   top level, guesses a variable's type </dd>
</dl>

Types are either singular (one thing) or plural (a set of	
things). The naming conventions for plurals is the same as	
singulars, we just add an `s`. E.g. `bools` is a table of	
booleans. and `ns` is a table of `n`umbers.	
Singulars are either `bools`, `fun` (function),	
`n` (number), `s` (string), or `t` (table).	

<dl>
<dt><b> are.bool(s:<tt>str</tt>) &rArr;  ?"bool" </b></dt><dd>  names starting with "is" are booleans </dd>
<dt><b> are.fun(s:<tt>str</tt>) &rArr;  ?"fun" </b></dt><dd>  names ending in "fun" are functions </dd>
<dt><b> are.num(s:<tt>str</tt>) &rArr;  ?"n" </b></dt><dd>  names start with "n" are numbers  </dd>
<dt><b> are.str(s:<tt>str</tt>) &rArr;  ?"s" </b></dt><dd>  names starting with "s" are strings </dd>
<dt><b> are.tbl(s:<tt>str</tt>) &rArr;  ?"tab" </b></dt><dd>  names ending the "s" are tables </dd>
</dl>

## Low-level utilities	

<dl>
<dt><b> hint(s1:<tt>str</tt>, type) &rArr;  str </b></dt><dd>  if we know a type, add to arg (else return arg) </dd>
<dt><b> pretty(s:<tt>str</tt>) &rArr;  str </b></dt><dd>  clean up the signature (no spaces, no local vars) </dd>
<dt><b> optional(s:<tt>str</tt>) &rArr;  str </b></dt><dd>  removes local vars, returns the rest as a string </dd>
<dt><b> lines(sFilename:<tt>str</tt>,  fun:<tt>fun</tt>) &rArr;  nil </b></dt><dd>  call `fun` on csv rows. </dd>
<dt><b> dumpDocStrings() &rArr;  nil </b></dt><dd>  if we have any tbl contents, print them then zap tbl </dd>
</dl>

## Main	

<dl>
<dt><b> comments(line) &rArr;  nil </b></dt><dd>  handle comment lines; but first, handle outstanding docstrings. </dd>
<dt><b> func(fun:<tt>fun</tt>, args:<tt>tab</tt>, returns:<tt>tab</tt>, docstring) &rArr;  nil </b></dt><dd>  handle functions (with docstring). Updates `tbl`. </dd>
<dt><b> code(line) &rArr;  nil </b></dt><dd>  handle code lines. Updates `obj`. </dd>
<dt><b> main(line) &rArr;  nil </b></dt><dd>  handle each line </dd>
</dl>

## Start uo	
