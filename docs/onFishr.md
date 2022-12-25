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


# To Begin

_"It is our choices, Harry, that show what<br> we truly are, far more than our abilities."_     
-- Albus Percival Wulfric Brian Dumbledore  

<a href="/etc/img/scope2.png"><img width=400 align=right src="/etc/img/scope2.png"></a>
First, astronomers  learn how to grind lens.  Next, they use those
lens to explore the universe.

So, now that SE people know how to match their brackets, it it time
to table our next challenge. How can we help
people use our software tools to better
explore (and change) the world around us?


Our answer is based on an idea from the 1990s[^me96]: 
to test "it", you have to run "it". To say that another way,
a properly
implemented "test" engine is also an "inference" engine.
And if we do it that way, then we have a unified framework
for both testing  and execution.

For example, 
when SE developers explore software, it is called "testing". When
non-developers explore software it is called many things such as
"acceptance testing", "auditing", etc.  By refactoring those two
approaches, and adding in some AI, we can implement a kind of
incremental agile acceptance process where developers, and the
others, can use lessons from past tests to improve subsequent
versions.

[^me96]: [On the Practicality of Abductive Validation](https://d1wqtxts1xzle7.cloudfront.net/1189844/57jb73rfr4wygz2.pdf?1425075060=&response-content-disposition=inline%3B+filename%3DOn_the_Practicality_of_Abductive_Validat.pdf&Expires=1671930452&Signature=BApU0XRhl8BjEdE0UaGjG2xWjopeKj9MaNb~UYbfJIe5gLEfpynx08Usk-5ga~cGh9kRwk6vRPdZ1iRVJeVZO3KJ5oxsFXgcsex~iay0uNQBk-H43EKm5TNKRU5SfXWFs~re9erwkOUT7XvIwWGjdwHPCtZo3AvsAbhdkOcu~GekEPA1Kh9mpra0W4EzSisMmRj1iWld8O3iYrXq16etQ1NVaPsfdCQ-46ck6grkpjdttvE04W2HSowijrAdJAaKssBBHJ5w1AAESVAzpnvMvSDq732Gyre7vDJocjRtgF-DWDJSpFVzx3DXrbSdcxj1Z3rbCEsJQNgY8Fp0Qbffsg__&Key-Pair-Id=APKAJLOHF5GGSLRBV4ZA)
         Menzies, Tim. ECAI. Vol. 96,  1996.

Q1) But wait, is this an AI subject or a SE subject?   
A1) Yes.
AI is software[^me]  and as such it needs engineers who have the
experience needed to revise and refactor and improve it[^mart].

Q2) Is this an AI subject or a requirements engineering subject?    
A2) Yes. Requirements and testing are both iterative processes where we
try to learn the most, using the least samples.

