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


# Automated SE and Explaination


Adadi and Berrada [2] identified 17 XAI techniques by surveying
381 papers published between 2004 and 2018. According to the survey, most recent work done in the XAI field offers a post-hoc, local
explanation. 


- what about pre-hoc, global?


Within the current AI industry
there are many available models-- not
all of which can be   inspected. "Model stores" are cloud-based
services that charge a fee for using models hidden away behind a firewall (e.g. AWS market-place~\citemain{marketplace2019machine} and 
the Wolfram neural net repository~\citemain{wolfram}). Adams et al. ~\citemain{xiu2020exploratory} discusses model stores (also known as  ``machine learning as a service''~\citemain{ribeiro2015mlaas}), and warns that  these models  are often  low quality   (e.g. if it comes from  a hastily constructed prototype from a Github repository, dropped into a container, and then sold as a cloud-based service). Ideally, we use software testing to   defend ourselves against potentially low quality models. But   model owners may not publish verification results or detailed
specifications-- which means standard testing methods are unsure what to test for.


An alternative to standard testing is to run an _explanation_ algorithm that offers a high-level picture of  how model features influence each other. Unfortunately,  the better we get at  generating explanations,
the better we also get at generating misleading explanations. 
For example, Slack et al.'s lying algorithm~\cite{slack}
(discussed below) knows how to detect ``explanation-oriented'' queries. 
That liar algorithm can then switch to  models which, by design,   disguise  biases against  marginalized groups (e.g. some specific gender, race, or age grouping). 


The Slack et al.'s results are particularly troubling.
An alarming number   commercially deployed models  having discriminatory properties~\citemain{noble18,chakraborty2021bias}. For example, the (in)famous COMPAS model (described in Table~\ref{tab:dataset})   decides the likelihood of a criminal defendant reoffending. The model suffers from alarmingly different false positive rates for Black defendants than White defendants.  Noble's
book {\em Algorithms of Oppression} offers a long list of other models with
discriminatory properties~\citemain{noble18}.


Black-Box vs. White-Box: Understanding
Their Advantages and Weaknesses From
a Practical Point of View
https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8882211


fft trees paper
'


Perspective
Published: 13 May 2019
Stop explaining black box machine learning models for high stakes decisions and use interpretable models instead
Cynthia Rudin 
Nature Machine Intelligence volume 1, pages206–215 (2019)Cite this article
https://www.nature.com/articles/s42256-019-0048-x


fooling lime slack


[^vilone]: Vilone, Giulia & Longo, Luca. (2020). 
  [Explainable Artificial Intelligence: a Systematic Review](https://arxiv.org/pdf/2006.00093.pdf). 
  10.48550/arXiv.2006.00093.


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
