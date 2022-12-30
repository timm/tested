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


# Automated SE and Maths (just a little)

Three kinds of attributes:

|operation| NUMeric | SYMbolic | ordinal|
|---------|---------|----------|--------|
| equal, not equal| &check; | &check; | &check;|
| less, greater|  &check;  | 	&#10060; | &check;|
| maths: add,sub, mul, div, exp etc | &check; | &check; |&check;

Each have their measure of _middle_ and _diversity_

|measure| NUMeric | SYMbolic | ordinal|
|---------|---------|----------|--------|
| mid | mean<br>$\mu=\frac{\sum_i}{n}$  | | mode (most frequent value) | mode |
| div |  standard deviation (delta to the mean)<br>$\sigma = \sqrt{\frac{\sum_i(x_i-\mu)^2}{n-1}}$ | entropy (effort to recreate signal) <br>$\sum_i=p_i\times log_2(p_i)$ | ? |


## Theory 


101.md code uses the following theory.


### Sampling  XXX


BEfore all


links to cog psych 


show them the diabtest discretization results


### Normal (Gaussian) Distribution
_Problem:_ summarize a wide range of numeric samples.


_Solution:_ The problem divides in two
- central tendancy (mid = mean or median or mode)
- diversity (div = standard deviation or entropy(for symbols)


        2,2,2,2,2,3,4,4,4,4,10000


The French mathematician Abraham de Moivre [^deMo1718]
  notes that probabilities associated with discretely 
  generated random variables (such as are obtained by flipping a coin or rolling a die) can 
  be approximated by the area under the graph of an exponential function.
This function was generalized by  Laplace[^Lap1812] 
  into the first central limit theorem, which proved that probabilities for almost 
  all independent and identically distributed random variables converge rapidly 
  (with sample size) to the area under an exponential function—that is, to a normal 
  distribution.
This function was extended, extensively by Gaussian. Now its a curve with an area under the curve of one.
  As standard deviation shrinks, the curve spikes upwards.


<p align=center><img align=center src="/etc/img/norm.png" align=right width=600></p>


_Example:_ See [101.lua#NUM](/src/101.lua)
- Also, to quickly sample from a Gaussian with mean `mu` and diversity `sd`


      mu + sd * sqrt(-2*log(random)) * cos(2*pi*random)


- ALso, to quickly withdraw a number `x` from a Gaussian (using the same code as 101.lua) use
  the following (but this gets unstable for `n` under 10 and crashes for `n&lt;2`):


      self. n  = self.n - 1
      d = x - self.mu
      self.mu = self.mu - d / self.n
      self.m2 = self.m2 - d * (x - self.mu)
      self.sd = (self.m2/(self.n-1))^.5 


_Beware:_
Not all things are normal Gaussians. 
<img src="/etc/img/weibull.png" align=right width=300 > If you want to get fancy, you can use Weibull functions
to make a variety of shapes (just by adjusting $\lambda,k$):


<p align=center><img src="/etc/img/weibulleq.png" wdith=300 ></p>


Or you could forget all about parametric assumptions.
Many things get improved by going beyond the Gaussian guess [^dou95]:
Not everything is best represented by a smooth curve with one peek that is symmetrical around that peek:


<img width=400 src="https://github.com/txt/fss17/raw/master/img/notnorm8.png">


To go fully non-parametric, use reservoir sampling (below). Then to sample, grab three numbers $a,b,c$ and use $x=a+f\times(b-c)$ for some small $f$ (say $f=0.1$).


All that said, Gaussians take up far less space and are very easy to update. So all engineers should know their gaussians.


### Regular expressions 
_Problem:_  build "little languages": parsers for short-cut specialized languages


_Solution:_ Regular expressions [^Cox07] [^Thom68] 
<img src="/etc/img/fsm.png" align=right width=400>
are a text form of a state-transition diagram
with some special `accept` state. If some stream of characters can
walk the transitions and arrive at the accept state, then we say
the pattern matches the characters.


_Example:_  see lib.lua#settings' processing of [101.lua#the](/src/101.lua)
 
### Incremental Learning
_Problem:_ learn a summary from an infinite stream of data.


_Solution #1:_ (for symbols): e.g. [101.lua@SYM](/src/101.lua)


_Solution #2:_ (for numerics)
A one-pass Sd via Welford's algorithm [^Welford62] (see [101.lua#NUM](/src/101.lua).
This algorithm is much less prone to loss of 
precision due to catastrophic cancellation, 


_Solution #3:_ (for numerics). See reservoir sampling


### Reservoir Sampling
_Problem:_ Summarize an infinite stream of numbers.


_Solution:_
A reservoir sampling[^ResXX]  is a family of randomized algorithms for randomly choosing k samples from a list of n items,i
where n is either a very large or unknown number. Typically n is large enough that the list does not 
fit into main memory. For example, a list of search queries in Google and Facebook.


Using the reservoir sampler, we can compute standard deviation as follows.
Diversity
can be computed by looking at the difference between large numbers and small numbers in an array.
Lets use that:
- When the reservoir changed, set a flag to `false`.
- When you want the reservoir, sort it and set flag to `true`.
  - overtime, you will sort, less and less 
- We know that
  ±2,2.58,3 standard deviations covers 66,90,95%, 
    <img src="/etc/img/128.png" align=right width=300>
    of the mass.  
- So one standard deviation is (90-10)th divide by 2.58 times σ. 


_Example:_ [SOME](/src/101.lua)


Prob
- Stochastic sampling can tame hard problems (see reservoir sampling and 101.lua@SOME))
- Lehmer [^Lehmer69] (a.k.a. Park-Miller) a pseudorandom number algorithm  for generating 
  a sequence of numbers whose properties approximate the properties of sequences of random numbers. 
  The sequence is not truly random, because it is completely determined by an initial value, 
  called the `seed`. By resetting the seed, the entire "random" sequence can be recreated.
  - Control your seed (or else)
- Fisher Yates shuffle [^Fisher38], randomizing in linear time algorithm for sorting a list of numbers.
  To save memory, it sorts in the same space as the array.
- NUM/SYM middle point is mode/mean
- NUM/SYM div(diversity) is standard deviation or entropy
- Shannon entropy [^Shannon48] <img align=right width=300 src="/etc/img/shannon.png">
  Many ways to define it, but consider it the effort required to recreate a signal.
  Given a bit stream of size `n` and two structures using `n1` then `n2` bits at probability
  $p_1=\frac{n_1}{n}$ and
  $p_2=\frac{n_2}{n}$ and
  we hunt for these via a binary chop, then that effort is
  $$-\sum_i p_i \log_2(p_i)$$


[^Cox07]:      [Regular Expression Matching Can Be Simple And Fast (but is slow in Java, Perl, PHP, Python, Ruby, ...)](https://swtch.com/~rsc/regexp/regexp1.html), 
  Russ Cox rsc@swtch.com, January 2007
[^deMo1718]:   Schneider, Ivor (2005), "Abraham De Moivre, The Doctrine of Chances (1718, 1738, 1756)", 
  in Grattan-Guinness, I. (ed.), Landmark Writings in Western Mathematics 1640–1940, Amsterdam: Elsevier, pp. 105–120, ISBN 0-444-50871-6.
[^dou95]: James Dougherty, Ron Kohavi, and Mehran Sahami. 1995. 
  [Supervised and unsupervised discretization of continuous features](https://ai.stanford.edu/~ronnyk/disc.pdf)
  In Proceedings of the Twelfth International Conference on International Conference 
  on Machine Learning (ICML'95). Morgan Kaufmann Publishers Inc., San Francisco, 
  CA, USA, 194–202.
[^Fisher38]:   Fisher, Ronald A.; Yates, Frank (1948) [1938]. Statistical tables for biological, agricultural and medical research (3rd ed.). 
  London: Oliver & Boyd. pp. 26–27. OCLC 14222135. 
[^Lap1812]:    Pierre-Simon Laplace, Théorie analytique des probabilités 1812, “Analytic Theory of Probability"
[^Lehmer69]:   W. H. Payne; J. R. Rabung; T. P. Bogyo (1969). "Coding the Lehmer pseudo-random number generator" (PDF). 
  Communications of the ACM. 12 (2): 85–86. doi:10.1145/362848.362860
[^ResXX]:      Bad me. I can recall where on the web I found this one.
[^Shannon48]:  Shannon, Claude E. (July 1948). "A Mathematical Theory of Communication". Bell System Technical Journal. 27 (3): 379–423. 
  doi:10.1002/j.1538-7305.1948.tb01338.x. hdl:10338.dmlcz/101429. 
  <a href="https://people.math.harvard.edu/~ctm/home/text/others/shannon/entropy/entropy.pdf">(PDF)</a>
[^Thom68]:     Ken Thompson, “Regular expression search algorithm,” Communications of the ACM 11(6) (June 1968), pp. 419–422. 
  http://doi.acm.org/10.1145/363347.363387 <a href="https://www.oilshell.org/archive/Thompson-1968.pdf">(PDF)</a>
[^Welford62]:  Welford, B. P. (1962). "Note on a method for calculating corrected sums of squares and products". Technometrics. 4 (3): 419–420. doi:10.2307/1266577. JSTOR 1266577.


# On Coding
Idioms for useful code


## NM: numerical methods


- handle missing values, at the lowest level
- no divides without handling div/0
- evaluate things via multiple trials,
  - where training data is differeremt to test data
  - where random number seed in different each trial
- define default seed
- accept seed from command line
- reset seed before each new experiment
- when studying results, compare distributions seen in multiple trials
  - apply both effect size and significance tests
- no magic numbers. all tunetables in a global config var
- keep you intermediaries logs, yo will use them again
- where possible, divide long runs into many shorter section such
  that if some fail, then others can still finish
  - dump log data often, along the way
  - don't wait till the end else you lose a day of commutation by some
    divide by zero error that happens in the 23rd hour.
- show the summary, peek inside 
  - e.g. not just F1 but prec/recall
  - e.g. not ranks of rows, but also some of the raw row data


## LE: Less is More
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


## TE: Test suite
1. Do you have half a dozen tests per person working on the project per week of work?
2. Can all the tests be run in batch?
3. From the command line can you run just one test?
4. If a test fails and crashes, can the rest of the tests still run (hint try:except:)


## SO: Source control
1. Is your code in some version control system?
2. Everyday you write code, does some branch get updated?
3. Is the test suite <a href="https://github.com/timm/tested/actions/workflows/tests.yml">triggered by each new commit</a>?
4. Do you have an automated build system (Make, Ant, Maven, Cargo, Flutter, Elm, etc etc etc) for all the tedious details.
5. Is the build system included in the documentation?


## DI: Data Independence
1. Your internal model is isolated from I/O operations 
   - When reading csv files, conversions  from strings to types happens once, 
     and once only, before data is loaded into your model
   - All my file I/O routines are isolated (in lib.lua#csv)


## DD: Dialog independence
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


# Documentation
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
