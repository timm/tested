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


# Data Mining


https://www.analyticsvidhya.com/blog/2021/07/deep-understanding-of-discriminative-and-generative-models-in-machine-learning/


Table1:
Good division of algorithms. Lately I’ve also been categorizing algorithms into
- Predictive: what is  (regression, classification)
- Optimization: what to change
- Generative: what else ?  (Markov chain, neural, bayesian, association rules)
https://www.analyticsvidhya.com/blog/2021/07/deep-understanding-of-discriminative-and-generative-models-in-machine-learning/


y=f(x)
o
btw, symbols and numbers  are different.
o
fro association rule lerning to generative networks. learn expectataions. reproduce them. same problem needed in optimization.
https://thesis.eur.nl/pub/52710/FINAL_VERSION_THESIS.pdf
o


TESTED assumes that better
data mining algorithms are better at explaining their models to
humans. But is that always the case?

The obvious counter-argument is that if no human ever needs
to understand a model, then it does not need to be comprehensible. For example, a neural net could control the carburetor
of an internal combustion engine since that carburetor will never
dispute the model or ask for clarification of any of its reasoning.

On the other hand, if a model is to be used to persuade software
engineers to change what they are doing, it needs to be comprehensible so humans can debate the merits of its conclusions. Several
researchers demand that software analytics models needs to be
expressed in a simple way that is easy for software practitioners
to interpret. According to Kim et al. [^kim16], software analytics aim to obtain actionable insights from software artifacts
that help practitioners accomplish tasks related to software development, systems, and users. Other researchers argue that
for software vendors, managers, developers and users, such comprehensible insights are the core deliverable of software analytics.
Sawyer et al. comments that actionable insight is the key driver for
businesses to invest in data analytics initiatives [^saw13]. Accordingly,
much research focuses on the generation of simple models, or make
blackbox models more explainable, so that human engineers can
understand and appropriately trust the decisions made by software
analytics models.

Some researchers go further and warn that, for mission critical applications, we should never use opaque back-box models.
In 

XXX

LIME


[^kim16]: Miryung Kim, Thomas Zimmermann, Robert DeLine, and Andrew Begel. 2016.
  The Emerging Role of Data Scientists on Software Development Teams. 
  In Proceedings of the 38th International Conference on Software Engineering (ICSE ’16). ACM,
  New York, NY, USA, 96–107. DOI:http://dx.doi.org/10.1145/2884781.2884783

[^saw13]: Robert Sawyer. 2013. Bias Impact on Analyses and Decision Making Depends
  on the Development of Less Complex Applications. In Principles and Applications
  of Business Intelligence Research. IGI Global, 83–95


If a model is not comprehensible, there are some explanation
algorithms that might mitigate that problem. For example:
• In secondary learning, the examples given to a neural network
are used to train a rule-based learner and those learners could
be said to “explain” the neural net [13].
• In contrast set learning for instance-based reasoning, data is
clustered and users are shown the difference between a few
exemplars selected from each cluster [35].
Such explanation facilities are post-processors to the original learning method. An alternative simpler approach would be to use learners that generate comprehensible models in the first place.

"In most applications examples are not spread uniformly throughout the instance space, 
  but are concentrated on or near a lower-dimensional manifold. Learners can implicitly take advantage of this lower effective dimension."    
-- Pedro Domingoes


<img align=right width=600 src="/etc/img/weather.png">

TESTED in a **semi-supervised** learner. 
Just to understand that term, 
**supervised learners** assume all examples are labeled. 
For example, lets build a decision tree:


In practice, it can be
very expensive to acquire these labels via human labor.
For example, four out of the nine projects studied in one paper [^tu22]
paper need humans to label 22,500+ commits 
as "buggy" or "not buggy". This work
required 175 person hours, include cross-checking, to read via standard manual
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


**Unsupervised learning**
reasons over unlabelled data. In this case, you've got columns of inputs,
but no outputs. In this case, we can group together related rows but we may not know what those
groupings mean (since no oracle has commented on each group). For example,
in recursive Fastmap [^men13][^fal95] we group data around two distant points, then recurse on each group.

<br clear=all>

Just to fill in those details:
- Find two distant points $A,B$ separated by distance $c$.
- <img align=right width=200 src="/etc/img/abc.png">
  Any other point $C$ has distance $a,b$ to $A,B$
- By the cosine rule (derived below), fall on a line from $A$ to $B$, fall at $x=\frac{a^2+c^2-b^2}{2c}$
- Divide points on median $x$ value.
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


**Semi-supervised learners** assume that data has some shape with trends
in that shape. If so, then  we do not need
to poke around every part of that shape. 
Levina et al. [^lev05] comment that the reason any data mining method works for
high dimensions is that data embedded in high-dimensional format actually
can be converted into a more compressed space without major information loss. For example,
see the "shadow" of the mountains on the "roof"? That 2D plot would be enough for most purposes.

<img width=500 src="https://user-images.githubusercontent.com/29195/131709651-2b8f6932-023a-479f-9505-0fffa1921ba0.png">

For another example, see how neither of these two dimensions models that data as well as a line drawn
between two distant points in the data (see the back arrow in the middle of all the dots).

<img width=500 src="https://user-images.githubusercontent.com/29195/131709868-4e2c7444-0e37-4a71-bd47-b171bd2679f4.png">

The lesson here is that hiding within all those dimensions is a lower dimensional
space that is just as informative, and easier to use.
For example, here is one study that reduces colums,rows from 30,60 to 6. In the following, each row describes
one class, and its bugs:
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

It is easy to see why such reductions are possible:
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


When we can approximate all the data with a small set this lets us do things like:
- cluster the data
- only label one example per cluster.

For example:
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
  the deep learning research.  For my comments and criticism of deep learning, see slides 6 to 11 
  of [http://tiny.cc/22issre](http://tiny.cc/22issre).)

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


