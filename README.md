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

| Study guide: terms to watch | 
unsupervised learning, semi-supervised learning, supervised learning,
clustering, 
decision tree learning
# Introduction 


## What is TESTED?

TESTED is a demonstration that semi-supervised multi-objective
explanation algorithms are surprisingly easy to build. Such
algorithms support "stakeholder testing" where humans want
to sort and discover the best and worst things, without
having to offer too much information on each thing. Once discovered,
TESTED can also offer advice on how to make bad things better.

## No, really, what is TESTED?

So what is TESTED really about?
- is it about how to reconfigure broken things to make them better? 
- is it about requirements engineering?
- is it about software engineering?
- is it about data mining?
- is it about testing?

To which the answer is "yes". All these things share the same underlying
methods and challenges. Which means tools built for one of these tasks
can help the other [^abduction]. 

[^abduction]: For more on the mysterious machine that runs deep
  within testing, SE, requirements engineering, configuration, etc,
  see [my Ph.D. thesis](https://menzies.us/pdf/96abkl.pdf). In summary,
  by the time you can test "it" then you can also exercise "it";
  i.e. properly designed, a good test engine is also a good
  execution engine. For years I tried coding all this up in a logical
  framework. Then I found ways to use data mining for very faster,
  scalable, approximate reasoning. So now I offer my private
  theory-of-everything in a procedural framework, embedded with some
  data mining tools. Specifically, data miners divide a space and
  optimizers tell you how to jump around that space.


## Why TESTED?

Hopefully,
software  built by people like me (i.e. a developer) is
used by other people 
(i.e. the stakeholders[^stake]). How can those stakeholders verify if the built software is right,
or validate that the right software is being built?

The problem with 
stakeholder testing is that, typically,
they do not understand everything  about what goes on inside the code.
Hence they need:
- [semi-supervised_learning](#semi-supervised-learning): 
    which only needs opinions on very small,
    most
  informative, parts of a whole system.
only needs labels for a small  percent of its examples
- _explanation algorithms_: TESTED lets stakeholders
    browse succinct summaries of a system's state space.
- _multi-objective_: Stakeholders have different goals (and some of them might even be
contradictory). So TESTED lets  according to handle multiple domain objectives, as specified by stakeholders;

Stakeholder-based testing is a human-in-the-loop exercise. Unless we are careful,
these people can be overwhelmed by having to look at too much information.
This is a really big problem.



Software contains bugs, always
(see, for example, the
depressing litany of mistakes documented in Peter
Neumann’s [Computer-Related Risks](https://catless.ncl.ac.uk/risks/)).
and things with bugs need to be tested before we use them. Testing is such an important
task and frequent task that it is worth considering how to design systems
that can be explored effectively and cheaply.

[^stake]:  ("Stakeholders"  are individuals or organizations having
a right, share, claim, or interest in a system or in its possession
of characteristics that meet their needs and expectations 
[(ISO/IEC/IEEE
2015)](https://www.iso.org/standard/63711.html)


TESTED assumes that the best way to test "it" is to watch someone else 
(specifically, stakeholders [^stake])
try to break "it".  is all about exploring more, using fewer samples to the system.

More specifically, TESTED lets stakeholders  sort examples (according to
personnel preferences)  without having to know everything about all examples.
Formally, this is semi-supervised multi-objective explanation:

If this all seems a little complicated to you, then relax. TESTED is the result of much refactoring and
simplification of dozens of research prototypes. 
It  is written in Lua (which is a
small and simple Python-like language, but with far less overhead).
- Students use these samples as an executable specification which
they must reproduce in any other language they like (except Lua).
- Each of these assignments is about 1-2 weeks of work. 
- Hence, it is
suitable for homeworks or (by combining several modules) a large
end-of-term project.  

(Just an aside, the way I do weekly homeworks is that every week, everyone
has to submit something, even if it is broken. Homeworks can get submitted multiple times
so I grade them "2" (for "good"); "1" (for "invited to resubmit"); "0" (for "bad" or "no submission".)

## Install

Install Lua:

    brew install lua       # on max os/x
    lua -v                 # TESTED needs at least LUA version 5.3

Check-out this repo

    git clone https://github.com/timm/tested

Check your installation

    cd tested/src
    lua 101.lua -g all # should show one crash and several passes

## Concepts

TESTED has four layers:

|Layer|Notes|
|----|------|
|Underlying language (Lua) | Includes [library](/docs/lib.lua) routines
|Scripting  | Includes support for test-driven development (see the `eg` object in, for example, [about.lua](/src/about.lua);<br> Includes support for config (see the `the` variable in, for example, [about.lua](/src/about.lua));<br> Includes support for documentation (see [alfold.lua](/src/alfold.lua) which generates, say, [alfold.md](/docs/alfold.md)).|
|Data |  See the classes NUM, SYM, ROW, DATA) in [about.lua](/docs/about.md) that read csv files and stores data. |
| Application | Lots of examples of different data mining tools. |

### Why TESTED?

<img align=right width=400 src="/etc/img/cars.png">

[The Road to AI](https://arxiv.org/pdf/2212.11279.pdf) 
paints an exciting picture of modern AI, dominated by deep learning,
where those current techniques are the inevitable, inexorable result of
centuries are prior thought. 

It is a great paper, well worth your time. But it has its limitations.
In all that writing is one important concept:
how do you test such systems?
If you are a software engineer, you know that AI software is still
software. Software has bugs and
Anything with bugs needs to be tested.
How do you and your stakeholders[^stake] test a complex AI system? 

But before answering that, lets make sure we understand testing.
Firstly, Software has stakeholders so we need systems that can explain themselves
to anyone with a right, share, claim, or interest in that system. 
So we need someway that stakeholders can "drop in", from time to time,
and comment on the software that effects in. That process needs to support:
- _high-level explanations_ where the stakeholders may not understand much 
  of the low-level detail of the system; 
- _rapid testing_ since the stakeholders are typically busy to get back to their day job
- _periodic testing_ (where the stakeholder tests are interment, and separated by
    weeks or months. Ideally, something is learned from stakeholder testing in
    (say) January that can be applied automatically until the stakeholders
    return in (say) March.
- _incremental testing_ where, each time we return to retest,
    something learned from the past simplifies this next round of testing.

Secondly, testing is not just some process of adding check marks to a system.
Testing needs to verify that the system us built right
but it also needs to look further and validate that the right system is being built.
My own Ph.D. started out as a generic
testing mechanism. It took a while to realize
the obvious: testing "it" means being
able to exercise "it" so, properly designed, a generic test engine
is actually  a generic execution engine that can do many things[^abkl]
(and not just testing).
Anyone familiar with the rapid feedback cycles seen in modern software
development knows that "testing" is also about "exploring" ideas and
making them better.If w is not true, then we can get stuck...

- "Imagine if (the ancient greeks)  had developed robots... 
automating tasks at that time, 3,000
years ago, .... such as pottery and
weaving...  human labor would no longer be needed,
people would live lives of leisure...
stuck with the artifacts and production of the time.
To raise the quality of life substantially,
we can't build machines that merely substitute for human labor and
imitate it; <b>we must expand our capabilities and do new things</b>."    
-- [Erik Brynjolfsson](https://www.zdnet.com/article/ai-debate-3-everything-you-need-to-know-about-artificial-general-intelligence/)


[^abkl]: Tim Menzies,
[Applications of abduction: knowledge-level modelling](https://menzies.us/pdf/96abkl.pdf),
International Journal of Human-Computer Studies,
Volume 45, Issue 3,
1996,
Pages 305-335,
ISSN 1071-5819,
https://doi.org/10.1006/ijhc.1996.0054.
(https://www.sciencedirect.com/science/article/pii/S1071581996900543)
Abstract: A single inference procedure (abduction) can operationalise a wide variety of knowledge-level modelling problem solving methods; i.e. prediction, classification, explanation, tutoring, qualitative reasoning, planning, monitoring, set-covering diagnosis, consistency-based diagnosis, validation, and verification. This abductive approach offers a uniform view of different problem solving methods in the style proposed by Clancey and Breuker. Also, this adbuctive approach is easily extensible to validation; i.e. using this technique we can implement both inference tools and testing tools. Further, abduction can execute in vague and conflicting domains (which we believe occur very frequently). We therefore propose abduction as a framework for knowledge-level modelling.

The third thing we need to understand about testing is that while we can automate
billions of system inputs per second, all that is useless unless some oracle can tell us
how to assess those outputs.

XXXX oracle problem. metamorphic. large system, sample the least.

TESTED assumes that the best way to test something is to give it
to someone else, and watch them break it.  
- This is actually a core
principle of ethical programming.  
- Vance et al. [^Vance2015] argue that a
pre-condition for the accountability is the knowledge of an 
**external audience**, who could approve or disapprove of a system. 

TESTED has many tools for such external audiences:

- Methods for looking beyond those boundaries (taken from cognitive
psychology); 
- Human-readable model generation methods that can
extract symbolic descriptions from training data (since that is
what humans need for explaining a system); 
- Cost-effect sampling
methods that let outsiders probe a system, looking for interesting
(or alarming) behavior.  
- Semi-supervised learners where algorithms
make conclusions based on a small sample of the total data space
(so humans are not overwhelmed with excessive questions).
- Operators for learning the boundaries of a system’s competency;
- Non-parametric tests for assuring that samples are truly different.

[^Vance2015]: Vance, Anthony, Paul Benjamin Lowry, and Dennis Eggett. 
  "Increasing Accountability Through User-Interface Design Artifacts." 
  MIS quarterly 39.2 (2015): 345-366.

[^Baltes22]: Baltes, S., Ralph, P. 
  [Sampling in software engineering research: a critical review and guidelines](https://arxiv.org/pdf/2002.07764.pdf);
  Empir Software Eng 27, 94 (2022);  https://doi.org/10.1007/s10664-021-10072-8.
	
[^Niu07]: Nan Niu, Steve M. Easterbrook: 
  [So, You Think You Know Others' Goals? A Repertory Grid Study](https://www.cse.msstate.edu/~niu/papers/SW07.pdf); 
  IEEE Softw. 24(2): 53-61 (2007) https://ieeexplore.ieee.org/document/4118651.

## Background

### Semi-Supervised Learning

TL:DR:

> **The best thing we can do with data is throw most of it away.** :astonished:

<img align=right width=600 src="/etc/img/weather.png">

TESTED in a _semi-supervised_ learner. 
Just to understand that term, 
_supervised learners_ assume all examples are labelled. 
For example, lets build a decision tree:


In practice, it can be
very expensive to acquire these labels via human labor.
For example, four out of the nine projects studied in one paper [^tu22]
paper need humans to label 22,500+ commits 
as "buggy" or "not buggy". This work
required 175 personhours, include cross-checking, to read via standard manual
methods (and 175 hours ≈ nine weeks of work). Worse yet, labels can be wrong
and/or contained biased opinions which leads to faults in the reasoning[^joy21].

[^tu22]: H. Tu, Z. Yu and T. Menzies, 
  ["Better Data Labelling With EMBLEM (and how that Impacts Defect Prediction),"](https://arxiv.org/pdf/1905.01719.pdf)
   in IEEE Transactions on Software Engineering, 
   vol. 48, no. 1, pp. 278-294, 1 Jan. 2022, doi: 10.1109/TSE.2020.2986415.

[^joy21]: Joymallya Chakraborty, Suvodeep Majumder, and Tim Menzies. 2021. 
  [Bias in machine learning software: why? how? what to do?](https://arxiv.org/pdf/2105.12195.pdf)
  In Proceedings of the 29th ACM Joint Meeting on European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE 2021). Association for Computing Machinery, New York, NY, USA, 429–440. https://doi.org/10.1145/3468264.3468537

<img  align=right src="/etc/img/rmap.png" width=500>


_Unsupervised learning_
reasons over unlabelled data. In this case, you've got columns of inputs,
but no outputs. In this case, we can group together related rows but we may not know what those
groupings mean (since no oracle has commented on each group). For example,
in recursive Fastmap [^men13][^fal95] we group data around two distant points, then recurse on each group.

<br clear=all>

Just to fill in those details:
- Find two distant points $A,B$ separated by distance $c$.
- <img align=right width=200 src="/etc/img/abc.png">
  Other point have distance $a,b$ to $A,B$ and by the cosine rule (derived below), fall on a line from $A$ to $B$, fall at $x=\frac{a^2+c^2-b^2}{2c}$
- Divide other points on median $x$ value.
- Recurse on each half
- Stop at (say) $\sqrt{N}$

|Derivation| step1| step2|
|---:|-----|--|
| EQ1 | $x^2 + y^2 = a^2$ | $\Longrightarrow y^2 = a^2 - x^2$     |
| EQ2 | $(c-x)^2 + y^2=b^2$ ||
|Expanding EQ2,<br>substituting EQ1 for $y^2$ |  $c^2-2cx +x^2 +a^2 - x^2 = b^2$   | |
|Isolate $x$ terms on LHS | $-2xc +x^2-x^2 =  b^2 - c^2 - a^2$  | $\Longrightarrow  x=\frac{a^2 + c^2 -b^2}{2c}$  |


[^men13]: [Local versus Global Lessons for Defect Prediction and Effort Estimation](https://menzies.us/pdf/12localb.pdf)
  Tim Menzies; Andrew Butcher; David Cok; Andrian Marcus; Lucas Layman;
  Forrest Shull; Burak Turhan; Thomas Zimmermann IEEE Transactions
  on Software Engineering Year: 2013 | Volume: 39, Issue: 6

[^fal95]: Christos Faloutsos and King-Ip Lin. 1995. 
   [FastMap: a fast algorithm for indexing, data-mining and visualization of traditional and multimedia datasets](https://infolab.usc.edu/csci599/Fall2002/paper/DM1_faloutsos95fastmap.pdf)
  . SIGMOD Rec. 24, 2 (May 1995), 163–174. https://doi.org/10.1145/568271.223812


_Semi-supervised learners_ assume that data has some shape with trends
in that shape. If so, then  we do not need
to poke around every part of that shape. 
Levina et al. [^lev05] comment that the reason any data mining method works for
high dimensions is that data embedded in high-dimensional format actually
can be converted into a more compressed space without major information loss.

It is easy to see why we can reduce a data set's features are rows:
- Many rows must be similar to the point of redundancy  since, when we build a model, 
  each part of that model should have support from multiple
  data points. This means that all the rows can be shrunk back to just a few examples.
- Most columns must redundant or noisy since otherwise,
  data mining would not work:
  - A linear increase in feature count means an exponential increase
    in the volume of the box contains the features.
     E.g.
     - in one dimension (running 0..1), 5  evenly spaced points of size 0.2 would cover
         the space.
     - but in  two,tree  dimensions, you'd need 25 to 125
     - and in 20 dimensions you'd need quadrillion examples $5^{20} \approx 10^{14}$ examples, 
         to cover that hypercube
     - This is described as the curse of dimensionality:
          the explosive nature of increasing data dimensions and its resulting exponential 
          increase in computational efforts required for its processing and/or analysis.
   - But data mining works on data sets with hundreds columns _without_ needing quadrillions rows.
     Hence, it must be possible to ignore most of those columns. For example,
     once I reduced 351 features down to 9, with no loss of efficacy in prediction [^part14].
     

<img width=650 src="/etc/img/curse.png">

[^part14]: Partington, S.N., Papakroni, V. & Menzies, T. 
  [Optimizing data collection for public health decisions: a data mining approach.](https://link.springer.com/article/10.1186/1471-2458-14-593)
  BMC Public Health 14, 593 (2014). https://doi.org/10.1186/1471-2458-14-593


For example, here is some data where each row describes one class:
- The
columns are static code features (e.g. lines of code, number of methods,
depth of inheritance tree) and the right-hand-side column lists the number of
defects per class.
  - the color at top-of-column shows how strongly
    the column is associated with the right-hand-side target column (number of
    defects).
  - The green on the left-hand-side shows the results of some clustering: green rows
    are closest to the center of each cluster.
- The data has been sorted such that all the green rows are together and all the things
    most associated with the defects are together.
- Note that a small "corner" of the data has the best columns and the best.
- Papakroni[^papa13] found that simplest nearest neighbor  algorithm that just
    the data in the corner worked as well as anything else.

 <img width=800 src="/etc/img/peters1.png">

 <img width=800 src="/etc/img/peters2.png">

This means we can do things like cluster the data
then only label one example per cluster. For example:
-  Kamvar et al. [^kamvar03] report studies where,
after clustering,
they achieved high accuracy on the categorization of thousands of documents given only
a few dozen labeled training documents (from 20
Newsgroups data set).
- In studies with static code warning recognizer and issue closed time predictor,
  Tu et al. [^tu21] outperformed the prior state-of-the-art in
  static code warning recognizer and issue closed time predictor, 
  while only needed to label 2.5% of the examples.
- In studies with defect prediction, Papakroni   [^papa13] found that for defect prediction
  and effort estimation, after recursively bi-clustering down to $\sqrt{N}$ of the data,
  they could reason about 442 examples using less than 25 examples (and 25/400=6% of the data)
  For example,
  can you see how Papakroni finds bugs are in the following?
  - red/blue denotes a class with some/no bugs
  - the x-axis was a line drawn between
    two most distant examples
  - the y-axis is  another line at right angles to x
  - the LHS is a recursive division at median x-y.
  - the RHS is one example per leaf cluster:

![](/etc/img/papa.png)

The practical up-shot of semi-supervised learning is
that data tables with $R,C$ rows and columns can be reduced to just
a
few exemplar rows
(found via instance selection[^olv]), described using just  a few most informative columns
(found via feature selection [^li17]).

(Aside: counter position to the above:
- For an argument that, sometimes, adding more columns is a good idea, see
  A. Zollanvari; A. P. James; R. Sameni (2020). "A Theoretical Analysis of the Peaking 
  Phenomenon in Classification". Journal of Classification. 37 (2): 421–434. 
  doi:10.1007/s00357-019-09327-3.)
- For an argument that, somethings, adding more rows is a good idea, see
  the deep learning research.)


[^kamvar03]: Kamvar, Kamvar and Sepandar, Sepandar and Klein, Klein and Dan, Dan and Manning, 
  Manning and Christopher, Christopher (2003) 
  [Spectral Learning](https://people.eecs.berkeley.edu/~klein/papers/spectral-learning.pdf)
  Technical Report. Stanford InfoLab. (Publication Note: International Joint Conference of Artificial Intelligence)


[^lev05]: Levina, E., Bickel, P.J.
  [Maximum likelihood estimation of intrinsic dimension](https://www.stat.berkeley.edu/~bickel/mldim.pdf) In:
Advances in neural information processing systems, pp. 777–784 (2005)

[^li17]: Li, J., Cheng, K., Wang, S., Morstatter, F., Trevino, R. P., Tang, J., & Liu, H. 
        (2017). 
        [Feature selection: A data perspective](https://dl.acm.org/doi/pdf/10.1145/3136625).
        ACM computing surveys (CSUR), 50(6), 1-45.

[^olv]: [A review of instance selection methods](https://inaoe.repositorioinstitucional.mx/jspui/bitstream/1009/1389/1/165.-CC.pdf)
JA Olvera-López, JA Carrasco-Ochoa… - Artificial Intelligence Review, 2010

[^papa13]: Papakroni, Vasil, 
  ["Data Carving: Identifying and Removing Irrelevancies in the Data"](https://researchrepository.wvu.edu/cgi/viewcontent.cgi?article=4403&context=etd)
  (2013). Graduate Theses, Dissertations, and Problem Reports. 3399.  https://researchrepository.wvu.edu/etd/3399 

[^tu21]:  H. Tu and T. Menzies, i
  ["FRUGAL: Unlocking Semi-Supervised Learning for Software Analytics,"](https://arxiv.org/pdf/2108.09847.pdf)
   2021 36th IEEE/ACM International Conference on Automated Software Engineering (ASE), 2021, pp. 394-406, doi: 10.1109/ASE51524.2021.9678617.

## Homeworks

### Homework1: 101.lua Test-Driven Development

Since some students are stronger than others (w.r.t. scripting). So the
first task is more of a balancing exerice to get everyone up to speed.


