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


# Optimization

Data mining = "what is"; i.e they divide things up. 

Optimization = "what to do" i.e.  tell you where to go.

Optimization problems in life:
- Do the least work for most reward

Essential: you can't always get what you want
- but if you try some time, you just might find, you get what you need

![](/etc/img/build.png)

Optimization problems in SE:
- What is the smallest set of test cases that covers all branches in this program?
- What is the best way to structure the architecture of this system to enhance its maintainability?
- What is the set of requirements that balances software development cost and customer satisfaction?
- What is the best allocation of resources to this software development project?
- What is the best sequence of refactoring steps to apply to this system?
- These topics are explored in the SE _search-based software engineering_[^sbse][^search] community:
  - Using techniques like local search,  tabu search, simulated annealing, genetic algorithms, 
    and   hill climbing.

The great secret:
- all learners need a little (or a lot) of  optimizers:

![](/etc/img/grad.png)![](/etc/img/roc.png)

## Some History Rationality is an Empirical Science

For centuries, philosophers and scientists explored the Platonic goal of total rational decisions. That fell apart when:

- Godel's 1930 incompleteness theorem showed that in any interesting axiomatic system (where "interesting" means "able to at least support integer arithmetic") there exists conclusions that are true, but not reachable from the premises.
- Turing's 1937 work on the halting problem showed that, in the general case, it is not possible to decide beforehand whether or not a computer program is "hard" or "easy" (where "easy" meant "will finish processing some arbitrary input"). More specifically, the halting problem is undecidable over a Turing machine (a general description of all computational processes).

While this sounds like very bad news, it had a curious and profound side effect.
- For Godel and Turing to make their conclusions, they first had to precisely define what it meant to do "computing".
- That definition was precise enough to allow for the construction of the post-WWII new generation of general computers.
- For example, after the war at the Institute for Advanced Studies at Princeton, the engineers designing the next generation of general-purposes computers literally tore apart Turing's books (since they read them so obsessively).

So in a very real sense, the legacy of Turing and Godel's work on "limits to computing" was actually a statement of "how to compute".
- Sure, that computational process had limits but between current human ignorance and those eventual limits lay a very useful middle zone.
- And in that zone, since WWII, we have built UNIX, the Internet, the open source revolution, social and ubiquitous computing, Google, Facebook, Microsoft, etc etc.

One of the first pioneers to use Turing and Godel's work was John Von Neumann.
-  Von Neumann was a towering figure in the history of the 20th century. Apart from his seminal contributions to the mathematics of shaped charges, geometry, measure theory, ergodic theory, operator theory, lattice theory, mathematical formulation of quantum mechanics, quantum logic, game theory, mathematical economics, linear programming, mathematical statistics, fluid dynamics, weather systems, etc, etc, etc, etc he also lead the computer work at Princeton's Institute for Advance Studies.
- He was the one who told his engineers to read Turing in such great detail.
- He was also a great fan of Godel's work. In his book Turing's Cathedral, Geroge Dyson documents the extraordinary efforts of Von Neumann in rescuing Godel from the pre-WWII chaos in Europe (after which, he gave Godel an office two doors down from his at Princeton).

Von Neumann was the one of the first to fully appreciate the engineering implications of Turing and Godel's work. In summary:
-  He realized that thanks to Godel and Turing, rationality had just become an experimental science.
- Given that we cannot guarantee what happens when we fire up a computer program, all we can do is "try it and see" what happens next.

Von Neumann's Princeton group was very successfully in selling this idea to the American government.
- As a result, they had funds to build the computers needed for very large scale "try it and see" studies.
- At the height of their research in the 1950s, they were simulating everything from weather effects to stars to atomic bombs:
  - Stellar evolution: simulating the lifetime of the sun, over $10^{14}$ years;
  - Biological evolution: simulation the human life space, over 30 years;
  - Meteorology: simulating 8 hours of atmospheric effects;
  - Shock waves in ballistic: simulating events that happen in the blink of an eye;
  - Nuclear explosions: simulating events over the lifetime of a neutron in a nuclear explosion (a mere 10^{-8}) seconds).
 
## Methods

When there was very little memory (1950s):
- 1+1 reasoning (one canidate solution and 1 mutant)
- e.g. simulated anneallong:
  - need a way to score $S$ each possibilities
  - repeat for time t=1... N
    -  $m$= mutant = jiggle( current solution $c$) 
    - if S(c) &gt; S(m) then better so, current = mutant
    - else, maybe if (abs(S(m) - S(c))/t < random()) then current = mutatn
      - i.e. initially (when $t$ is small) ,we take chances
      - this is how we escape local maxima
  
<img src="/etc/img/Hill_Climbing_with_Simulated_Annealing.gif" width=600 > 

