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

# Hello!

TESTED is a set of data science coding assignments, written in Lua (which is a
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
paints a picture of modern AI, dominated by deep learning,
where those current techniques are the inevitable, inexorable result of
centuries are prior thought. 
It is a great paper, well worth your time. But what is missing?

If you are a software engineer, you know that AI software is still
software and software needs to be tested.
So how do you and your stakeholders[^stake] test a complex AI system? 

[^stake]:  ("Stakeholders"  are individuals or organizations having
a right, share, claim, or interest in a system or in its possession
of characteristics that meet their needs and expectations 
[(ISO/IEC/IEEE
2015)](https://www.iso.org/standard/63711.html)

But before answering that, lets make sure we understand testing.
My own Ph.D. started out as a generic
testing mechanism. It took a while to realize
the obvious: testing "it" means being
able to exercise "it" so, properly designed, a generic test engine
is actually  a generic execution engine that can do many things[^abkl]
(and not just testing).

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


[^Baltes22]: Baltes, S., Ralph, P. [Sampling in software engineering research: a critical review and guidelines](https://arxiv.org/pdf/2002.07764.pdf);  Empir Software Eng 27, 94 (2022);  https://doi.org/10.1007/s10664-021-10072-8.
	
[^Niu07]: Nan Niu, Steve M. Easterbrook: [So, You Think You Know Others' Goals? A Repertory Grid Study](https://www.cse.msstate.edu/~niu/papers/SW07.pdf); IEEE Softw. 24(2): 53-61 (2007) https://ieeexplore.ieee.org/document/4118651.
	


## Homeworks

### Homework1: 101.lua Test-Driven Development

Since some students are stronger than others (w.r.t. scripting). So the
first task is more of a balancing exerice to get everyone up to speed.


