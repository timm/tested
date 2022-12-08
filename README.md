&nbsp;<p><a name=top></a>

[Home](/README.md#top) :: [Tutorial]() :: [Issues](). [&copy;2022,2023](/LICENSE.md) by [Tim Menzies](http://menzies.us)

_____________

<img  width=600 src="/docs/img/banner.png">

# Hello!

TESTED is a set of data science coding assignments, written in Lua (which is a
small and simple Python-like language, but with far less overhead).
- Students use these samples as an executable specification which
they must reproduce in any other language they like (except Lua).
- Each of these assignments is about 1-2 weeks of work. 
- Hence, it is
suitable for homeworks or (by combining several modules) a large
end-of-term project.  

TESTED assumes that the best way to test something is to give it
to someone else, and watch them break it.  
- This is actually a core
principle of ethical programming.  
- Vance et al. [^Vance2016] argue that a
pre-condition for the accountability is the knowledge of an 
**external audience**, who could approve or disapprove of a system. 

Hence, TESTED has many tools for such external audiences:

- Operators for learning the boundaries of a system’s competency;
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

[^Vance2016]: Vance, Anthony, Paul Benjamin Lowry, and Dennis Eggett. 
  "Increasing Accountability Through User-Interface Design Artifacts." 
  MIS quarterly 39.2 (2015): 345-366.


 

[^Baltes22]: Baltes, S., Ralph, P. [Sampling in software engineering research: a critical review and guidelines](https://arxiv.org/pdf/2002.07764.pdf);  Empir Software Eng 27, 94 (2022);  https://doi.org/10.1007/s10664-021-10072-8.
	
[^Niu07]: Nan Niu, Steve M. Easterbrook: [So, You Think You Know Others' Goals? A Repertory Grid Study](https://www.cse.msstate.edu/~niu/papers/SW07.pdf); IEEE Softw. 24(2): 53-61 (2007) https://ieeexplore.ieee.org/document/4118651.
	
[^Vance13]:  Anthony Vance , Paul Benjamin Lowry & Dennis Eggett (2013); [Using Accountability to Reduce Access Policy Violations in Information Systems](https://www.tandfonline.com/doi/pdf/10.2753/MIS0742-1222290410); Journal of Management Information Systems, 29:4, 263-290;  DOI: 10.2753/MIS0742-1222290410.


## Install

Install Lua (version 5.3 or higher).

    # on mac os/x
    brew install lua

Check-out this repo

    git clone https://github.com/timm/tested

Check your installation

    cd tested/src
    lua 101.lua -g all # should show one crash and several passes


