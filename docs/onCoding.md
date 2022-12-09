<p>
&nbsp;
<a name=top></a>
<p>
<table><tr>
<td><a href="/README.md#top">Home</a>
<td><a href="http:github.com/timm/tested/issues">issues</a>
</tr></table>
<img  align=center width=600 src="/docs/img/banner.png"><br clear=all>
<a href="/LICENSE.md">&copy;2022,2023</a> by <a href="http://menzies.us">Tim Menzies</a>
</p>


# On Coding

Idioms for useful code


## LIM: Less is More
1. Most functions are v.short

## FP: Functional programming

> "first-class values":  a function is a value 
with the same rights as conventional values like numbers and strings. 
    Functions can be stored in variables (both global and local) and in tables, 
    and can be passed as arguments, and can be returned by other functions.

1. Useful for defining a test library (see  101.lua#eg)
2. Useful for callbacks (see lib.lua#csv). 
3. Useful for collecting results of an iteration (see lib.lub#map in lib.lua#o)
4. Writing function that return functions (see lib.lua#lt)

## Te: Test suite
1. Do you have half a dozen tests per person working on the project per week of work?
2. Can all the tests be run in batch?
3. From the command line can you run just one test?
4. If a test fails and crashes, can the rest of the tests still run (hint try:except:)

### DbI: Data Independence

1. Your internal model is isolated from I/O operations 
   - When reading csv files, conversions  from strings to types happens once, 
     and once only, before data is loaded into your model
   - All my file I/O routines are isolated (in lib.lua#csv)

## DI: Dialog independence

1. In the guts of your code, no direct writes to "print" but rather to some `log` function that may or may not write to the screen.
2. Can you turn off all logging (no log string generation, nothing logged/printed anywhere)?

## Ab: Abstraction
1. Using try:catch, try:except, (Lua) pcall,
  - See `pcall` in `run1`
2. You writing your own iterators ? 
  - e.g. lib.lua#csv calls `fun` for every row in a csv file

## OO: Object-oriented programming

1. Are you using polymorphism? (same name, different methods);
2. Are you using inheritance (consider doing less of that)?
  - [Hatton98](http://www.cs.kent.edu/~jmaletic/cs69995-PC/papers/Hatton98.pdf)
  - [Jabangwe14](https://www.wohlin.eu/emse14b.pdf)
  - [Al Dallal18](https://www.computer.org/csdl/journal/ts/2018/01/07833023/13rRUwkxc76)
  - [Stop Writing Classes](https://www.youtube.com/watch?v=o9pEzgHorH0)
3. Do your objects have customized create function? (e.g. 101.lua#SYM:add)
4. Do your objects have customized sort functions? (e.g. Lua __lt)
5. Do your objects have customized print functions (e.g. Lua __tostring)

## DSL DSL
1. Refactoring, on steroids.
2. Common processing, rewritten as a massive shortcuts
  - e.g. regular expressions
    - see lib.lua#settings' processing of 101.lua#the
  - e.g. help string to options 101.lua#settings

## Pa: Packaging
1. N-1 globals better than N.
2. What are you exporting?
   - See [Python tips](https://stackoverflow.com/questions/26813545/how-to-structure-a-python-module-to-limit-exported-symbols)
3. Are you using nested functions (to  hide or  clarify tedious details)
   - e.g. lib.lua#'function want'.

## Sh: Sharing
1. Code released under some license that enables sharing.
2. Project has a web site.
   - Note: my "web" site is markdown files that share the first para of "/README.md"
   - So my web site "build" system is about 10 lines of code in "/Makefile"
3. Repo includes test data, documentation, test suite results.
   - e.g. for Python pydoc and [sublime](https://menzies.us/sublime/sublime.html)
   - e.g. for Lua, [ldoc](https://stevedonovan.github.io/ldoc/manual/doc.md.html)
   - e.g. for Lua, [alfold](https://github.com/timm/tested/blob/main/docs/alfold.md)
4. Code routinely explored by  static code analysis tools (which can be very  simple e.g. 
    syntastic or very complex and slow to run e.g. your model checker of choice)?
5. Code follow standard formatting conventions:
   - e.g. Python Flake8 is a popular lint wrapper for python. Under the hood, 
     runs the `pep8` style checker,
     `pyflakes` for checking syntax,
     `mccabe` for checking complexity
6. Does your code support short release cycles 
   (no standard test is slow, really slow things are explored for optimization)
7. Does your code have zero internal boundaries 
   (e.g. everyone uses same tools, config files for those tools in repo)


# Source control
- Is your code in some version control system?
- Everyday you write code, does some branch get updated?
- Is the test suite triggered by each new commit? 
- Do you have an automated build system (Make, Ant, Maven, Cargo, Flutter, Elm, etc etc etc) for all the tedious details.
- Is the build system included in the documentation?

## Documentation
- Do you have (at least) your public functions and classes documented?
- Can you generate doco from comments and type hints in the source code?
- Does your code follow any well-known patterns? Does the doco mention those patterns?

## Settings
- Do you have settings global?
- Can the settings be changed from the command line?
- From the command line, can you get a print of the help text?
- From the command line, you set the random number seed?

## Packages/Modules
- In your package, have you tried using fewer globals?
- Does your code pollute the global space?
- Does your package return a subset of the code in your package?


## Pipes
- Can you accept input from standard input?
- Are your errors written to standard error?
- Is your default output to standard out?

## Reuse
- Have you used your functions/objects for at least three different purposes? (e.g. NB, NN, DT all need DATA, NUM, SYM, etc)


## Simulation

- As above: Can you turn off all logging (no log string generation, nothing logged anywhere)?
- Does your code store its random number seed?
- Are your random numbers reset to the seed before each run? 

## TDD

- red
- green
- refactor
  - rule of three
  - YAGNI 
  - forever stunned at how small is the useful core of larger systems
  - the need for smalller code
- tests in different files

beyond standard testing (other testing)
