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
 	
1. Lines with Markdown start with `-- ` (and  we will print those).	
2. We only show help on public function.	
3. Public functions are denoted with a  trailing "-->", followed by 	
   return type then some comment text. e.g.<br> 	
   `function fred(s) --> str; Returns `s`, written as a string`<br>   	
   Note the semi-colon. Do not skip it (its important).	
4. In public function arguments, lower case versions of class type 	
   (e.g. `data`) are instances of that type (e.g.  `data` are `DATA` 	
   so `datas` is a list of `DATA` instances).	
5  Built in types are num, str, tab, bool, fun	
6. User-defined types are ny word starting with two upper case 	
   leading letters is a class; e.g. DATA	
7. Public function arguments have the following type hints:	
   	
What        | Notes                                                                            	
:-----------|:--------------------------------------------	
2 blanks    | 2 blanks denote start of optional arguments 	
4 blanks    | 4 blanks denote start of local arguments   	
n           | prefix for numerics                       	
is          | prefix for booleans                   	
s           | prefix for strings                   	
suffix s    | list of thing (so `sfiles` is list of strings)	
suffix fun  | suffix for functions                                            	
  	
## Guessing types	

<dl>
<dt><b> are.of(s:`str`) &rArr;  ?str </b></dt><dd>   top level, guesses a variable's type </dd>
</dl>

Types are either singular (one thing) or plural (a set of	
things). The naming conventions for plurals is the same as	
singulars, we just add an `s`. E.g. `bools` is a table of	
booleans. and `ns` is a table of `n`umbers.	
Singulars are either `bools`, `fun` (function),	
`n` (number), `s` (string), or `t` (table).	

<dl>
<dt><b> are.bool(s:`str`) &rArr;  ?"bool" </b></dt><dd>  names starting with "is" are booleans </dd>
<dt><b> are.fun(s:`str`) &rArr;  ?"fun" </b></dt><dd>  names ending in "fun" are functions </dd>
<dt><b> are.num(s:`str`) &rArr;  ?"n" </b></dt><dd>  names start with "n" are numbers  </dd>
<dt><b> are.str(s:`str`) &rArr;  ?"s" </b></dt><dd>  names starting with "s" are strings </dd>
<dt><b> are.tbl(s:`str`) &rArr;  ?"tab" </b></dt><dd>  names ending the "s" are tables </dd>
</dl>

## Low-level utilities	

<dl>
<dt><b> hint(s1:`str`, type) &rArr;  str </b></dt><dd>  if we know a type, add to arg (else return arg) </dd>
<dt><b> pretty(s:`str`) &rArr;  str </b></dt><dd>  clean up the signature (no spaces, no local vars) </dd>
<dt><b> optional(s:`str`) &rArr;  str </b></dt><dd>  removes local vars, returns the rest as a string </dd>
<dt><b> lines(sFilename:`str`,  fun:`fun`) &rArr;  nil </b></dt><dd>  call `fun` on csv rows. </dd>
<dt><b> dump() &rArr;  nil </b></dt><dd>  if we have any tbl contents, print them then zap tbl </dd>
</dl>

## Main	

<dl>
<dt><b> main(sFiles:`{str}`) &rArr;  nil </b></dt><dd>  for all lines on command line, print doco to standard output </dd>
</dl>

