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


Hang on your hats oh students of AA cause in the next hour our 
study on automated SE will spend  more time talking abut _people_ than _algorithms_.

Also, in the following, where possible, we will talk about automated tools that can assist in the requirements collection process.
- Sometimes we will be taking about additional early lifecycle modeling to build a throw-away requirements model
  - From which we can derive the real systems's requirements
- Sometimes we will the talking about an RE process that _replaces_ the entire rest of the development (e.g. ripple down rules).

(Aside: for a thorough survey of RE methods, but perhaps not as deep diving as the following, see Carla 2018 [^carla18]).

[^carla18]: [Requirements elicitation techniques: a
systematic literature review based on the
maturity of the techniques](https://www.evernote.com/shard/s14/sh/ca43b13b-9399-49a6-b709-22d42be41949/6d9cabfe33843c64a9be8d6d3273269f)
Carla Pacheco,
Ivan García,
Miryam Reyes.
IET Software,
2018, Vol. 12 Iss. 4, pp. 365-378
doi: 10.1049/iet-sen.2017.0144


# Automated SE and Requirements Engineering

Ever asked an expert for their opinion? Ever been surprised how hard it can be for them to offer that opinion, clearly and succinctly? Ever wonder why?

Note that unless we can address _that_ problem, then we can never expect to ask people "what is needed in this software?" and expect a straight answer.

## Possibility1: Experts are not expert.

<img width=400 align=right src="https://flcan.org/wp-content/uploads/2019/09/emperor-no-clothes.jpg">

The emperor  has no clothes. Experts can't say what they know since they don't know anything (more than anyone else).
- But the psychology of the people we all "experts" is such that their social standing depends on their ability to sound smart
- So ask them anything, they will tell you anything (even it if is sooo dumb).

Knowledge is a often myth, a social construct. 
- The initial methodology of Laboratory Life [^latour] involves an "anthropological strangeness" (40) in which the laboratory is a tribe foreign to the researcher. 
- As observers, they  describes the laboratory as "strange tribe" of "compulsive and manic writers ... 
  who spend the greatest part of their day coding, marking, altering, correcting, reading, and writing".
  Large and expensive laboratory equipment (such as bioassays or mass spectrometers) are interpreted as "inscription device[s]" 
  that have the sole purpose of "transform[ing] a material substance into a figure or diagram".
-  Describe the laboratory as a literary system in which mere statements are turned into facts and vice versa
-  Instead of attempting to do their studies more carefully to be sure they get the right answer, 
   - scientists appear to only use as much care as they think will be necessary to defeat the counterarguments of their detractors and get the acclamation they desire for their work.

Whoa! you say, that cannot be right! There are experts in the world, right, who do better than other people
- Survivor bias?
  - concentrating on entities that passed a selection process while overlooking those that did not
- Are they "expert"? or in a population of 8 billion people, and "luck" at probability 0.5,  
  20 people might get the 20 breaks (at odds $.5^{20}$) to select the 1000 "best" people in the world.


## Possibility2: Too Hard to Explain the World

You can ask for simple descriptions of a complex world

<img width=400 src="/etc/img/boundary.png">

Yeah... maybe not. Long history of cool simple rules that proved to be useful. E.g. recall the row/column selection example seen in past weeks (for privacy).

<br clear=all>

## Possibility3: Expertise not be expressed in words since it is not symbolic

Rather it is some neural effect of brain juice washing around the cranium.

- Impossible to a extract a chunk of knowledge since knowledge is not in solid chunks;
  - rather it is a bunch of waves crashing around inside the brain.

### Automated support for non-symbolic reasoning

Neural nets 
  - not good for explanation
  - data hungry (for training). On the other hand, can handle very large data spaces
  - CPU hungry (for initial training). On the other hand, there are fast local tunings:
      - e.g. just fine tune the last layer of a deep learner
      - e.g. prompt engineering [^wang].

[^wang]: Chaozheng Wang, Yuanhang Yang, Cuiyun Gao, Yun Peng, Hongyu Zhang, and Michael R. Lyu. 2022. 
         [No more fine-tuning? an experimental evaluation of prompt tuning in code intelligence](https://arxiv.org/pdf/2207.11680.pdf). 
         In Proceedings of the 30th ACM Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE 2022). Association for Computing Machinery, New York, NY, USA, 382–394. https://doi.org/10.1145/3540250.3549113


## Possibility4: People don't think, they remember 

<img src="https://www.ask-flip.com/attachments/861563b5-37de-4898-abf3-076bea8edb22/thumbnail" align=right width=500>

Welcome to instance-based reasoning.

- Human expertise is not a bunch of logical if-then rule stored in the brain
- Rather it is a set of remembered situations which we match, then adapt to the current context
- Often cited as how legal reasoning works
  - Lawyers often argue via precedence; i.e. apply old rulings to current cases

      <br clear=all>
<img width=400 align=right src="/etc/img/shank.png">

Stop press: Roger Schank, father of instance-based reasoning, died earlier this week.
You can't really talk about IBR without talking about Schank, who passed away just this month. 
He really [inspired and pissed off](https://educationoutrage.blogspot.com/)  a lot of people.

### Automated support for IBR
- clustering, partial match functions, distance functions that can handle many missing values, machine learning to build theories in the retain case,
  repair mechanisms to patch current or prior conclusions
- e.g. partial match are repair
  - partial match = distance to cluster centroids to select a near cluster
  - repair =  a minimal change to a  case such that it enters the space of known examples (in the near cluster)
- e.g. ripple down rules [^comp]
  - e.g. Interpretation of biochemical assays (someone staring at 100s of lab results per day saying "ok,ok,ok,ok,ok,ok,whoops-better fix that one"
  - write down a rule  $R_1$ and its conclusions (initially, this will just be "if true then happy" (say).
    - tag this rule with the case $C_1$ that lead to $R_1$.
  - Run new cases $C_2,C_3,..$ etc over the rules
  - If any old rule $R_i$ makes the wrong conclusion for a new case $C_j$
    - the repair must be in the difference between the current case and the old case $C_i$ from the old rule $\Delta=C_j - C_i$.
    - ask an oracle (humans) to say what parts of $\delta$ explain why $C_j$ needs a different conclusion
      - We call this the "except" clause $\epsilon \subseteq \Delta$.
      - It can be found very quickly: pop up $\epsilon$ in a list and let them go click-click and to pick a few items.
    - patch $R_i$ with the "except" clause $\epsilon$ 
      - now of  $R_i$ is triggered **AND** the unless clause is true, then return the conclusion of $C_j$.
  - Overtime, this grows into a patch tree of nested "except" clauses
  - Historically, the work kind of offended a lot of people
    - very little initial domain structuring
    - then just make it up as you go along, bumbling through the world, stumbling on cases.
  - Surprisingly effective: can maintain 1000s of rules in just a few minutes each day [^comp]

<img src="https://static.cambridge.org/binary/version/id/urn:cambridge.org:id:binary-alt:20160714021723-30702-mediumThumb-S0269888909000241_fig4g.jpg?pub-status=live">

<img src="/etc/img/rdrdata.png">

<img src="/etc/img/rdradd.png">


[^kol]: Kolodner J. Case-based reasoning. Morgan Kaufmann; 2014 Jun 28.
[^latour]: Laboratory Life: The Social Construction of Scientific Facts, Bruno Latour and Steve Woolgar,  Sage Publications, Beverly Hills, 1979.
[^comp]: Compton, P., Peters, L., Edwards, G., & Lavers, T. G. (2006). Experience with ripple-down rules. In Applications and Innovations in Intelligent Systems XIII: Proceedings of AI-2005, the Twenty-fifth SGAI International Conference on Innovative Techniques and Applications of Artificial Intelligence, Cambridge, UK, December 2005 (pp. 109-121). Springer London.
[^36]: Jill Larkin, John McDermott, Dorothea P. Simon, and Herbert A. Simon. 1980.
  [Expert and Novice Performance in Solving Physics Problems](https://www.researchgate.net/profile/John-Mcdermott/publication/281345564_Expert_and_Novice_Performance_in_Solving_Physics_Problems/links/5489c30f0cf214269f1abb55/Expert-and-Novice-Performance-in-Solving-Physics-Problems.pdf). 
  Science 208,
  4450 (1980), 1335–1342. DOI:http://dx.doi.org/10.1126/science.208.4450.1335
  arXiv:http://science.sciencemag.org/content/208/4450/1335.full.pdf


## Possibilitys5: Experts are experts because of "compiled knowledge"
The more you know something, the harder it is to articulate.

- Larkin et al. [^36] characterize human expertise in terms of
  - a very
    small short term memory, or STM (used as a temporary scratch
    pad for current observation)
  - and a very large long term memory,
    or LTM.
  - The LTM holds separate tiny rule fragments that explore
    the contents of STM to say “when you see THIS, do THAT”.
  - When
    an LTM rule triggers, its consequence can rewrite STM contents
    which, in turn, can trigger other rules.

Short term memory is very small, perhaps even as small as four
  to seven items [^12] [^52]
  -  Aside: Ma et al. [^40] used evidence from neuroscience and functional magnetic resonance imaging to
      argue that STM capacity might be better measured using other factors than “number of
      items”. But even they conceded that “the concept of a limited (STM) has considerable
      explanatory power for behavioral data”. 
Experts are experts, says Larkin et al. [^36]
  because the patterns in their LTM patterns dictate what to do,
  without needing to pause for reflection. 
- Experts become experts by packing in rules into the LTM
- maybe 5-10 new LTM rules per day. As Wong [^wong]:
  - In his book _Outliers: The Story of Succeess_,  Gladwell introduces the concept of the “10 000-Hour Rule” and how it helped the Beatles become world 
    famous musicians by having the opportunity to perform live as a group in Hamburg, Germany over 1200 times between 1960 and 1964. 
  - Although they initially started at strip clubs, they accumulated more than 10 000 hours by playing nonstop. 
  -  Throughout his book, Gladwell repeatedly refers to the “10 000-hour rule,” asserting that a pre-condition achieving true expertise in any skill is a matter of practicing, 
      albeit in the correct way, for at least 10 000 hours.
  - e.g. surgical residents,  spend roughly 70+ hours a week working, learning and breathing their craft.
    - With a 5-year residency program that runs 48 weeks a year, that is 16 800 hours of experience 
    - Ever wonder why its called a medical "practice"? Cause they are practicing their task.
Novices perform worse
  than experts, says Larkin et al., when they fill up their STM with
  too many to-do’s where they plan to pause and reflect on what to
  do next. 
Since, experts post far fewer to-do’s in their STMs, they
  complete their tasks faster because (a) they are less encumbered
  by excessive reflection and (b) there is more space in their STM
  to reason about new information. 
But the LTM rules are heavily cross-index to map STM contents to an action. 
- The more they are used, the faster we use them to skip to the next action
- So they less we can talk about them.

[^wong]: Wong NC. The 10 000-hour rule. Can Urol Assoc J. 2015 Sep-Oct;9(9-10):299. doi: 10.5489/cuaj.3267. PMID: 26644801; PMCID: PMC4662388.

While first proposed in 1981,
    this STM/LTM theory still remains relevant [^40].
- This theory can
    be used to explain both expert competency and incompetency in
    software engineering tasks such as understanding code [^69].
- Anytime anyone talks of visual cues or feature selection or any method by which our attention is directed from a mass of data
  to a tiny part of it
  - They are proposing methods to reduce how much stuff we are trying to pack into our STM.

[^40]: Wei Ji Ma, Masud Husain, and Paul M Bays. 2014. Changing concepts of working
i  memory. Nature neuroscience 17, 3 (2014), 347–356.
[^12]: N. Cowan. 2001. The magical number 4 in short-term memory: a reconsideration
   of mental storage capacity. Behav Brain Sci 24, 1 (Feb 2001), 87–114.
[^52]: George A Miller. 1956. The magical number seven, plus or minus two: some
   limits on our capacity for processing information. Psychological review 63, 2
  (1956), 81
[^40]: Wei Ji Ma, Masud Husain, and Paul M Bays. 2014. Changing concepts of working
  memory. Nature neuroscience 17, 3 (2014), 347–356.
[^69]: Susan Wiedenbeck, Vikki Fix, and Jean Scholtz. 1993. Characteristics of the
   mental representations of novice and expert programmers: an empirical study.
   International Journal of Man-Machine Studies 39, 5 (1993), 793–812.

### Automated support for LTM+STM

- Anything that directs the user from  a large amount of data to a small part 
  - i.e. finding the important stuff to put into STM such that the LTM can work.
- Tools for discovering tacit knowledge (see [repertory grids](onGrid.md);
- Divide the thinking into _feature extraction_ and _rules_
- Don't show people everything, just show them the most important features (for an example of feature selection, see below "rep grids").
- As to the rules, keep them small (so humans can easily process them). e.g. fast and frugal trees [^frugal].
  - Despite being simple, remarkably effective [^chenfse].

<img src="https://github.com/ndphillips/FFTrees/raw/master/man/figures/README-example-heart-plot-1.png">

[^frugal]: Phillips, N. D., Neth, H., Woike, J. K. & Gaissmaier, W. (2017). FFTrees: A toolbox to create, visualize, and evaluate fast-and-frugal decision trees. Judgment and Decision Making, 12 (4), 344–368. Retrieved from https://journal.sjdm.org/17/17217/jdm17217.pdf
[^chenfse]: Chen, D., Fu, W., Krishna, R., & Menzies, T. (2018, October). 
         [Applications of psychological science for actionable analytics](https://dl.acm.org/doi/pdf/10.1145/3236024.3236050?casa_token=5Wp-MiwBHoAAAAAA:VL646H96bnTZMUqn5A74kdB12DSWE8d3iRvuEOAMUa52scR90n741HOxKkjJPsDAaFRnvWJAX0ub). 
         In Proceedings of the 2018 26th ACM Joint Meeting on European Software Engineering Conference and Symposium on the Foundations of Software Engineering (pp. 456-467).

## Possibility5: Experts Can't Explain Themselves since  Explanations is Hard (actually, NP-Hard)

Explanations are not "one size fits all"
- they must be tuned to the task at hand
- and the person you are talking to (i.e. you have to express the explanation in terms of things they might understand).

Can we write that down formally? Well, yes we can. Welcome to logical  abduction [^poole] [^me]

[^poole]: Poole, David. ["Who chooses the assumptions?."](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=4c948fd3f0e0090abc75c3b3ef16aa1c1558f077) (1994).
[^me]: T.J. Menzies. 
    [Applications of Abduction: Knowledge Level Modeling. International Journal of Human Computer Studies](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=ce6cd441bc9a041a4ead96a91a531cace094f698),
     45:305–355, September, 1996. Available from

Given a theory $t$ and goals $g$ and assumptions $a$, can you get to the goals without causing problems?

$$ \mathit{rule}_1: t \wedge a \vdash g $$

$$ \mathit{rule}_2: \neg (t \wedge a \vdash \bot)$$

where  $\bot$ means 
"the oposite of truth" and is shown as "T" drawn upside down.


<img align=right width=400 src="https://user-images.githubusercontent.com/29195/192363104-7234e507-b622-4953-ac05-74982fb948b7.png">

- Rule1 is saying "do something" and rule2 is saying "don't mess up".
  - Rule1, by itself, is crazy fast (just dash forward) and do not care about the consequences.
  - But Rule2 means we have to check for errors as we goes. 
    -  Much slower.
    - In fact, after running these rules for away, you might realize that what you have is zero globally
      consistent solutions
      - E.g. students want private data while parents (who pay the student fees) might want access
        to student grades 
      - E.g. security and availability are usually contradictory. 
        - so the solutions fork, every time you face mutually incompatible choices.
    - But rather, multiple separate _worlds of belief_ that are internally _consistent_ but mutually _incompatible_.
  - What beliefs are incompatible in this _soft goal graph_ <br clear=all>

<img src="/etc/img/softgoal.png">

And the above softgoal is just one example of how contradictory are requirements:

<img src="https://user-images.githubusercontent.com/29195/192589531-be8abcb9-2a2a-4980-8ccb-c0ace4ef471d.png">

- In the general case, we cannot use all the assumptions $A$ or all the theory $T$ or reach all the goals $G$
  - so really, $a \subseteq A$;
  - so really, $g \subseteq G$;
  - so really, $t \subseteq T$;
  - Searching through all those subsets is also ssssssllllloooooowwwww.
- But wait, we are not finished:
  - Given we are exploring different subsets, they are multiple ways to solve this equation, so multiple _worlds_ of beliefs (different assumptions)
  - So if ever we generate any solution, we need to keep going to see what other worlds are out there.

Returning now to explanations
- given a set of things we known about $K \subseteq T$ then an explanation is world of belief with maximal overlap with $G$ and $K$.
- And guess what, expressed in this manner, it is intractably hard [^by] (i.e. it belongs to a class of problems for which there is no known complete and efficient solution).

So experts find it hard to explain themselves BECAUSE explanation is fundamentally hard.
- Think about that next time you are staring at a blank sheet of paper, with a headache, cause you cannot work out how to say what you want to say.

### Automated Support for NP-Hard Reasonong

But wait, there's a loophole.

- Just because your are theoretically NP-hard,
  - Does not necessarily mean you are slow in practice.
- Numerous AI researchers studying NP-hard tasks
report the existence of a small number of _key_ variables (also known as  _variable subset selection, narrows,
master variables_, and _backdoors_)
that
determine the behavior of the rest of the model. 
- When
such keys are present, then the problem of controlling an
entire model simplifies to just the problem of controlling
the keys.
- In the 1960s, Amarel
observed that search problems contain narrows; i.e. tiny sets
of variable settings that must be used in any solution [^a11].
    - Amarel’s work defined macros that encode paths between
      the narrows in the search space, effectively permitting a
      search engine to leap quickly from one narrow to another.
- In later work, data mining researchers in the 1990s
explored and examined what happens when a data miner
deliberately ignores some of the variables in the training
data. 
  - Kohavi and John report trials of data sets where up
    to 80% of the variables can be ignored without degrading classification accuracy [^kohavi]. 
  - Note the similarity with
    Amarel’s work: it is more important to reason about a small
    set of important variables than about all the variables
- At the same time, researchers in constraint satisfaction
   found “random search with retries” was a very effective
  strategy. 
  - Crawford and Baker reported that such searches
    took less time than a complete search to find more solutions
   using just a small number of retries [^craw].
  - Their ISAMP
    “iterative sampler” makes random choices within a model
    until it gets “stuck”; i.e. until further choices do not
    satisfy expectations.
     -  When “stuck”, ISAMP does not waste
        time fiddling with current choices (as was done by older
       chronological backtracking algorithms). 
     - Instead, ISAMP
       logs what decisions were made before getting “stuck”. It
       then performs a “retry”; i.e. resets and starts again, this
       time making other random choices to explore.
  - Crawford and Baker explain the success of this strange
approach by assuming models contain a small set of _master
variables_ that set the remaining variables (and  we might
call such master variables _keys_). 
  - Rigorously searching
through all variable settings is not recommended when
master variables are present, since only a small number of
those settings actually matter. 
  - Further, when the master
variables are spread thinly over the entire model, it makes
no sense to carefully explore all parts of the model since
much time will be wasted “walking” between the far-flung
master variables. 
     - For such models, if the reasoning gets
       stuck in one region, then the best thing to do is to leap at
       random to some distant part of the model.
- A similar conclusion comes from the work of Williams et
  al. [^will]. 
  - They found that if a randomized search is repeated
     many times, that a small number of variable settings were
     shared by all solutions. 
  - They also found that if they set
those variables before conducting the rest of the search,
then formerly exponential runtimes collapsed to low-order
polynomial time. 
  - They called these shared variables the
   _backdoor_ to reducing computational complexity

[^a11]: S. Amarel, “Program synthesis as a theory formation task: problem representations and solution methods,” in Machine Learning:
  An Artificial Intelligence Approach. Morgan Kaufmann, 1986.
[^craw]: J. M. Crawford and A. B. Baker, “Experimental results on the
  application of satisfiability algorithms to scheduling problems,”
  in Proceedings of the Twelfth National Conference on Artificial
  Intelligence (Vol. 2), Menlo Park, CA, USA, 1994, pp. 1092–1097.
[^kohavi]: R. Kohavi and G. H. John, “Wrappers for feature subset

[^easter07]: N. Niu and S. Easterbrook, 
  ["So, You Think You Know Others' Goals? A Repertory Grid Study,"](https://homepages.uc.edu/~niunn/papers/SW07.pdf)
   in IEEE Software, vol. 24, no. 2, pp. 53-61, March-April 2007, doi: 10.1109/MS.2007.52.

[^kelly]: Kelly, George A. ["A brief introduction to personal construct theory."](https://www.aippc.it/wp-content/uploads/2019/04/2017.01.003.025.pdf)
    Perspectives in personal construct theory 1 (1970): 29.
[^will]: R. Williams, C. P. Gomes, and B. Selman, “Backdoors to
  typical case complexity,” in Proceedings of the International
  Joint Conference on Artificial Intelligence, 2003.

Long story short:
- to tame complex non-deterministic problems, work backwards
  - do nott do a lot of stiff, then look for the keys
  - find the keys first, then reason within those contexts/
- Here I am proposing some random stagger followed by some data mining.

A standard method, used by many are _aquisition  functions_ in [onOPtimize](onOptimize.md) (which we will discuss next week).

But I have had much success in cheating, as follows:

- As soon as possible, find the fewest variables that separate the data
  - i.e. cluster and look for the deltas between clusters.
- e.g. Stagger around a little (e.g. with ISAMP or some other thing that runs around making random choices)
  - E.g. in  a state machine, take any out-arc at random.
  - If theory can deduce inconsistencies
    - check the next stagger is consistent with prior steps
    - if not then either backtrack OR  (ISAMP) just give up and go back to the start
      - but weight the next stager with good steps seen from the last stagger
      - for an example of this, see week11 (theorem provers).
- Then cluster what you get
- Then find the attribute ranges that are most different in different clusters (these are the _keys_)
- Then for consistent combinations of the keys
  - run the inference, restricted to that combination
- Can be crazy fast [^mathew]

<img src="/etc/img/cs.png">

<img src="/etc/img/shorter.png">

[^mathew]: George Mathew, Tim Menzies, Neil A. Ernst, John Klein:
   ["SHORT"er Reasoning About Larger Requirements Models](https://arxiv.org/pdf/1702.05568.pdf). RE 2017: 154-163


[^by]: Tom Bylander, Dean Allemang, Michael C. Tanner, John R. Josephson,
  The computational complexity of abduction,
  Artificial Intelligence,
  Volume 49, Issues 1–3,
  1991,
  Pages 25-60,



[^easter07]: N. Niu and S. Easterbrook, 
["So, You Think You Know Others' Goals? A Repertory Grid Study,"](https://homepages.uc.edu/~niunn/papers/SW07.pdf)
in IEEE Software, vol. 24, no. 2, pp. 53-61, March-April 2007, doi: 10.1109/MS.2007.52.