When there was more memory (1960s):
- m+n rasonong (many candidates and many mutatnts)
- e.g. genetic algorithms
  - given an population $P_i$
  - **mutant** some, a little
  - **crossover** (take two "parents" and combine their bits into a "child)
  - new population = $P_{i+1}$ = **select** (prune worse kids) 
  - Typical parameter: 100 individuls, evloved for 100 generations, 1% mutation rate

![](/etc/img/evolve.png)
Important ideas from this era:
- _domination_ (see 
  [from clustering to otpimization](onCluster.md#from-clustering-to-optimization)
- the external archive


When there was more CPU (1990s)
- stochastic methods
- e.g ISAMP: run ahead with mutants $m_1 \rightarrow m_2 \rightarrow m_3 ...$,
  reset to start when no further progress seen
- e.g.  GSAT
  - given N clauses to satisfiy, makes the change which minimizes the number of unsatisfied clauses 
  - more generally this is called _local search_ 
    -  sometimes mtuate at random
    - other times, do a hill climb on just on variable
    - its like sking: sometimes you ski in any direction
      - other times, you just see what happens if you only go backwards and forwards

When there were more than one or two goals (2000s)
- Frontier reasoning
- 20th century optimization: given N goals, add magic weights and try to change the sum:
  - $\sum_i w_i G__i$
  - problem: results dependent on $w_i$ 
    - so a standard technique in the 20th century was 
## Search-base SE.

Many algorithms: e.g. hill-climbing
- may need "restarts" to avoid local optima (iterative sampling, isamp)

[hillClimb](/etc/img/hill.png)

[^stork]: Stork, J., Eiben, A.E. & Bartz-Beielstein, T. 
  [A new taxonomy of global optimization algorithms](https://link.springer.com/article/10.1007/s11047-020-09820-4)
  Nat Comput 21, 219–242 (2022). https://doi.org/10.1007/s11047-020-09820-4




Local search:
- just mutate one solution to some nearby point
- a useful heuristic 
  - $X$% of the time, mutate an attribute at random
  - Otherwise, take one attribute and pikc best result after running it from min to max (e.g. fixate on "day"
    and try monday,tuesday, wed, thurs, frid, sat, ssun


Global search:
- reflect over all solutions to find a new idea
SBSE seeks to reformulate Software Engineering problems as ‘search problems’
- not to be confused with textual or hypertextual searching
- search problems =one in which optimal or near optimal solutions are sought in a
search space of candidate solutions, guided by a fitness function that distinguishes between better
and worse solutions.

- If we cannot satisfy all goals, we explore trade-offs between them 

    Random-Restart Hill-Climbing
Another way of solving the local maxima problem involves repeated explorations of the problem space. “Random-restart hill-climbing conducts a series of hill-climbing searches from randomly generated initial states, running each until it halts or makes no discernible progress” (Russell & Norvig, 2003).[1] This enables comparison of many optimization trials, and finding a most optimal solution thus becomes a question of using sufficient iterations on the data.


GSAT makes the change which minimizes the number of unsatisfied clauses in the new assignment, or with some probability picks a variable at random.
WalkSAT first picks a clause which is unsatisfied by the current assignment, then flips a variable within that clause. The clause is picked at random among unsatisfied clauses. The variable is picked that will result in the fewest previously satisfied clauses becoming unsatisfied, with some probability of picking one of the variables at random. When picking at random, WalkSAT is guaranteed at least a chance of one out of the number of variables in the clause of fixing a currently incorrect assignment. When picking a guessed-to-be-optimal variable, WalkSAT has to do less calculation than GSAT because it is considering fewer possibilities.
Both algorithms may restart with a new random assignment if no solution has been found for too long, as a way of getting out of local minima of numbers of unsatisfied clauses.

MaxWalkSAT is a variant of WalkSAT designed to solve the weighted satisfiability problem, in which each clause has associated with a weight, and the goal is to find an assignment—one which may or may not satisfy the entire formula—that maximizes the total weight of the clauses satisfied by that assignment.

  (known as satisficing[^simon]).
over time, changed


- rabbits

[^sbse]: Mark Harman and Bryan F. Jones. Search based software engineering. Information and Software
Technology, 43(14):833–839, December 2001.

[^search]: Mark Harman, S. Afshin Mansouri, and Yuanyuan Zhang. 2012. 
           Search-based software engineering: Trends, techniques and applications. ACM Comput. Surv. 45, 1, Article 11 (November 2012), 61 pages. https://doi.org/10.1145/2379776.2379787
           https://bura.brunel.ac.uk/bitstream/2438/8811/2/Fulltext.pdf


[^simon]: From Wikipeda: Satisficing (satisfy + suffice) =  a decision-making strategy or cognitive heuristic.
          Search through available alternatives till an acceptability threshold is met.i
          Introduced by Herbert A. Simon in 1956 to explain the behavior of decision makers
          under circumstances in which an optimal solution cannot be determined. 
          He maintained that many natural problems are characterized by
          computational intractability or a lack of information, 
          both of which preclude the use of mathematical optimization procedures.
          He observed in 
          his Nobel Prize in Economics speech that "decision makers can satisficed
          either by finding optimum solutions for a 
          simplified world, or by finding satisfactory solutions for a more realistic world.
          Neither approach, in general, 
          dominates the other, and both have continued to co-exist in the world of management science".


- rationality as an experimental science

### Problems with Discontinuities

In software, every if and case statement divides internal state space of program into separate regions, each with their own properties.o

- So not one global model, but model(s)

![](/etc/img/discont.png)

### Probems with Constraints

Too many of them ! Competing!

![](/etc/img/fm.png)

In modern product lines, only 1\% or less of randomly generated solutions satisfy known domain constraints

- Hence, we often use Sat-solvers to generated some initial population
- But be warned: SAT solvers do not generate random instances across the while space
  - Their solutions "clump"

### Problems with Local Minima

<img src="/etc/img/moment.gif" width=400 align=right> 
The above code chases down to lower and lower values... which makes this  a greedy search that can get trapped in local minima. 

There are several known solutions to the problem of local minima including

- Add restart-retries. 
  - Restart to a random point and see if you get back to the old solution (if so, it really was the best).
  - _MaxWalkSat_ (MWS) routinely performs dozens of retries.
- Explore a population, not just one thing. 
  - That is, run many times with different starting positions (where as restart-retry only needs memory for one solution, population-based methods exploit cheap memory).
- Add a momentum factor to sail through the local maxima:
  - _Neural  nets_ use such a factor as they adjust their weights
  - _Particle swam optimizers_ (PSO) 
    <img src="/etc/img/pso101.gif" width=400 align=right> 
    - PSO runs (say) 30 "particles"
    - Each particle mutates a solution in a direction determined by 
      - its prior velocity
      - a pull back towards the best solution ever seen by this particle
      - a pull towards the best solution ever seen by any particle
    - So when it finds a better best, it just sails on by 
      - but it might circle back to them
      - kind of like a restart-retry and a population and a momentum approach all rolled into one.
    - Which means it may not find one solution-- but a set of interesting (but slightly different) solutions
- Add some random jiggle to the search.
  - e.g. _simulated annealing_
  - For example, 
    given a current solution  `s` 
    that is  an array of numeric value with mins and maximums of `lo,hi`
    and some score `e=f(s)` (known as the "energy") 
    -  Simulated annealers perturb `p`% of those values to generate a new  solution `sn` with a score of `en` .
    - At a probability `2.7183^(e-en)/t)`  determined  by a temperature  value `t`
      - This algorithm replaces the current solution `s` with `sn`
    - But as `t` "cools", the algorithm becomes a hill climber that only moves to better solutions. 



- tiny memory, slow CPU: SA
- more memory: GA
- more CPU: stochastic methods
- more goals: fornetier methods
- more experience: lamdscape analysis

SA
## Simulated Annealing

In the following simulated annealer, `sb` is the best solution seen so far (with energy `eb`). Also,
this code assumes we want to minimize the scores.

```python
import math,random
r = random.random

def saMutate(s,lo,hi,p,b,f):
  sn=s[:]
  for  i,x in enumerate(sn):
    if p < r(): 
      sn[i] = lo[i] + (hi[i] - lo[i]) * r()
  return sn, f(sn), b + 1

def sa(s0,              # some intial guess; e.g. all rands
       f,               # how we score a solution
       lo,hi,           # attribute i has ranage lo[i]..hi[i] 
       budget=1000,     # how many solutions we will explore
       mutate=saMutate, # how we mutate solutions 
       p=0.2,           # odds of mutate one attribute
       cooling=2):      # controls if we dont jump to worse things
  #--------------------------------------------------------
  s = sb = s0   # s,sb = solution,best
  e = eb = f(s) # e,eb = energy, bestEnergy
  b = 1
  while b < budget:
    sn, en, b = mutate(s,lo,hi,p,b,f)   # next solution
    if en < eb:  # if next better than best
      sb,eb = s,e = sn,en 
    elif en < e: # if next better than last
      s,e = sn,en 
    else:  # maybe jump to a worse solution
      t = b/budget
      if math.exp((e - en)/t) < r()**cooling: 
        s,e = sn,en
  return sb,eb
```
Initially, `t` is large so this algorithm will often jump to sub-optimal solutions. But as things "cool", this algorithm becomes a 
hill climber that just steps up to the next solution. In the following, just to confuse you, we score things by 1-f (so _better_ means _larger_): 



GA
local search
Pareto :nsga-II, moea/d DE
later: SMBO

Aqcusition functionL

![](/etc/img/smbo.png)

hsitory:
- sample
- stochastic
- evolve
- local search
- 
## Landscape Analysis
