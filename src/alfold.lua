if arg[1]=="-h" or arg[1]=="--help" then os.exit(print[[
  
alfold.lua (v2.0) LUA to Markdown. Assumes a little Hungarian notation.
(c) 2022 Tim Menzies <timm@ieee.org> BSD-2clause license

Usage: lua readme.lua  [-h] [file1.lua file2.lua ...] > doco.md

Options:
 -h --help Show help ]]) end

-- > Extract doco from LUA files to Markdown. Assumes a plain Hungarian notation.
--  
-- The Little Hungarian Plain or Little Alföld is a plain tectonic
-- basin of approximately 8,000 km² shared by Hunary, Slovakia and
-- Austria.
--   
-- Alfold.lua, on the other hand,  is  a plain little Hungarian notation
-- for documenting LUA code. Lines of comments get rendered using Markdown.
-- Arguments of public functions are typed using  `n`, `s`, `fun`,
-- `is`, `t` for numbers, strings, functions, booleans and tables
-- (respectively).  Also, `s` as a suffix denotes a table of other
-- types;  words in UPPERCASE are classes; and instances use lower
-- case versions of the classes.
--        
-- For example, this file was generated via
--  
--      lua alfold.lua alfold.lua > docs/alfold.md
--  
-- ## Conventions
--  
-- 1. Anything after four dashes (`----`) is not included in the output.
-- 2. Any line starting with two dashes and a space(`-- `( **is** included in the output.
-- 3. Public functions are denoted with a  trailing "-->", followed by 
--    return type then some comment text. e.g.<br> 
--    `function fred(s) --> str; Returns `s`, written as a string`<br>   
--    Note the semi-colon. Do not skip it (its important).
-- 4. Alfond only show help on public function.
-- 5. In public function argument lists
--     - 2,4 spaces denotes optional,local arguments.
--     - In public function arguments, lower case versions of class type 
--       (e.g. `data`) are instances of that type (e.g.  `data` are `DATA` 
--       so `datas` is a list of `DATA` instances).
--     - Built in types are num, str, tab, bool, fun denoted with prefixes `n,s,t,is`
--     - User-defined types are any word starting with two upper case 
--       leading letters is a class; e.g. DATA
-- 6. Any other local variable, or arguments to other functions, can be anything at all.
-- 7. `XXX:new(...)` functions are assumed to be constructors and are reported as `XXX(...)
--  
-- Summary of type hints (applies only to public functions):
--  
-- What        | Notes                                                                            
-- :-----------|:------------------------------------------------------------------
-- ----        | Anything after three dashes is deleted.
-- "-- "       | Any line starting with two dashes and a space is printed to output.
-- 2 blanks    | 2 blanks denote start of optional arguments 
-- 4 blanks    | 4 blanks denote start of local arguments   
-- n           | prefix for numerics                       
-- is          | prefix for booleans                   
-- s           | prefix for strings                   
-- suffix s    | list of thing (so `sfiles` is list of strings)
-- suffix fun  | suffix for functions                                            
--  
-- ## Some Design Rationale
--   
-- Alfold has no third party libraries (so installing it is just a matter of downloading one file).
--    
-- A wider range of numbers was considered instead of just `n` (e.g. `p,z,i` for posint, zeroOne, integer 
-- respectfully) but on balance, the overhead of those details seemed more than their benefit.
--    
-- Version 2 of Alfold stopped using two column tables of signatures and documentation 
-- since these did not work so well when browsing Github markdown files on a phone.
--
--------------------------------------------------------------------------------
local tbl= {} -- table of contents. dumped  (then reset) before every new heading
local obj= {} -- upper case class names
local are = {} -- type hint rules

-- ## Guessing types

function are.of(s)  --> ?str;  top level, guesses a variable's type
  return are.plural(s) or are.singular(s) end

-- Types are either singular (one thing) or plural (a set of
-- things). The naming conventions for plurals is the same as
-- singulars, we just add an `s`. E.g. `bools` is a table of
-- booleans. and `ns` is a table of `n`umbers.
function are.plural(s) 
  if #s>1 and s:sub(#s)=="s"  then  
    local what = are.singular(s:sub(1,#s-1))
    return what and "{"..what.."}"  or "tab" end end

function are.singular(s) 
  return obj[s] or are.str(s) or are.num(s) or are.tbl(s) or are.bool(s) or are.fun(s) end

-- Singulars are either `bools`, `fun` (function),
-- `n` (number), `s` (string), or `t` (table).
function are.bool(s) --> ?"bool"; names starting with "is" are booleans
  if s:sub(1,2)=="is"     then return "bool" end end
function are.fun(s)  --> ?"fun"; names ending in "fun" are functions
  if s:sub(#s - 2)=="fun" then return "fun" end end
function are.num(s) --> ?"n"; names start with "n" are numbers 
  if s:sub(1,1)=="n"      then return "num" end end
function are.str(s) --> ?"s"; names starting with "s" are strings
 if s:sub(1,1)=="s"      then return "str"  end end
function are.tbl(s) --> ?"tab"; names ending the "s" are tables
 if s=="t"               then return "tab" end end

--------------------------------------------------------------------------------
-- ## Low-level utilities
local dumpDocStrings,optimal,pretty,lines

function hint(s1,type) --> str; if we know a type, add to arg (else return arg)
    return type and s1..":<tt>"..type .. "</tt>" or s1 end

function pretty(s) --> str; clean up the signature (no spaces, no local vars)
  return s:gsub("    .*",     "")
          :gsub(":new()",     "")
          :gsub("([^, \t]+)", function(s1) return hint(s1,are.of(s1)) end) end

function optional(s) --> str; removes local vars, returns the rest as a string
  local after,t = "",{}
  for s1 in s:gmatch("([^,]+)") do 
      if s1:find"  " then after="?" end
      t[1+#t] = s1:gsub("[%s]*$",after) end
  return table.concat(t,", ") end

function lines(sFilename, fun) --> nil; call `fun` on csv rows.
  local src  = io.input(sFilename)
  while true do
    local s = io.read()
    if s then fun(s) else return io.close(src) end end end

function dumpDocStrings() --> nil; if we have any tbl contents, print them then zap tbl
  if #tbl>0 then
    print("\n<dl>")
    for _,two in pairs(tbl) do 
      print("<dt><b> "..two[1].." </b></dt><dd>\n\n".. two[2] .."\n\n</dd>") end 
    print"</dl>\n" end
  tbl={} end 

-- ## Main
local code, func, comments, main
function comments(line) --> nil; handle comment lines; but first, handle outstanding docstrings.
  line:gsub("^[-][-][%s]*([^\n]+)", 
         function(x) dumpDocStrings(); print(x:gsub("^[-][-][-][-][-].*",""),"") end)  end

function func(fun,args,returns,docstring) --> nil; handle functions (with docstring). Updates `tbl`.
  tbl[1+#tbl] = {fun..'('..optional(pretty(args))..') &rArr; '..returns..'', docstring}  end

function code(line) --> nil; handle code lines. Updates `obj`.
  line:gsub("[A-Z][A-Z]+", function(x) obj[x:lower()]=x end)
  line:gsub("^function[%s]+([^(]+)[(]([^)]*).*[-][-][>]([^;]+);(.*)", func) end

function main(line) --> nil; handle each line
  if line:find"^[-][-] " then comments(line) else code(line) end end

--- Start-up
for _,file in ipairs(arg) do lines(file,main) end
dumpDocStrings() -- final dump to catch any finally pending docstrigns
