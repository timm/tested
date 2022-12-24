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

<a href="/etc/img/scope2.png"><img width=400 align=right src="/etc/img/scope2.png"></a>
Once astronomers  learn how to grind lens, then on they go
to explore the universe.
So, now that software engineers know how  to match brackets, it is time
for a different, bigger, and better role for SE. Our
software is tool everyone uses to touch and change the world around them. How
can we support that exploration process.

Just to give this some focus, lets tr More precisely how we better support incremental agile acceptance testing
where software is understandable to a wider  audience.
(Aside: Q: is this an AI subject, or an SE subject?  A: yes. 
AI is software[^me]  and as such it needs engineers who have
the experience needed to revise and refactor and improve it[^me].)

[^me]: T. Menzies, 
       ["The Five Laws of SE for AI"](https://github.com/timm/timm.github.io/blob/master/pdf/20FiveLawsSE4AI.pdf),
       in IEEE Software, 
       vol. 37, no. 1, pp. 81-85, Jan.-Feb. 2020, doi: 10.1109/MS.2019.2954841.<br>

[^mart]:  Silverio Martínez-Fernández, Justus Bogner, Xavier Franch, Marc Oriol, Julien Siebert, Adam Trendowicz, Anna Maria Vollmer, and Stefan Wagner. 2022. 
        [Software Engineering for AI-Based Systems: A Survey](https://dl.acm.org/doi/pdf/10.1145/3487043)
        ACM Trans. Softw. Eng. Methodol. 31, 2, Article 37e (April 2022), 59 pages. https://doi.org/10.1145/3487043

Many ways to approach, here we seek a refactoring of AI tools such that many things can be implemented by just a few things.
Principles 

increamtan agile acceptance testing where what is learned from  testing helps is improve the next  version
## Lets Go Fishing
The world is a big place, too much to see and learn.
What kind of software helps humans to explore the world, and control it better?


For example, your fishing boat has a crew of six. Each day, before you catch
  anything, you waste hours burning expensive fuel traveling between promising
  fishing spots. What  software help you look at the ocean and find the fish faster?

You've need a car for Monday but you aren't really sure what kind
  you like. After a day of going to car yards, and doing a few test
  drives, you buy a car. Can software help you narrow down how many cars you need to look at?

<a href="/etc/img/build.png"><img width=400 align=right src="/etc/img/build.png"></a>
You are an architect trying to design houses with
  a house with lots of light but no glare. You client is a busy (and fussy) person and before
  you show them all the possible designs, can software help you prune them back to an interesting subset?

The manager of a software project knows many tricks for running a project.
  Any one project uses just a few of those tricks, but which one to apply?
  Can software  help you learn which tricks are best (and wish to avoid)?

Your software is being assessed by a focus group (a set of stakeholders).
  Your software is complex and this group has limited time to understand
  it and certify that the software is behaving reasonably[^green].

Software analytics learn models from data. Data labels are often incorrect[^tu] and
so they need to be checked before they are used. But data sets can be huge, and relabelling
everything can be so expensive.  S

<a href="/etc/img/fairness.png"><img width=400 align=right src="/etc/img/fairness.png"></a>
A software engineer can't try   options
but after a few experiments, they ship a product. For example:
- Data miners are controlled by billions of hyper-parameter options that control (e.g.)
    the shape of a neural net or how many neighbors your use for classification.
    These parameters let you trade off (e.g.) how many mistakes you tolerate
    versus how many results you return; or accuracy versus fairness[^cruz21].
- MySQL's Makefile has billions of configurations options, each of
    which means your SQL queries take different times to run and use
    different energy. 

[^cruz21]: A. F.Cruz, P. Saleiro, C. Belém, C. Soares and P. Bizarro, 
      ["Promoting Fairness through Hyperparameter Optimization"](https://arxiv.org/abs/2103.12715)
      2021 IEEE International Conference on Data Mining (ICDM), 2021, pp. 1036-1041, doi: 10.1109/ICDM51629.2021.00119.

XXXX leanr from audit1 abple o 1=1

## Let's say that another way.

<img width=400 align=right src="/etc/img/2space.png">

We seek  a mapping $F$ such that $Y=F(X)$ where $X$ and $Y$ are sets of decisions and goals.

It is cheap to sample $X$ and very, very, very expensive to sample $Y$,
- e.g. describing the ocean is much cheaper than sailing around it all day looking for fish
- e.g. listing the Makefile options within SQL is faster than compiling and testing each one,

Only some  subset of $X$ are observable and/or controllable (or, indeed, relevant to
    the task at hand).

Often $|X| \gg |Y|$, i.e. there are usually more decisions and goals.
- single, multi, many goal-optimization have one, three, or more goals
- Numeric and symbolic goals are also know as _regression_ and _classification_ tasks.

There can be many goals $Y$ and some are  contradictory (e.g. security and availability
    can be mutually exclusive).
- If we cannot satisfy all goals, we explore trade-offs between them (known as satisficing[^simon]).
 - And in those cases, sometimes the exploration can be just (or more) insightful than actually getting find an answer.
 - Vilfredo Pareto:  <em> Give me the fruitful error any time, full of seeds, 
          bursting with its own corrections. You can keep your sterile truth for yourself.</em>

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