[^me]: T. Menzies, 
       ["The Five Laws of SE for AI"](https://github.com/timm/timm.github.io/blob/master/pdf/20FiveLawsSE4AI.pdf),
       in IEEE Software, 
       vol. 37, no. 1, pp. 81-85, Jan.-Feb. 2020, doi: 10.1109/MS.2019.2954841.<br>

[^mart]:  Silverio Martínez-Fernández, Justus Bogner, Xavier Franch, Marc Oriol, Julien Siebert, Adam Trendowicz, Anna Maria Vollmer, and Stefan Wagner. 2022. 
        [Software Engineering for AI-Based Systems: A Survey](https://dl.acm.org/doi/pdf/10.1145/3487043)
        ACM Trans. Softw. Eng. Methodol. 31, 2, Article 37e (April 2022), 59 pages. https://doi.org/10.1145/3487043

Is all that too complex for you, lets make it simple. Lets go "fishing"., 

## Lets Go "Fishing"
Consider the following tasks:
- What is the same across all of them? 
- What is learned for "February"; i.e.  if we run did an audit in January, then in February,
    what have we learned from January that makes February easier?


    And, assuming we have to repeat these tasks (say) once every month, what
If analysts used budget $B_0$ in January to reach some conclusions, 
You are the captain of a fishing boat.
Your boat has a crew of six. Each day, before you catch
  anything, you waste hours burning expensive fuel traveling between promising
  fishing spots. What  software help you look at the ocean and find the fish faster?

You've need a car for Monday but you aren't really sure what kind
  you like. After a day of going to car yards, and doing a few test
  drives, you buy a car. Can software help you narrow down how many cars you need to look at?

<a href="/etc/img/build.png"><img width=400 align=right src="/etc/img/build.png"></a>
You are an architect trying to design houses with
  a house with lots of light but no glare. You client is a busy (and fussy) person and before
  you show them all the possible designs, can software help you prune them back to an interesting subset?

You are the manager of a software project, with many tricks for running a project.
  Any one project uses just a few of those tricks, but which one to apply?
  Can software  help you learn which tricks are best (and wish to avoid)?

Your software is being assessed by a focus group (a set of stakeholders).
  Your software is complex and this group has limited time to understand
  it and certify that the software is behaving reasonably[^green].

Software analytics learn models from data. Data labels are often incorrect[^tu] and
so they need to be checked before they are used. But data sets can be huge, and relabelling
everything can be so expensive. So can our software tells us what is the least number  of
examples to label?

[^tu]: H. Tu, Z. Yu and T. Menzies, "Better Data Labelling With EMBLEM (and how that Impacts Defect Prediction)," in IEEE Transactions on Software Engineering, vol. 48, no. 1, pp. 278-294, 1 Jan. 2022, doi: 10.1109/TSE.2020.2986415.
https://arxiv.org/pdf/1905.01719.pdf
"We
compare the time required to label commits from 50
projects via EMBLEM of manual means. Assuming we
were paying Mechanical Turk workers to perform that
labelling, then manual labelling would cost $320K and
39,000 hours (assuming pairs of workers per commit,
and a 50% cull rate for quality control). Using EMBLEM,
that same task would cost $40K and 4,940 hours; i.e.
it would be 8 times cheaper."

<a href="/etc/img/fairness.png"><img width=400 align=right src="/etc/img/fairness.png"></a>
A software engineer can't try   options
but after a few experiments, they ship a product. For example:
- Data miners are controlled by billions of hyper-parameter options that control (e.g.)
    the shape of a neural net or how many neighbors your use for classification[^nn].
    These parameters let you trade off (e.g.) how many mistakes you tolerate
    versus how many results you return; or accuracy versus fairness[^cruz21].
- MySQL's Makefile has billions of configurations options, each of
    which means your SQL queries take different times to run and use
    different energy. 

[^cruz21]: A. F.Cruz, P. Saleiro, C. Belém, C. Soares and P. Bizarro, 
      ["Promoting Fairness through Hyperparameter Optimization"](https://arxiv.org/abs/2103.12715)
      2021 IEEE International Conference on Data Mining (ICDM), 2021, pp. 1036-1041, doi: 10.1109/ICDM51629.2021.00119.

[^nn]: <em>class sklearn.neighbors.KNeighborsClassifier(n_neighbors=5, \*,<br> 
weights='uniform', <br>algorithm='auto', <br>leaf_size=30, <br>p=2, <br>metric='minkowski', <br>
metric_params=None,<br> n_jobs=None)¶</em>

## Let's say that another way.

<img width=400 align=right src="/etc/img/2space.png">

We seek  a mapping $F$ such that $Y=F(X)$ where:
- $X$ and $Y$ are sets of decisions and goals
- Often $|X| \gg |Y|$, i.e. there are usually more decisions and goals.
- We might have access to a set of weights $W$ for each $Y$ value;
  e.g. if $W_i<0$ then we might seek solutions that  minimize $Y_i$.
- Under the hood, we might also have $Z$, a set of hyper-parameters
  that control the algorithms that find $F$.
- Finally, there may or may not be some background knowledge $B$ which we can
  use to guide our analysis.

In all the examples above,
it was  cheap to sample $X$ and very, very, very expensive to sample $Y$:
- e.g. describing the ocean is much cheaper than sailing around it all day looking for fish
- e.g. listing the Makefile options within SQL is faster than compiling and testing each one,

Only some  subset of $X$ are observable and/or controllable (or, indeed, relevant to
    the task at hand).

There can be many goals $Y$ and some are  contradictory (e.g. security and availability
    can be mutually exclusive).
- If we cannot satisfy all goals, we explore trade-offs between them 
  (known as satisficing[^simon]).
- And in those cases, sometimes the exploration can be just (or more) 
  insightful than actually getting find an answer.
- Vilfredo Pareto:  <em> Give me the fruitful error any time, full of seeds, 
  bursting with its own corrections. You can keep your sterile truth for yourself.</em>

Historically, in the SE community this is known as _search-based software engineering_
[^search]:
- Which explores issues like:
  - What is the smallest set of test cases that covers all branches in this program?
  - What is the best way to structure the architecture of this system to enhance its maintainability?
  - What is the set of requirements that balances software development cost and customer satisfaction?
  - What is the best allocation of resources to this software development project?
  - What is the best sequence of refactoring steps to apply to this system?
- Using techniques like local search,  tabu search, simulated annealing, genetic algorithms, 
  and   hill climbing.

Having tried many of those, I now prefer
something called "landscape analysis" where  data mining divides up a problem (after
which _optimization_ is just a matter of finding the difference between good and bad divisions).


[^search]: Mark Harman, S. Afshin Mansouri, and Yuanyuan Zhang. 2012. 
           Search-based software engineering: Trends, techniques and applications. ACM Comput. Surv. 45, 1, Article 11 (November 2012), 61 pages. https://doi.org/10.1145/2379776.2379787
           https://bura.brunel.ac.uk/bitstream/2438/8811/2/Fulltext.pdf

### Some Terms 

|What | Notes|
|----:|:------|
|Theorem provers | explores  a set constraints defined in $B$|
| Data miners |   tools for dividing up $X$ and/or $Y$|
| Optimizers |  methods for jumping between better and worse $X$ and/or $Y$ |
| Explanation| tools are methods for generating a useful succinct summary from all that was learned from the theorem provers + optimizers + data miners?  Here, _useful_ means if that summary is applied  to the data, then some $m \ll N$ good examples will be selected (and "good" means "has good $Y$ values).|

### Other Terms

|What | Terms|
|----:|:------|
|supervised inference|  _|Y|&gt;0_  |
| regression | usually, for single numeric goals|
|classification | single symbolic goal|
|Semi-supervised learning|  When  we have many examples but only a small subset have $Y$ values... in which case we can do things like spreading out the available $Y$ values over clusters within the $X$ values.|
| Unsupervised learning |  When we have no $Y$ values... in which case we can do things like _cluster_ the $X$ variables then ask humans people to offer comments on each cluster.  To reduce labeling do a recursive binary clustering of the data down to leaf clusters of size $\sqrt{N}$. Then just label the median point of these $\sqrt{N}$ clusters.|
|Contrast learning | Finding a minimal difference between clusters.
|  Single goal optimization| single goal|
| Multi goal optimization | up to 3 goals|
| Many goal optimization | 4 or more|
|Hyper-parameter optimization| Optimization through $Z,Y$ space|

One way to build optimizers is to: 
- cluster on $X$
- sort each cluster of their average $Y$ values
- generate clusters between clusters with worse and better $Y$ values|

[^many]: Aurora Ramírez, José Raúl Romero, Sebastián Ventura,
A survey of many-objective optimisation in search-based software engineering,
Journal of Systems and Software,
Volume 149,
2019,
Pages 382-395,
ISSN 0164-1212,
https://doi.org/10.1016/j.jss.2018.12.015.
https://www.researchgate.net/publication/329736475_A_survey_of_many-objective_optimisation_in_search-based_software_engineering


## Project 

(Note: you may not understand some parts of the following... yet;  patience, dear reader.)


Using at least 10 data set for [here](https://github.com/timm/tested/tree/main/etc/data)
write a 
multi-objective 
semi-supervised explanation system:
- Multi-objective; i.e. $|Y|>1$
- Semi-supervised; i.e. given $N$ examples, you only have a limited budget
  $B_0 \ll N$ of times you can access the $Y$ values of any one example.
- Explanation (bonus marks): extract some _useful_ succinct summary from the data
  - here, _useful_ means if that summary is applied  to the data, then some 
   $m \ll N$ good examples
    will be selected (and "good" means "has good $Y$ values).



Expected Sections:

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
  - Data
  - Performance measures
  - Summarization methods
    - statistical methods, what you selected and why
      - please demonstrate that you understand effect size and significance testing
    - explaining any novel visualizations you will use in your results section (if there are any)
  - Note: please demonstrate that you actually have a clear understanding of all these methods.
- Results
   - Run with different y-sampling budgets $B_0\in$ (10,25,50,100,200,500...):
     - For different methods 
        - Compare your preferred method
            - to at least one prior state-of-the-art method;
            - to just selection $B_0$ items at random
            - to one of more  human-level sampling process.
              (see  Table1 of Baltes et al.[^ralph])
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
As part of the results section:

- Perform a _REQUIREMENTS STUDY_
  - For 5 humans, run 5 repertory grids studies. 
  - Compare the results:
    - against a recursive bi-clustering  of the data plus
      some hierarchical feature selection
    - against results from other humans
    - Is there anyway way the intra-human views (or the view between human an data)
      can be aligned? 
- Perform a _FEBRUARY STUDY_ (requires an explanation facility, as described above)
  - If analysts used budget $B_0$ in January to reach some conclusions, what is learned
     such that this kind of future analysis gets simpler.
  - So pretend its February and we have come back to a some similar problem (like what was
        studied in January). Using what was learned in January, can the same task be solved
        with less budget $B_1 < B_0$?
- Perform an _ABLATION STUDY_:
  - Given a preferred method $M$ containing two to four main ideas
    - Disable (or change) each one  thing. If anything get worse, declare that thing important.
- Perform an HPO XXX

### Word limit

The following limits exclude references.

- No less that five pages 
  - no more than eight 
- HARD LIMITS:
  - we will not grade after eight pages.
  - we will not read if less than five.
  - we will not read if it is the wrong format (see below)

### How to write

Create an overleaf.com account

- Go to https://www.overleaf.com/gallery/tagged/ieee-official
- Select :IEEE Bare Demo Template for conferences"
  -  https://www.overleaf.com/latex/templates/ieee-bare-demo-template-for-conferences/ypypvwjmvtdf
- Hit "open as template"
- Add your name and email to list of authors.
-  Add these lines before `\begin{document}`

         \usepackage[switch]{lineno}
         \linenumbers


[^ralph]: Baltes, S., Ralph, P. Sampling in software engineering research: 
          a critical review and guidelines. Empir Software Eng 27, 94 (2022).
          https://doi.org/10.1007/s10664-021-10072-8
          https://arxiv.org/pdf/2002.07764.pdf

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

[^green]: Ben Green warns that many recent policies require 
          humans-in-the-loop to review or audit decisions from
          software model. People
          (including experts) are susceptible to “automation bias” (involving
          omission errors) failing to take action because the automated
          system did not provide an alert—and commission error. These
          omissions
          means that oversight policies can lead to the reverse of their
          desired effect by “legitimizing the use of faulty and controversial 
          algorithms without addressing (their fundamental issues)" 
          B. Green, [“The flaws of policies requiring human oversight of government algorithms,”](https://arxiv.org/pdf/2109.05067.pdf) 
          Computer Law & Security Review, vol. 45, p. 105681, 2022.


