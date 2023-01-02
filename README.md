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

<!-- table>
<tr><td>Study guide </td><td>Sub-term
</td></tr><tr><td>data </td><td>
data: row (a.k.a. example, instance);
column (a.k.a. attribute, feature)
</td></tr><tr><td>learning type </td><td>
unsupervised or semi-supervised or supervised;<br>
instance or model-based<br>
</td></tr><tr><td>algorothm </td><td>
decision tree learning;
clustering;
FASTMAP (and cosine rule)<br>
</td></tr><tr><td>accountability </td><td>
logging, watched, presence<br>
</td></tr><tr><td>multi-objective reasoning </td><td>
domination, Pareto frontier, Zitzler predicate<br>
</td></tr><tr><td>misc </td><td>
stakeholder,
manifold, labelling cost, curse of dimensionality, explanation
</td></tr>
</table -->

<hr>

TESTED is  a semi-supervised, multi-objective, model-based
explanation system.
The code is a refactoring of decades of work by dozens of Ph.D. students.

TESTED assumes that the best way to test "it" is to watch someone else 
(specifically, stakeholders [^stake])
try to break "it".  TESTED lets  people  explore more and fix
more (but  sampling less around a system).

TESTED is not a pretty GUI. Rather, it is a programming toolkit that shows that
these kinds of tools are (very) simple to build.


[^stake]: Definition: "Stakeholders"  are individuals or organizations having
  a right, share, claim, or interest in a system or in its possession
  of characteristics that meet their needs and expectations 
  [(ISO/IEC/IEEE
  2015)](https://www.iso.org/standard/63711.html).

# Install

Install Lua:

    brew install lua       # on max os/x
    lua -v                 # TESTED needs at least LUA version 5.3

Check-out this repo

    git clone https://github.com/timm/tested

Check your installation

    cd tested/src
    lua 101.lua -g all # should show one crash and several passes

# What is TESTED??


When people like me
(i.e. a developer) write software that 
is used by other people 
(i.e. the stakeholders), those other people should be able to
- verify that the built software is right,
- validate that the right software is being built.

Such "stakeholder testing" is challenging since,
often, stakeholders may
not understand everything  about what goes on inside the code.
Hence stakeholder testing  needs special kinds of tools:
- one that helps helps
   humans find the   best things or fix the worst things;
- without
  having to offer too much information on each thing. 

The central claim of TESTED is that these:
**tools are surprisingly easy to build**. To say that another way:
- people can (and should) understand AI systems;
- then use those systems to build a better world.

Every tool is less than a few hundred lines of LUA code and all those tools share most of the same internal structure.
Students can learn this simpler approach to AI as a set of weekly homeworks where they recode the tools
in any language at all (except LUA).
Then, for graduate students, they can also do a final four week project
where they try  to improve on a stakeholder testing tool called "fishing", provided in this kit.

(Just an aside, the way I do homeworks is that every week, everyone
has to submit something, even if it is broken. Homeworks can get submitted multiple times
so I grade them "2" (for "good"); "1" (for "invited to resubmit"); "0" (for "bad" or "no submission".)

## What is "STAKEHOLDER TESTING"

Better methods for better searching for better solutions is important.
There are too many examples  of terrible software solutions.
For example:
- Amazon had to scrap an automated recruiting tool as it 
  was found to be [biased against women](https://reut.rs/2Od9fPr).
- A widely used face recognition software was found to be biased against 
  [dark-skinned women](https://news.mit.edu/2018/study-finds-gender-skin-type-bias-artificial-intelligence-systems-0212) and
  [dark-skinned men](https://www.nytimes.com/2020/06/24/technology/facial-recognition-arrest.html).
- Google Translate, the most popular translation engine in the world, 
  [shows gender bias](https://science.sciencemag.org/content/356/6334/183). 
  “She is an engineer, 
  He is a nurse” is translated into Turkish and then again into English becomes “He is an engineer, She is a nurse” [5].  
- Chapter six of Safiya Noble’s book Algorithms of Oppression [^noble] 
  tells the sad tale of  how a design quirk of  Yelp ruined a small business:
  As one of Noble’s interviewees put it "Black people don’t ‘check in’ and let people know where they’re at when they sit in my (hair dressing salon). 
  They already feel like they are being hunted;  they aren't going to tell the Man where they are". 
  Hence, that salon fell in the Yelp ratings (losing customers) since its patrons rarely  pressed the   “checked-in”  button. 

For our purposes, the  important point of the Noble example
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

The first two of these points requires major organization
changes. This repository is more about the third point which can we said another way:
from an ethical perspective, it is good
practice to give software to stakeholders and let them try to break
it. 

[^noble]: Noble, Safiya Umoja. "Algorithms of oppression." Algorithms of Oppression. New York University Press, 2018.
[^joy]: Chakraborty, Joymallya, Suvodeep Majumder, and Tim Menzies. "Bias in machine learning software: why? how? what to do?." Foundations of Software Engineering, 2021

Lets call that "stakeholder testing".


## Frequently Asked Questions

So what is TESTED really about?
- is it about how to reconfigure broken things to make them better? 
- is it about requirements engineering?
- is it about software engineering?
- is it about data mining?
- is it about testing?

To which the answer is "yes". All these things share the same underlying
methods and challenges. Which means tools built for one of these tasks
can help the other [^duo][^abduction]. 

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

[^duo]: [Better Software Analytics via "DUO": Data Mining Algorithms Using/Used-by Optimizers](https://arxiv.org/pdf/1812.01550.pdf)
  Amritanshu Agrawal, Tim Menzies, Leandro L. Minku, Markus Wagner, and Zhe Yu. 2020. 
  Empirical Softw. Engg. 25, 3 (May 2020), 2099–2136. https://doi.org/10.1007/s10664-020-09808-9

# Roadmap

To present this work as a syllabus, here is a weekly guide (assumes a 14 week semester)

|Week |Task|Lecture|Code (to reproduce)| Terms (to understand)|
|----|-----|-------|------------------|-----------------------|
|0   | fishing| [onFish](/docs/onFishing.md) |  - |  stakeholder, developer, bias, discrimination, $(x,y)$, fishing, active learning; semi-supervised learning; |
|1   | scripting| [onScript](/docs/onScript.md) | [script](/src/script.md) |version control,test-driven development, red-green-refactor, command-line interfaces, regular expressions,random number seeds|
|2   | data| [onData](/docs/onData.md) | [data](/src/data.md) |coercion (string to thing), normal(Gaussian), Weibull, ,mean, median, mode, standard deviation, entropy, Welford, Aha, row (example), column (attribute, feature,goal)| 
|3   | clustering| [onCluster](/docs/onCluster.md) | [cluster](/src/cluster.md) | distance, Euclidean, Aha, LSH, Fastmap, cosine rule, k-means, DBscan, kd-tree, multi-goal, many-goal, bdom(binary domination); cdom(continuous domination, Zitzler)|
|4   | repertory grids| 

After all that, students can end with a [four week project](docs/onProject.md).
