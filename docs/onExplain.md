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



# Explanation

## ASE23 Homework

[ [code](/src/xpln.lua) | [required output](/etc/out/xpln.out) ]

## Things to Watch For
The following ideas will be useful for the final project

- the _sampling tax_: if we only look at small percent of the data, then we may miss some important features
- the _explanation tax_ : simplistic explanations of  complex multi-dimensional spaces can behave poorly.
- _explanation variance_ : explanations generated from a few random probes of a complex multi-dimensional
   can be widely variable.

## Quotes on Explanation

_If you cannot – in the long run – tell everyone what you have been doing, your doing has been worthless._  
- Erwin Schrödinger

_A theory that you can't explain to a bartender is probably no damn good_    
-  Ernst Rutherford

## Explanation in SE

For some good clean fun, have a read about explanation and sewer control [^malt21].
- Offers a very practical example of how explanation can be used in modern SE.

[^malt21]: [XAI Tools in the Public Sector: A Case Study on Predicting Combined Sewer Overflows](https://www.evernote.com/shard/s14/sh/25f4e214-e798-4fea-b978-e70426adb942/c17a39dbe423d1ec88dec8c7633ba365)
Nicholas Maltbie, Nan Niu, Matthew Van Doren, and Reese Johnson. 2021.
Proceedings of the 29th ACM Joint European Software Engineer-
ing Conference and Symposium on the Foundations of Software Engineering
(ESEC/FSE ’21), August 23ś28, 2021, Athens, Greece.


From Chen et al. [^chen18]:
- If no human ever needs
to understand a model, then it does not need to be comprehensible.
For example, a neural net could control the carburetor of an internal
combustion engine since that carburetor will never dispute the model
or ask for clarification of any of its reasoning. 
- On the other
hand:
   - if a model is to be used to persuade software engineers to
   change what they are doing, it needs to be comprehensible so humans
   can debate the merits of its conclusions
   - Several researchers
   demand that software analytics models needs to be expressed in a
   simple way that is easy for software practitioners to interpret
   [^dam, ^rahul].
   - According to Kim et al. [^kim], software analytics aim
   to obtain actionable insights from software artifacts that help
   practitioners accomplish tasks related to software development,
   systems, and users.
   - Sawyer et al.
   comments that actionable insight is the key driver for businesses
   to invest in data analytics initiatives [^sawyer]. 

Cynthia Rudin is adamant on the need for interpretable models [^rudin].
- She laments the proprietary COMPAS model, which contains hundreds of variables, and is sold by a marketing team as part of a
"risk reduction" platform. 
- She compares it to a three line open source model, which has a similar performance,
and is not marketed by anyone. 
- Rhetorically, she asks which would you want to use?

[^rudin]: Stop explaining black box machine learning models for high stakes decisions and use interpretable models instead
 Cynthia Rudin 
 Nature Machine Intelligence volume 1, 206–215 (2019)
 https://www.nature.com/articles/s42256-019-0048-x

[^chen18]: Di Chen, Wei Fu, Rahul Krishna, and Tim Menzies. 2018. Applications of psychological science for actionable analytics. In Proceedings of the 2018 26th ACM Joint Meeting on European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE 2018). Association for Computing Machinery, New York, NY, USA, 456–467. https://doi.org/10.1145/3236024.3236050
[^sawyer]: Robert Sawyer. 2013. BIâĂŹs Impact on Analyses and Decision Making Depends
  on the Development of Less Complex Applications. In Principles and Applications
  of Business Intelligence Research. IGI Global, 83–95
[^kim]: Miryung Kim, Thomas Zimmermann, Robert DeLine, and Andrew Begel. 2016.
  The Emerging Role of Data Scientists on Software Development Teams. 
  In Proceedings of the 38th International Conference on Software Engineering (ICSE ’16). ACM,
  New York, NY, USA, 96–107. DOI:http://dx.doi.org/10.1145/2884781.2884783
[^rahul]: Rahul Krishna and Tim Menzies. 2015. 
  Actionable= Cluster+ Contrast?. In Automated Software Engineering Workshop (ASEW), ASE'15.
