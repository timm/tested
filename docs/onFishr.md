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


# Automated Software Engineering, Stakeholder Testing, and  "Fishing"

XXX ungood good
- options, clster then do more
- tarantual optipns
- entropy pruning of the wights
- huebrs 16m spalsh let and right
- dont use ygap, but use the detal computed by zitlzer
- dont use zitzler ever, use ygap  instead
- and more

Definition: "Stakeholders"  are individuals or organizations having
  a right, share, claim, or interest in a system or in its possession
  of characteristics that meet their needs and expectations 
  [(ISO/IEC/IEEE
  2015)](https://www.iso.org/standard/63711.html).


## What is  Stakeholder Testing?
To forge an effective partnership, humans and artificial intelligence (AI) need to understand each other's strengths and limitations. 
- Software can explore a very large space, on pre-determined criteria. 
- Humans can offer novel insight, but only over a small number of examples. 

We conjecture, that when combined,
both can find better solutions than if either
worked
separately.

This is important since there are too many examples  of deplorable software models being fielded
For example, chapter six of Safiya Noble’s book Algorithms of Oppression [^noble] 
tells the sad tale of  how a design quirk of  Yelp ruined a small business:
- As one of Noble’s interviewees put it "Black people don’t ‘check in’ and let people know where they’re at when they sit in my (hair dressing salon). 
  They already feel like they are being hunted;  they aren't going to tell the Man where they are". 
- Hence, that salon fell in the Yelp ratings (losing customers) since its patrons rarely  pressed the   “checked-in”  button. 

There are too many 
other examples where software engineers fielded AI models, without noticing biases in those models:

- Amazon had to scrap an automated recruiting tool as it 
  was found to be [biased against women](https://reut.rs/2Od9fPr).
- A widely used face recognition software was found to be biased against 
  [dark-skinned women](https://news.mit.edu/2018/study-finds-gender-skin-type-bias-artificial-intelligence-systems-0212) and
  [dark-skinned men](https://www.nytimes.com/2020/06/24/technology/facial-recognition-arrest.html).
- Google Translate, the most popular translation engine in the world, 
  [shows gender bias](https://science.sciencemag.org/content/356/6334/183). 
  “She is an engineer, 
  He is a nurse” is translated into Turkish and then again into English becomes “He is an engineer, She is a nurse” [5].  

For our purposes, the  important point of the first Noble example
is this:
- if software designers had been more intentional about
soliciting feedback from the Black community...
- then they could have
changed how check-ins are weighted in the overall Yelp rating system.

As to the other examples, in each case there was some discriminatory
effect which was easy to detect and repair [^joy]], but developers
just failed to test for those biases.

There is a solution to all these problems
- if a small group of
people build software for the larger community
- they need to listen
more to the  concerns of the larger community. 

For that to work,
the smaller group of developers have to admit the larger group into
their design processes– either via
- changing the reward structures
  such that there are inducements for the few to listen to the many
  (e.g. by better government legislation or  professional standards);
  or 
- inclusion practices that admits the broader community into
  the developer community, or by 
- review practices where the
  developers can take better and faster feedback from the community.

To say that another way,  from an ethical perspective, it is good
practice to give software to stakeholders and let them try to break
it. 

[^noble]: Noble, Safiya Umoja. "Algorithms of oppression." Algorithms of Oppression. New York University Press, 2018.
[^joy]: Chakraborty, Joymallya, Suvodeep Majumder, and Tim Menzies. "Bias in machine learning software: why? how? what to do?." Foundations of Software Engineering, 2021

Lets call that "stakeholder testing".

## What is Special about "Stakeholder Testing"

<img src="https://www.fg-a.com/fishing/ice-fishing-polar.jpg"
     align=right width=300>

Consider the polar bear
- above the ice, she can see for miles
  - where the other bears are fishing
  - where the ice is cracking (due to patches of heat)
  - where there are the islands poking through the ice
  - where are the holes from yesterday,
  - etc
- but below the ice
  - she has zero disability below the ice
- problem: she only has the strength to bash a few holes in the ice per day
  - so she must bash  a few holes, learning what she can
    along the way, trying to to make her next guess (about where
    to bash) better.

More generally, let us say that "fishing" (aka stakeholder testing) is that process
of prioritizing many things, without knowing too much about every thing.

And this needs some human-scale "stakeholder testing"[^stake]
- given columns divided into `i.y` goals and `i.x` other columns
- you can look around all the `i.x`  columns
- but you can only look  at a few `i.y` columns 

Technically speaking, this is a kind of acceptance testing, with some
added requirements:

|What | Notes|
|-----|------|
|Optimizing| High-level stakeholders do not hunt bugs for fun... they really are seeking ways to avoid those bugs.  So we need to learn the gradients along which the system can slip, and how to nudge the system along those gradients to places of better behavior
|Multi-objective reasoning| Stakeholders often have competing goals (e.g. "better" and "faster" and "cheaper").|
|Black-box| Most systems are so complex that it is hard to reason about their interior processing. Hence, we try to learn what we can from the input,output behaviour|
|XAI (explainable AI))| Stakeholders are  often done by non-technicals (e.g. representatives from the broader user community) so they seek a "big picture overview" rather than lots of details.|
|Model-based| between this audit and the next, we need some way to continue testing the system (so we can check if the system has gone off the rails and needs  an emergency set of new acceptance tests). So there has to be some product from the acceptance testing that can be applied while we wait for the next acceptance test. |
|Semi-supervised learning| These tests often has a limited budget.| 


Further to the last point, why do we say We also know that this kind of testing often goes awry.
stakeholders want to complete their testing   in a parsimonious manner since they can get back to 
everything else that needs their attention. Hence we must not demand outputs for _every_ possible input, just some of the inputs.|

Stackholder testing:
- Knowledge elicitation techniques like
  repertory grids take a while to complete; e.g.
  up to an hour for two people to discuss, in detail,
  the differences between 10 examples described in 10 attributes.
- Valerdi [^val11] once recruited 40 experts to three panel
  sessions to review an effort model. Each panel took three hours so,
  on total, this study required 3 × 3 × 40/7.5 = 48 days to complete.
  He offers the heuristic that training data needs 5 to 10
  examples per column; i.e., the fewer the columns, the less is
  required for calibration. 
- Brendon Murphy
  [^mur12] from Microsoft  comments that the high cost of
  interpretation implies that there is never enough time to review
  all the defect data or all the models generated by the data miners.
  Hence, he is very interested in methods that reduce the number of
  columns and rows of data that need to be discussed with users.

[^briand22]: Autonomous Systems: How to address the Dilemma between Autonomy and Safety
  Keynote, ASE'22, Lionel Briand
  https://conf.researchr.org/info/ase-2022/keynotes


[^howto]: How to use a repertory grid
  https://www.emeraldgrouppublishing.com/how-to/observation/use-a-repertory-grid

[^val11]: R. Valerdi
  Heuristics for systems engineering cost estimation
  IEEE Syst J, 5 (1) (2011), pp. 91-98

[^mur12]: B. Murphy
  The difficulties of building generic reliability models for software
  Empir Softw Eng, 17 (2012), pp. 18-22


Enabling stakeholder testing
is important.


to explore all the important potential behaviors of a software model is an open and important  issue.
In
``Flaws of policies of requiring human oversight''~\cite{green2022flaws},
Ben Green notes that many recent policies      require humans-in-the-loop to review or   audit   decisions from software models.
E.g. the  manual of the
(in)famous  COMPAS model (see Table~\ref{tbl:sigh}) notes the algorithm can make mistakes and advises that
``staff should be encouraged to use their professional judgment and override the computed risk as appropriate''~\cite{northe15}.

Cognitive theory~\cite{simon1956rational} tells us that
  humans  use heuristic ``cues'' that lead them to the most important parts
of a model before moving on to their next
task. But when humans review models, they can miss important details. Such cues are essential if humans are to tackle
their busy workloads. That said,  using cues can introduce errors:
   {\em
   ...people (including experts) are susceptible to ``automation bias'' (involving)  omission errors—failing to take action because the automated system did not provide an alert—and commission error}~\cite{green2022flaws}.
 This means  that   oversight policies   can lead to the reverse of their desired effect  by {\em ``legitimizing the use of   faulty and controversial algorithms without addressing (their fundamental issues''}~\cite{green2022flaws}.




%.

%Cognitive theory~\cite{simon1956rational} tells us that humans  use heuristic ``cues'' that lets them find    (hopefully)  most important parts of a modelbefore rushing off to their next task.



  Unfortunately,
there are substantial examples where human oversight missed important software properties (see Table~\ref{tbl:sigh}). For example,  
see the above bias problems.



=======================
So here we explore how much we
"Science is what we understand well enough to explain     
to a computer. Art is everything else we do"    
- Donald Knuth

With automated software engineering, are you an artist or a scientist?
Do you understand how to implement multi-objective semi-supervised explanations?
Probably not, yet.  

So lets lay it out, slowly. What might surprise you is,
as seen in the
[fish1.lua](/src/fish1.lua) 
system,
all this can be coded in a few hundred lines of code.

To understand this code, think in layers:
- Layer1:  written in LUA
- Layer2: command-line script
- Layer3: that supports  a generic data model which, in turn supports:
- Layer4: multi-objective semi-supervised explanation

The thing to note in the following is that across all the scripts used here, there is much common
structure-- which is kind of deep point; i.e. under-the-hood there is much commonality in 
the algorithms people call "optimization", "data mining", "explanation", etc.

## Layer1: LUA

LUA is an ultra lightweight scripting language comprising
less than two dozen keywords:
**and, break, do, else, elseif, end, false, for, function, if, in, local, nil, not, or, repeat, return, then, true, until, while**.
LUA has a considerably
smaller footprint than other programming languages, with its complete
source code and documentation taking a mere 1.3 MB.

I use LUA as an executable specification language. Students rewrite
my code in whatever language they like (that is not LUA). 
So to understand 
[fish1.lua](/src/fish1.lua) 
you do not need to run my LUA-- you only need to read it.

- For quick tutorials on LUA, see  [learnlua](https://learnxinyminutes.com/docs/lua/)
- For full details on LUA, see the [Programming in LUA](https://www.lua.org/pil/contents.html) book.

If you sqint and 
```lua
local SYM = lib.obj"SYM"
function SYM:new() --> SYM; constructor
  self.n   = 0
  self.has = {}
  self.most, self.mode = 0,nil end

function SYM:add(x) --> nil;  update counts of things seen so far
  if x ~= "?" then
   self.n = self.n + 1
   self.has[x] = 1 + (self.has[x] or 0) -- if "x" not seen before, init counter to 0
   if self.has[x] > self.most then
     self.most,self.mode = self.has[x], x end end end

function SYM:mid(x) --> n; return the mode
  return self.mode end

function SYM:div(x) --> n; return the entropy
  local function fun(p) return p*math.log(p,2) end
  local e=0; for _,n in pairs(self.has) do e = e - fun(n/self.n) end
  return e end
```

```lua
-- ## NUM
-- Summarizes a stream of numbers.
local NUM = lib.obj"NUM"
function NUM:new() --> NUM;  constructor;
  self.n, self.mu, self.m2 = 0, 0, 0
  self.lo, self.hi = math.huge, -math.huge end

function NUM:add(n) --> NUM; add `n`, update min,max,standard deviation
  if n ~= "?" then
    self.n  = self.n + 1
    local d = n - self.mu
    self.mu = self.mu + d/self.n
    self.m2 = self.m2 + d*(n - self.mu)
    self.sd = (self.m2 <0 or self.n < 2) and 0 or (self.m2/(self.n-1))^0.5
    self.lo = math.min(n, self.lo)
    self.hi = math.max(n, self.hi) end end

function NUM:mid(x) return self.mu end --> n; return mean
function NUM:div(x) return self.sd end --> n; return standard deviation
```

## Layer2: Scripting

All my code has some common features:

Initial help text. 


LUA is a language that is said to "not be provided with batteries".
This means that its libraries are kept to the minimum necessary to
do some stuff. Some people like PYTHON better since it comes with
a very large set of standard libraries. Some people like LUA cause
it doesn't (
## Background

## Examples of "Fishing"
Consider the following tasks:
- What is the same across all of them? 
- What is learned for "February"; i.e.  if we go fishing  January, then in February,
    what have we learned from January that makes February easier?


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


|What|Notes}
|----:|:------|
| X   | inputs|
|Y    | goals|
|F    | maps X to Y|
|W    | weights on the goals|
|Z    | parameters controlling the learners that generates F|

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

Note: avoid many-goal problems at this point. That will be bonus marks, below.

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
            - to one of more  human-level sampling process  (see  Table1 of Baltes et al.[^ralph])
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

#### B1: Repeat the above for many-goal problems.

Defined above

#### B2: Perform a _REQUIREMENTS STUDY_
- For 5 humans, run 5 repertory grids studies. 
- Compare the results:
  - against a recursive bi-clustering  of the data plus
    some hierarchical feature selection
  - against results from other humans
  - Is there anyway way the intra-human views (or the view between human an data)
    can be aligned? (HINT: maybe not)
- Include a commentary on your experience with rep grids (any surprises?) 

#### B3: Perform a _FEBRUARY STUDY_ 
Requires an explanation facility, as described above.
- If analysts used budget $B_0$ in January to reach some conclusions, what is learned
   such that this kind of future analysis gets simpler.
- So pretend its February and we have come back to a some similar problem (like what was
      studied in January). Using what was learned in January, can the same task be solved
      with less budget $B_1 < B_0$?

#### B4: Perform an _ABLATION STUDY_
- Given a preferred method $M$ containing two to four main ideas
  - Disable (or change) each one  thing. If anything get worse, declare that thing important.

#### B5: Perform an _HPO study_
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


