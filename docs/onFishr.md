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

XXXX assignemnt spec  
XXXX lessons learned from x applied to y...
XXX wat tohnad in

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
Consider the following examples. What is the same across all of them?

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

[^nn]: ![](/etc/img/knnhpo.png)

XXXX leanr from audit1 abple o 1=1

## Let's say that another way.

<img width=400 align=right src="/etc/img/2space.png">

We seek  a mapping $F$ such that $Y=F(X)$ where:
- $X$ and $Y$ are sets of decisions and goals
- Often $|X| \gg |Y|$, i.e. there are usually more decisions and goals.
- We might have access to a set of weights $W$ for each $Y$ value;
  e.g. if $W_i<0$ then we might seek solutions that  minimize $Y_i$.
- Under the hood, we might also have $Z$, a set of hyper-parameters
  that control the algorithms that find $F$.

It is cheap to sample $X$ and very, very, very expensive to sample $Y$,
- e.g. describing the ocean is much cheaper than sailing around it all day looking for fish
- e.g. listing the Makefile options within SQL is faster than compiling and testing each one,

Only some  subset of $X$ are observable and/or controllable (or, indeed, relevant to
    the task at hand).

If $|Y|>0$ then this is a supervised problem:
  - Semi-supervised learning is when  we have many examples but only
    a small subset have $Y$ values... in which case we can do things like
    spreading out the available $Y$ values over local clusters in the 
    $X$ values.
  - Unsupervised learning is when we have no $Y$ values... in which case
    we can do things like cluster the $X$ variables then ask humans 
    people to offer comments on each cluster.
- Numeric and symbolic goals are also know as _regression_ and _classification_ tasks.
- Single, multi, many goal-optimization have one, three, or more goals


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


