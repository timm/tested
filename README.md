<center>
<p><a name=top></a><p>&nbsp;
<a href="/README.md#top">Home</a>
:: <a href="http:github.com/timm/tested/issues">issues</a> 
{{ <a href="/LICENSE.md">&copy;2022,2023</a> by <a href="http://menzies.us">Tim Menzies</a> }}
<hr>
<img  width=600 src="/docs/img/banner.png">
</center>

# Hello!

TESTED is a set of data science coding assignments, written in Lua (which is a
small and simple Python-like language, but with far less overhead).
- Students use these samples as an executable specification which
they must reproduce in any other language they like (except Lua).
- Each of these assignments is about 1-2 weeks of work. 
- Hence, it is
suitable for homeworks or (by combining several modules) a large
end-of-term project.  

(Just an aside, the way I do weekly programming homeworks is that every weekend, everyone
has to submit something, even if it is broken. Homeworks can get submitted multiple times
so I grade them "2" (for "good"); "1" (for "invited to resubmit"); "0" (for "bad" or "no submission".)

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

[^Vance2015]: Vance, Anthony, Paul Benjamin Lowry, and Dennis Eggett. 
  "Increasing Accountability Through User-Interface Design Artifacts." 
  MIS quarterly 39.2 (2015): 345-366.


[^Baltes22]: Baltes, S., Ralph, P. [Sampling in software engineering research: a critical review and guidelines](https://arxiv.org/pdf/2002.07764.pdf);  Empir Software Eng 27, 94 (2022);  https://doi.org/10.1007/s10664-021-10072-8.
	
[^Niu07]: Nan Niu, Steve M. Easterbrook: [So, You Think You Know Others' Goals? A Repertory Grid Study](https://www.cse.msstate.edu/~niu/papers/SW07.pdf); IEEE Softw. 24(2): 53-61 (2007) https://ieeexplore.ieee.org/document/4118651.
	


## Install

Install Lua (version 5.3 or higher).

    # on mac os/x
    brew install lua

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

## Homeworks

### Homework1: 101.lua Test-Driven Development

Since some students are stronger than others (w.r.t. scripting)
