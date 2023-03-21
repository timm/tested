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


## Project 


Write a 
multi-objective  
semi-supervised explanation system:
- Multi-objective; i.e. $|Y|>1$
- Semi-supervised; i.e. given $N$ examples, you only have a limited budget
  $B_0 \ll N$ of times you can access the $Y$ values of any one example.
- Explanation (bonus marks): extract some _useful_ succinct summary from the data
  - here, _useful_ means if that summary is applied  to the data, then some 
   $m \ll N$ good examples
    will be selected (and "good" means "has good $Y$ values).

Test your code on these 10 data set for [here](https://gist.github.com/timm/d47b8699d9953eef14d516d6e54e742e) with multiple goals:

data | domain| for more information
-----|-------|----------------------
auto2.csv | car design | https://archive.ics.uci.edu/ml/datasets/auto+mpg
auto93.csv | car design | ditto
china.csv | software project estimation | https://arxiv.org/pdf/1609.05563.pdf#page=5
coc1000.csv | software project estimation | ditto
coc10000.csv | software project estimation | ditto
healthCloseIsses12mths0001-hard.csv | issue close time | hyperparameter optimzation of random forests (from https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.ExtraTreesClassifier.html#sklearn.ensemble.ExtraTreesClassifier)
healthCloseIsses12mths0011-easy.csv | issue close time |
nasa93dem.csv | software effort+detects estimation |
pom.csv   | agile project management |
SSM.csv  | computational physics| See "trimesh" in https://arxiv.org/pdf/1801.02175.pdf#page=2 |
SSN.csv | computational physics |

IMPORTANT NOTE: some of the above data sets are tricky and your optimizations may faial. Welcome to the real world were
nature is unimpressed with the elegance of your algorithms.

As aprt of your report, generate tables (in Lated) that look lke this. Note that following are **made up numbers** and may not be what you get.

```
                   CityMPG+    Class-    HighwayMPG+    Weight-
all                   21         17.7      28             3080
sway1                 31         12.6      33             2055
xpln1                 25         15.1      30             2270
sway2                 33         10.1      37             2090
xpln2                 30         12.1      33             2370
top                   39         8.6       43             2045

                    CityMPG+    Class-    HighwayMPG+    Weight-
all   to all          =          =         =              =
all   to sway1        ≠          ≠         ≠              ≠
all   to sway2        ≠          ≠         ≠              ≠
sway1 to sway2        ≠          ≠         ≠              ≠
sway1  to xpln1       ≠          ≠         ≠              ≠
sway2 to xpln2        ≠          ≠         ≠              ≠
sway1   to top        ≠          ≠         ≠              ≠
```

Note that:
- the top table shows mean results over 20 repeated runs (with different random number seeds)
- the bottom table shows the CONJUNCTION of a effect size test and a significance test  that compares 20 "all" results to 20 results from some other treatment
  - Note the "prudence check": all to all must return "=", by definition
- "all" shows the raw values of all _M_ rows in the data (so in all 20 trails, this will be the same)
- "sway1" show values from the _N_ &lt; _M_ examples found in the leaf cluster found by sway1 (the thing your coded in class).
- "sway2" show values from the _N_ examples found by your better alternative to sway1.
- "xpln1" and "xpln2" shows values found as follows:
  - let the examples  found by sway\*  be the _N_  "best" items
  - let a random sample of all the other data be "rest" (suggestion: pull, say, _3N_ at random of the rest)
  - some rule learner geenerates a model that distinguishes _N_ best from _3N_ rest.
  - those rules are then applied to all _M_ rows (from which, we calcuate the values)
- "all" sorts all _M_ rows (using the Zitzler "better" predicate (from [onCluster](onCluster.md)) then reports values seen in the top _N_ rows.
  - this shows what can happen when you look at all values.
- the "explanation tax" is any loss seen between sway and xplan
  - I expect the explaination tax should be non-zero
  - why? cause sway is free to combine infleucens from multiple attributes while rule learners are often constrained to much simpler knowledge.
    - But that's the price of generating simplistic explanations to complex ideas.
- the "sampling tax" is any loss seen between sway and all
  - I expect the sampling tax should be non-zero
  - Why? cause if you don't look at everything, you might miss somethings
   - But that's the price of taking heuristic peeks at things

Expected Sections of the paper:


|Masters Grade| Phd Grade| Part|
|-----:|------:|----|
|10   | 10   |Intro|
|20   | 20   |Related work: [random projections](https://en.wikipedia.org/wiki/Random_projection), [semi-supervised learning](https://www.molgen.mpg.de/3659531/MITPress--SemiSupervised-Learning.pdf) [why heuristics work](http://library.mpib-berlin.mpg.de/ft/gg/gg_why_2008.pdf)|
|20   | 10   |Methods: (e.g. see section3 of https://arxiv.org/pdf/2112.01598.pdf)<br> here is where you would describe your design of sway2 and xpln2. |
|30   | 20   |Results: tables, figures, every table and figure is discussed in the paper |
|20   | 20   |Discussion, Conclusion, Future work|
|5    | 5    |Bonus : requirements study|
|5    | 5    |Bonus: February study|
|5    | 5    |Bonus : Ablation study|
|5    | 5    |Bonus : HPO study|
|100  | 100  |total|
|+20  |  0   |bonus|


- Introduction 
  - First 4 paras:
    1. Everyone does X
    2. There is a problem with X
    3. We have a novel insight that means that problem might be solvable
    4.  So here's what we did. 
  - Section 1.1 : Structure of this paper
    - List of research questions and a very brief summary of your answers
    - List of overall contributions (the elevator speech, why is this paper is good).
    - Caveats (for this study, we did not explore Z because of Y)
- Related work
  - What every else did in the past
  - Why that is not good enough, for our purposes (i.e. why are we not doing it some old way)
  - What system from past work is state of the art (and will be used in your comparisons)
  - Note: your related work section must:
    - show that you've read around regarding related work
    - demonstrate your understand the multi-objective semi-supervised explanation problem.
    - show that thinking that lead to this new method.
- Methods
  - Algorithms
    - Note: please demonstrate that you actually have a clear understanding of all these methods.
  - Data
    - You need to have to show some understanding of the data being explored. E.g. what is the point of the data, what are its  column names, how do they group, what do they mean. 
      If if is informative, you can list column distrituons e.g. Table3 of [https://arxiv.org/pdf/2008.00612.pdf](https://arxiv.org/pdf/2008.00612.pdf).
  - Performance measures
    - Using all information about $x,y$ variables, rank the data using the Zitzler predicate. Normalize those ranks 1..100
    - Repeat 20 times
      - For some limited budget $B$, guess the top $B$ items of the data.
      - Evaluate all those top $B$ gueses (so the actual number of evaluations is now $2B$).
        - Collect the distritbution of those final $B$ evaluations.
  - Summarization methods
    - better methods have a lower sum of the final $B$.
    - statistical methods, what you selected and why
      - please demonstrate that you understand effect size and significance testing
    - explaining any novel visualizations you will use in your results section (if there are any)
- Results
   - Run with different y-sampling budgets $B_0\in$ (10,25,50,100,200,500...):
     - For different methods 
        - Compare your preferred method
            - to at least one prior state-of-the-art method;
            - to just selection $B_0$ items at random
            - to one of more  human-level sampling process (seeTable1 of Baltes et al.[^ralph])
        - Repeated 20 times (with different random number seeds)
        - Some presentation of median and spread of results over 20 runs 
        - Non-parametric effect size and significance tests
  - Perform a "prudence" study 
    - as sampling size increases, your proposed methods should get better
  - Discussion of your results divided into your research questions.
    - a clear commentary on what worked best
    - if any unusual results, then acknowledge them and comment on them
  - Tables, figures, with best results distinguished from the non-best
- Discussion
  - Threats to Validity
  - Discussion: any bigger picture insights not present in the rest of the text?
  - Future work: what you did not have time to do, what you suggest to do next
- Conclusion
- References


### Bonus marks

#### B1: Perform a _REQUIREMENTS STUDY_
- For 5 humans, run 5 repertory grids studies. 
- Compare the results:
  - against a recursive bi-clustering  of the data plus
    some hierarchical feature selection
  - against results from other humans
  - Is there anyway way the intra-human views (or the view between human an data)
    can be aligned? (HINT: maybe not)
- Include a commentary on your experience with rep grids (any surprises?) 


#### B2: Perform a _FEBRUARY STUDY_ 
Requires an explanation facility, as described above.
- If analysts used budget $B_0$ in January to reach some conclusions, what is learned
   such that this kind of future analysis gets simpler.
- So pretend its February and we have come back to a some similar problem (like what was
      studied in January). Using what was learned in January, can the same task be solved
      with less budget $B_1 < B_0$?


#### B3: Perform an _ABLATION STUDY_
- Given a preferred method $M$ containing two to four main ideas
  - Disable (or change) each one  thing. If anything get worse, declare that thing important.


#### B4: Perform an _HPO study_
- Apply these minimal sampling methods to learning good $Z$ values for a learner
- Your goal should be to compare your minimal sampling methods with some established optimization method.


### Word limit


The following limits exclude references.


- No less that five pages,no more than eight 
- HARD LIMITS:
  - we will not grade after eight pages.
  - we will not read if less than five.
  - we will not read if it is the wrong format (see below)


### How to write


Create an overleaf.com account


- Go to https://www.overleaf.com/gallery/tagged/ieee-official
- Select :IEEE Bare Demo Template for conferences"
  -  https://www.overleaf.com/latex/templates/ieee-bare-demo-template-for-conferences/ypypvwjmvtdf
  -  \docue
- Hit "open as template"
- Add your name and email to list of authors.
- make this line1 of the doc `\documentclass[9pt,technote]{IEEEtran}`
-  Add these lines before `\begin{document}`


         \usepackage[switch]{lineno}
         \linenumbers


[^ralph]: Baltes, S., Ralph, P. Sampling in software engineering research: 
          a critical review and guidelines. Empir Software Eng 27, 94 (2022).
          https://doi.org/10.1007/s10664-021-10072-8
          https://arxiv.org/pdf/2002.07764.pdf