[^dam]: Hoa Khanh Dam, Truyen Tran, and Aditya Ghose. 2018. Explainable software analytics. 
   In Proceedings of the 40th International Conference on Software Engineering: New Ideas and Emerging Results (ICSE-NIER '18). Association for Computing Machinery, New York, NY, USA, 53–56. https://doi.org/10.1145/3183399.3183424

More generally, in SE, there are many available models-as-a-service,
not all of which can be   inspected. "Model stores" are cloud-based
services that charge a fee for using models hidden away behind a
firewall (e.g. AWS market-place, and the Wolfram neural net repository.
Adams et al. [^xiu] discusses model stores (also known as  "machine
learning as a service"), and warns that  these models  are often
low quality   (e.g. if it comes from  a hastily constructed prototype
from a Github repository, dropped into a container, and then sold
as a cloud-based service). Ideally, we use software testing to
defend ourselves against potentially low quality models. But   model
owners may not publish verification results or detailed specifications--
which means standard testing methods are unsure what to test for.

[^xiu]: M. Xiu, Z. M. J. Jiang and B. Adams, "An Exploratory Study of Machine Learning Model Stores," in IEEE Software, vol. 38, no. 1, pp. 114-122, Jan.-Feb. 2021, doi: 10.1109/MS.2020.2975159.]

[^slack]: D. Slack, S. Hilgard, E. Jia, S. Singh, and H. Lakkaraju, “Fooling
LIME and SHAP: Adversarial attacks on post hoc explanation
method" in 3rd AAAI/ACM Conference on AI, Ethics, and Society,
2020

[^noble]: Algorithms of Oppression  
How Search Engines Reinforce Racism
by Safiya Umoja Noble
Published by: NYU Press, 2018


<img align=right width=300 src="/etc/img/lime.png">

An alternative to standard testing is to run an _explanation_ algorithm that offers a high-level picture of 
how model features influence each other. Unfortunately,  the better we get at  generating explanations,
the better we also get at generating misleading explanations. 
For example, Slack et al.'s lying algorithm [^slack]
knows how to detect explanation algorithms.
That liar algorithm can then switch to  models which, by design,   disguise  biases against  marginalized groups (e.g. some specific gender, race, or age grouping). 

The Slack et al.'s results are particularly troubling.
An alarming number   commercially deployed models  having discriminatory properties [^noble]
For example, the (in)famous COMPAS model decides the likelihood of a criminal defendant reoffending. 
The model suffers from alarmingly different false positive rates for Black defendants than White defendants.  Noble's
book _Algorithms of Oppression_ offers a long list of other models with
discriminatory properties [^noble].

Adadi and Berrada [^adadi] identified 17 XAI techniques by surveying
381 papers published between 2004 and 2018.
- According to the survey, most 
recent work done in the XAI field offers a post-hoc, local
explanation. 
- In this class we explore semi-local explanation (generating explanations after generating different classes).


[^adadi]: Adadi, Amina and Mohammed Berrada. 
  [“Peeking Inside the Black-Box: A Survey on Explainable Artificial Intelligence (XAI).”](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8466590)
IEEE Access 6 (2018): 52138-52160.

If a model is not comprehensible, there are some explanation
algorithms that might mitigate that problem. For example:
- In _secondary learning_ (or post-hoc learning) the examples given to (say) a neural network
are used to train a rule-based learner and those learners could
be said to “explain” the neural net [13].
-  In contrast set learning for instance-based reasoning, data is
clustered and users are shown the difference between a few
exemplars selected from each cluster (see below)

Such explanation facilities are post-processors to the original learning method. 
An alternative simpler approach would be to use learners that generate comprehensible models in the first place
e.g. see [^chen18].

## Explanation via contrast set learning for instance-based reasoning 

Data is
clustered and users are shown the difference between a few
exemplars selected from each cluster.

Procedurally, this means the rules are built from the bins you generated last week. That is:
- first you build the clusters
- then find the ranges that distinguish (say) the best cluster from some random sample of the rest
- then you explore those ranges looking for  rules that select for the best cluster.

Important point:
- this rule generator does not evaluate any extra _y_ values
- rather, once it has the best cluster and some of the rest,
  - "success" means "can you find some constraint that selects for lots of best and not much of rest".


Just to visualize that, suppose we have these clusters:

```
398  {:Acc+ 15.6 :Lbs- 2970.4 :Mpg+ 23.8}
| 199
| | 99
| | | 49
| | | | 24  {:Acc+ 17.3 :Lbs- 2623.5 :Mpg+ 30.4}
| | | | 25  {:Acc+ 16.3 :Lbs- 2693.4 :Mpg+ 29.2}
| | | 50
| | | | 25  {:Acc+ 15.8 :Lbs- 2446.1 :Mpg+ 27.2}
| | | | 25  {:Acc+ 16.7 :Lbs- 2309.2 :Mpg+ 26.0}
| | 100
| | | 50
| | | | 25  {:Acc+ 16.2 :Lbs- 2362.5 :Mpg+ 32.0}
| | | | 25  {:Acc+ 16.4 :Lbs- 2184.1 :Mpg+ 34.8} <== best
| | | 50
| | | | 25  {:Acc+ 16.2 :Lbs- 2185.8 :Mpg+ 29.6} 
| | | | 25  {:Acc+ 16.3 :Lbs- 2179.4 :Mpg+ 26.4}
| 199
| | 99
| | | 49
| | | | 24  {:Acc+ 16.6 :Lbs- 2716.9 :Mpg+ 22.5}
| | | | 25  {:Acc+ 16.1 :Lbs- 3063.5 :Mpg+ 20.4}
| | | 50
| | | | 25  {:Acc+ 17.4 :Lbs- 3104.6 :Mpg+ 21.6}
| | | | 25  {:Acc+ 16.3 :Lbs- 3145.6 :Mpg+ 22.0}
| | 100
| | | 50
| | | | 25  {:Acc+ 12.4 :Lbs- 4320.5 :Mpg+ 12.4}
| | | | 25  {:Acc+ 11.3 :Lbs- 4194.2 :Mpg+ 12.8} 
| | | 50
| | | | 25  {:Acc+ 13.7 :Lbs- 4143.1 :Mpg+ 18.0}
| | | | 25  {:Acc+ 14.4 :Lbs- 3830.2 :Mpg+ 16.4}
```
A "good" rule selects for lots of "best" and nothing much of the rest.

For example, suppose we generate we look at "best" and (say) a random sample of the rest. We might find these
ranges:


```lua
Clndrs	-inf	4
Clndrs	4	    inf

Volume	-inf	90
Volume	90	    115
Volume	115	    inf

Model	-inf	76
Model	76	    79
Model	79   	80
Model	80	    inf

origin	1	1
origin	2	2
origin	3	3
```
(Aside: note difference to last week. Here I demand ranges have to have at least 1/bins of the data.)

For example, here are all the ranges sorted by their "value" (described below).
Then _for i=1 to numberOfRanges_, we apply the first "i" ranges and see what happens.
Here, we return the rule that does best from that search.

So h
```lua
{:origin {3}}
{:Clndrs {{-inf 4}} :origin {3}}
{:Clndrs {{-inf 4}} :Volume {{-inf 90}} :origin {3}}
{:Clndrs {{-inf 4}} :Model {{79 80}} :Volume {{-inf 90}} :origin {3}}
{:Clndrs {{-inf 4}} :Model {{76 80}} :Volume {{-inf 90}} :origin {3}}
{:Clndrs {{-inf 4}} :Model {{76 80}} :Volume {{-inf 115}} :origin {3}}

-----------
explain=	{:origin {3}}
all               	{:Acc+ 15.5 :Lbs- 2800.0 :Mpg+ 20.0 :N 398}	{:Acc+ 2.71 :Lbs- 887.21 :Mpg+ 7.75 :N 398}
sway with     6 evals	{:Acc+ 16.6 :Lbs- 2019.0 :Mpg+ 40.0 :N 12}	{:Acc+ 2.6 :Lbs- 129.84 :Mpg+ 7.75 :N 12}
xpln on       6 evals	{:Acc+ 16.4 :Lbs- 2155.0 :Mpg+ 30.0 :N 79}	{:Acc+ 2.13 :Lbs- 349.61 :Mpg+ 7.75 :N 79}
sort with   398 evals	{:Acc+ 18.8 :Lbs- 1985.0 :Mpg+ 40.0 :N 12}	{:Acc+ 2.48 :Lbs- 200.39 :Mpg+ 0.0 :N 12}


For this week, we will apply a very simple greedy search fo

For example, 

