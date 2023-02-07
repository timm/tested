# Optimization Examples

## Case Study (Optimizers in SE)

Tim Menzies, Oussama Elrawas, Jairus Hihn, Martin Feather, Ray Madachy, and Barry Boehm. 2007. 
[The business case for automated software engineering](https://dl.acm.org/doi/pdf/10.1145/1321631.1321676?casa_token=_hz7PruaPH0AAAAA:ajhPJ4iNJ3pi8d8EcAro3CoU0jlFhfVNfJaTWLmMf3MhMv_FMCENhxIzJGGBasqC7-2T_TR2LI73)
In Proceedings of the 22nd IEEE/ACM International Conference on Automated Software Engineering (ASE '07). Association for Computing Machinery, New York, NY, USA, 303–312.

- Lessons from this case study
  - To handle uncertainty, simulate across the variability.
  - Not all variables matter
  - Useful to combine optimizers and data mining
  - Simple often works well
  - This is not how I would do this in 2023

## Simulated Annealing  (1950s)

```python
def SIMULATED-ANNEALING(problem,schedule)
  returns: a solution state
  current ← problem.INITIAL-STATE
  for t = 1 to Tmax do
     T ← schedule(t)  # e.g. T=t
     if T = 0 then return current 
     next ← a randomly selected successor of current  
     ΔE ← VALUE(next) - VALUE(current)  
     if ΔE > 0 then current ← next  
     else current ← next only with probability eΔE/T
  return current
```

## Gentic Algorithms (1980s)
(Why just mutate on example?)

```python
def GENETIC-ALGORITHM(population, FITNESS-FN) 
 returns: an individual  
 inputs:  population, the initial random population of individuals
          FITNESS-FN, a function that measures the fitness of an individual
 repeat   
    population ← [MUTATE(RECOMBINE(SELECT(2, population, FITNESS-FN))) 
                 for i in population]  
  until some individual is fit enough, or enough time has elapsed
  return the best individual in population, according to FITNESS-FN
```

```python
def SELECT(ρ, population, FITNESS-FN) 
  returns: a set of ρ individuals  
  election ← a uniform random sample of 2 * ρ individuals from population
  return the top ρ individuals in selection, ranked by FITNESS-FN
```

```python
def RECOMBINE(x, y)  
  returns:an individual  
  inputs: x,y, parent individuals
  n ← LENGTH(x) 
  crossover ← random integer from 0 to n 
  return APPEND(x[0:crossover], y[crossover: n])
```
## Differential Evolution (1990s)

(Base mutation on an archive of successful candidates.)

<img src="https://esa.github.io/pagmo2/_images/de.png">

- Choose the parameters $\text{NP} \geq 4$, $\text{CR} \in [0,1]$, and $F \in [0,2]$. 
  - $\text{NP}$ =  population size, i.e. the number of candidate agents or "parents"; a typical setting is 10$n$. 
  - $\text{CR} \in [0,1]$ =  called the ''crossover probability'' 
  - $F \in [0,2]$ =  ''differential weight''.
  - Typical settings are $F = 0.8$ and $CR = 0.9$. 
- Create $\text{Gen}=\text{NP}$ individuals at random
- Repeat until a termination criterion is met (e.g. number of iterations performed, or adequate fitness reached):
  - For ${x}\in\text{Gen}$:
    - Pick any  ${a},{b},{c}\in\text{NP}$
    - Pick one attribute index $R$ at random (good idea that at least one part of the old survives to new)
    - $y= \text{copy}(x)$
    - For each independent input attribute $i \in \{1,\ldots,n\}$
      - If $\text{rand}(0,1)<\text{CR}$ or $i=R$ then 
        - $y_i = a_i + F \times (b_i-c_i)$ 
    -  If $y$ better than $x$,  replace ${x}$ in the population with $y$
-  Pick the agent from the population that has the best fitness and return it as the best found candidate solution.
- Traditional DE uses _bdom_ which means often many new things $x$ seem to be the same as old things $y$
  - ye olde DE would add such similar things to $\text{Gen}$, which lead to overgrowth of the generation
  - so some pruning operator was required
  - But why do that? just use Zitzler instead
