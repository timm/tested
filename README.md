&nbsp;
<a name=top></a>
<table><tr>
<td><a href="/README.md#top">Home</a>
<td><a href="http:github.com/timm/tested/issues">issues</a>
</tr></table>
<img  align=center width=600 src="/docs/img/banner.png"><br clear=all>

 <img src="https://img.shields.io/badge/task-ai-blueviolet"><a
href="https://github.com/timm/tested/actions/workflows/tests.yml"> <img 
 src="https://github.com/timm/tested/actions/workflows/tests.yml/badge.svg"></a> <img 
 src="https://img.shields.io/badge/language-lua-orange"> <img 
 src="https://img.shields.io/badge/purpose-teaching-yellow"> <a 
 href="https://zenodo.org/badge/latestdoi/569981645"> <img 
 src="https://zenodo.org/badge/569981645.svg" alt="DOI"></a><br>
<a href="/LICENSE.md">&copy;2022,2023</a> by <a href="http://menzies.us">Tim Menzies</a>

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

    brew install lua       # on max os/x

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

Since some students are stronger than others (w.r.t. scripting). So the
first task is more of a balancing exerice to get everyone up to speed.

DM1
- regular expressions [^Cox07] [^Thom68]
- incremental, when you can
- stochastic (see reservoir sampling)
  - control your seed (or else)
- NUMs, SYMs
- mid (middle) div(diversity)

- Lehmer [^Lehmer69] (a.k.a. Park-Miller)
- Fisher Yates shuffle [^Fisher38], randomizing in linear time, sorting in place
- resevoir sampling[^ResXX]  is a family of randomized algorithms for randomly choosing k samples from a list of n items,i
  where n is either a very large or unknown number. Typically n is large enough that the list does not fit into main memory. For example, a list of search queries in Google and Facebook.
- <img src="/etc/img/norm.png" align=right width=600>
  normal distribution [^deMoi1718]:  that probabilities associated with discretely 
  generated random variables (such as are obtained by flipping a coin or rolling a die) can 
  be approximated by the area under the graph of an exponential function.
  Generalized by  Laplace[^Laplace] 
  into the first central limit theorem, which proved that probabilities for almost 
  all independent and identically distributed random variables converge rapidly 
  (with sample size) to the area under an exponential function—that is, to a normal 
  distribution. 


- sd via Welford's algorithm [^Welford62]. This algorithm is much less prone to loss of precision due to catastrophic cancellation, 
- sd via resevoir
  - ±2, 2.58, 3 σ is 66,90,95%, of the mass.  So one standard deviation is (90-10)th divide by 2.58 times σ. To say that another way, the diversity
    can be computed by the difference between large numbers and small numbers in an array.
- Shannon entropy [^Shannon48] <img src="https://en.wikipedia.org/wiki/Entropy_(information_theory)#/media/File:Binary_entropy_plot.svg" align=right width=200>


[^Cox07]: Regular Expression Matching Can Be Simple And Fast (but is slow in Java, Perl, PHP, Python, Ruby, ...), Russ Cox rsc@swtch.com, January 2007
[^deMo1718]:  Schneider, Ivor (2005), "Abraham De Moivre, The Doctrine of Chances (1718, 1738, 1756)", in Grattan-Guinness, I. (ed.), Landmark Writings in Western Mathematics 1640–1940, Amsterdam: Elsevier, pp. 105–120, ISBN 0-444-50871-6.
[^Fisher38]: Fisher, Ronald A.; Yates, Frank (1948) [1938]. Statistical tables for biological, agricultural and medical research (3rd ed.). London: Oliver & Boyd. pp. 26–27. OCLC 14222135. 
[^Laplace]: Pierre-Simon Laplace, Théorie analytique des probabilités 1812, “Analytic Theory of Probability"
[^Lehmer69]: W. H. Payne; J. R. Rabung; T. P. Bogyo (1969). "Coding the Lehmer pseudo-random number generator" (PDF). Communications of the ACM. 12 (2): 85–86. doi:10.1145/362848.362860
[^ResXX]: Bad me. I can recall where on the web I found this one.
[^Shannon48]: Shannon, Claude E. (July 1948). "A Mathematical Theory of Communication". Bell System Technical Journal. 27 (3): 379–423. doi:10.1002/j.1538-7305.1948.tb01338.x. hdl:10338.dmlcz/101429. (PDF, archived from here)
[^Thom68]: Ken Thompson, “Regular expression search algorithm,” Communications of the ACM 11(6) (June 1968), pp. 419–422. http://doi.acm.org/10.1145/363347.363387 
  <a href="https://www.oilshell.org/archive/Thompson-1968.pdf">(PDF)</a>
[^Welford62]: Welford, B. P. (1962). "Note on a method for calculating corrected sums of squares and products". Technometrics. 4 (3): 419–420. doi:10.2307/1266577. JSTOR 1266577.

