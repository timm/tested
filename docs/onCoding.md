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

## FP: Functional programming

> "first-class values":  a function is a value 
with the same rights as conventional values like numbers and strings. 
    Functions can be stored in variables (both global and local) and in tables, 
    and can be passed as arguments, and can be returned by other functions.

1. Useful for defining a test library (see  101.lua#eg)
2. Useful for callbacks (see lib.lua#csv). 
3. Useful for collecting results of an iteration (see lib.lub#map in lib.lua#o)
4. Writing function that return functions (see lib.lua#lt)

## DbI: Data Independence

1. Your internal model is isolated from I/O operations 
   - When reading csv files, conversions  from strings to types happens once, 
     and once only, before data is loaded into your model
   - All my file I/O routines are isolated (in lib.lua#csv)

## DI: Dialog independence

- In the guts of your code, no direct writes to "print" but rather to some `log` function that may or may not write to the screen.
- Can you turn off all logging (no log string generation, nothing logged/printed anywhere)?

## Ab: Abstraction
- Using try:catch, try:except, (Lua) pcall,
  - See `pcall` in `run1`
- You writing your own iterators ? 
  - e.g. lib.lua#csv calls `fun` for every row in a csv file

## OO: Object-oriented programming

- Are you using polymorphism? (same name, different methods);
- Are you using inheritance (consider doing less of that)?
  - [Hatton98](http://www.cs.kent.edu/~jmaletic/cs69995-PC/papers/Hatton98.pdf)
  - [Jabangwe14](https://www.wohlin.eu/emse14b.pdf)
  - [Al Dallal18](https://www.computer.org/csdl/journal/ts/2018/01/07833023/13rRUwkxc76)
  - [Stop Writing Classes](https://www.youtube.com/watch?v=o9pEzgHorH0)
- Do your objects have customized create function? (e.g. 101.lua#SYM:add)
- Do your objects have customized sort functions? (e.g. Lua __lt)
- Do your objects have customized print functions (e.g. Lua __tostring)

## DSL
- Refactoring, on steroids.
- Common processing, rewritten as a massive shortcuts
  - e.g. regular expressions
    - see lib.lua#settings' processing of 101.lua#the
  - e.g. help string to options 101.lua#settings

- usig existing DSLs (regular expresions, build systems)
- do you write your own (docstring==> CLI)

# Packaging

## XXX sharing
- Is your code under some license that enables sharing?
- Does your project have a web site?
- Does your web site include test data, documentation, test suite results?
- Is your code routinely explored by  static code analysis tools (which can be very  simple e.g. syntastic or very complex and slow to run e.g. your model checker of choice)?
- Does your code follow standard formatting conventions?
- Does your code support short release cycles (no standard test is slow, really slow things are explored for optimization)
- Does your code have zero internal boundaries (e.g. everyone uses same tools, config files for those tools in repo)


## Test suite
- Do you have half a dozen tests per person working on the project per week of work?
- Can all the tests be run in batch?
- From the command line can you run just one test?
- If a test fails and crashes, can the rest of the tests still run (hint try:except:)

## Source control
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
- tests in different files

beyond standard testing (other testing)
