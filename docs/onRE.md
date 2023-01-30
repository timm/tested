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


(Hang on your hats oh students of AA cause in the next hour our study on automated SE will spend more time talking abut _people_ than _algorithms_.)

# Automated SE and Requirements Engineering

A common theme in many reports of algorthmic discrimination is that the developers of "it" are not sensitive (enough)
to the concerns of the people that use it.


Chapter six of Safiya Noble’s book Algorithms of Oppression [^1]  tells the sad tale of  how a design quirk of  Yelp ruined a small business. 
- As one of Noble’s interviewees put it “ Black people don’t ‘check in’ and let people know where they’re at when they sit in my (hair dressing salon). i
  They already feel like they are being hunted;  they aren’t going to tell the Man where they are”. Hence, that salon fell in the Yelp ratings (losing customers) since its patrons rarely  pressed the   “checked-in”  button.  There are many  other examples where software engineers fielded AI models, without noticing biases in those models:
- Amazon had to scrap an automated recruiting tool as it was found to be biased against women [^2].
- A widely used face recognition software was found to be biased against dark-skinned women [^3] and dark-skinned men  [^4].
- Google Translate, the most popular translation engine in the world, shows gender bias. 
  “She is an engineer, He is a nurse” is translated into Turkish and then again into English becomes “He is an engineer, She is a nurse” [^5].  
- For our purposes, the  important point of the first Noble example is this: if software designers had been more intentional about soliciting feedback from 
    the Black community, then they could have changed how check-ins are weighted in the overall Yelp rating system.  
- As to the other examples, in each case there was some discriminatory effect which was easy to detect and repair [^6], but developers just failed to test for those biases.  

[^1]: Noble, Safiya Umoja. "Algorithms of oppression." Algorithms of Oppression. New York University Press, 2018.
[^2]: https://reut.rs/2Od9fPr
[^3]: https://news.mit.edu/2018/study-finds-gender-skin-type-bias-artificial-intelligence-systems-0212
[^4]: https://www.nytimes.com/2020/06/24/technology/facial-recognition-arrest.html
[^5]: https://science.sciencemag.org/content/356/ 6334/183
[^6]: Chakraborty, Joymallya, Suvodeep Majumder, and Tim Menzies. "Bias in machine learning software: why? how? what to do?." Foundations of Software Engineering, 2021

There is a solution to all these problems:
- if a small group of people build software for the larger community, 
- that smaller group needs to listen more to the  concerns of the larger community. 

For that to work, the smaller group of developers have to admit the larger group into their design processes– either via

-  changing the reward structures such that there are inducements for the few to listen to the many (e.g. by better government legislation or  professional standards); 
- or (b) inclusion practices that admits the broader community into the developer community;
- or by (c) review practices where the developers can take better and faster feedback from the community.  

This brings us to the issue of requirements engineering. And before we can talk about automated tools for requirements engineering, lets talk about why RE
is so difficult.

## Requirements Engineering

Ever asked an expert for their opinion? Ever been surprised how hard it can be for them to offer that opinion, clearly and succinctly? Ever wonder one?

Possibility1: Experts are not expert.a
- The initial methodology of Laboratory Life [^latour] involves an "anthropological strangeness" (40) in which the laboratory is a tribe foreign to the researcher. 
- As observers, they  describes the laboratory as "strange tribe" of "compulsive and manic writers ... 
  who spend the greatest part of their day coding, marking, altering, correcting, reading, and writing".
  Large and expensive laboratory equipment (such as bioassays or mass spectrometers) are interpreted as "inscription device[s]" 
  that have the sole purpose of "transform[ing] a material substance into a figure or diagram".
-  Describe the laboratory as a literary system in which mere statements are turned into facts and vice versa
-  Instead of attempting to do their studies more carefully to be sure they get the right answer, i
    scientists appear to only use as much care as they think will be necessary to defeat the counterarguments of their detractors and get the acclamation they desire for their work.

Possibility2: Expertise is not symbolic
- But some neural effect of brain juice washing around the cranium.
- Impossible to a extract a chunk of knowledge since knowledge is not in solid chunks;
  - rather it is a bunch of waves crashing around inside the brain.
- Automated support: neural nets 
  - not good for explanation
  - data hungry (for training). On the other hand, can handle very large data spaces
  - CPU hungry (for initial training). On the other hand, there are fast local tunings:
      - e.g. just fine tune the last layer of a deep learner
      - e.g. prompt engineering [^wang].

[^wang]: Chaozheng Wang, Yuanhang Yang, Cuiyun Gao, Yun Peng, Hongyu Zhang, and Michael R. Lyu. 2022. 
         [No more fine-tuning? an experimental evaluation of prompt tuning in code intelligence](https://arxiv.org/pdf/2207.11680.pdf). 
         In Proceedings of the 30th ACM Joint European Software Engineering Conference and Symposium on the Foundations of Software Engineering (ESEC/FSE 2022). Association for Computing Machinery, New York, NY, USA, 382–394. https://doi.org/10.1145/3540250.3549113

<img src="https://www.ask-flip.com/attachments/861563b5-37de-4898-abf3-076bea8edb22/thumbnail" align=right width=500>

Possibility3: People don't think, they remember (the instance-based reasoners)
- Human expertise is not a bunch of logical if-then rule stored in the brain
- Rather it is a set of remembered situations which we match, then adapt to the current context
- Automated support: partial match functions, distance functions that can handle many missing values, machine learning to build theories in the retain case,
    repair mechanisms to patch current or prior conclusions
  - e.g. ripple down rules
    - e.g. interpretation of biochemical assays (someone staring at 100s of lab results per day saying "ok,ok,ok,ok,ok,ok,whoops-better fix that one"
    - write down a rule  $R_1$ and its conclusions (initially, this will just be "if true then happy" (say).
      - tag this rule with the case $C_1$ that lead to $R_1$.
    - Run new cases $C_2,C_3,..$ etc over the rules
    - If any old rule $R_i$ makes the wrong conclusion for a new case $C_j$
      - the repair must be in the delta between the current case and the old case $C_i$ from old rule $\delta=C_j - C_i$.
      - ask an oracle (humans) to say what parts of $\delta$ explain why $C_j$ needs a different conclusion $\epsilon \subseteq \delta$.
      - patch $R_i$ with the "except" clause $\epsilon$ so it $R_i$ is triggered **AND** the unless clause is true, then return the conclusion of $C_j$.
    - Overtime, this grows into a patch tree of nested "except" clauses
    - Historically, kind of offending a lot of people
      - very little initial domain structuring
      - then just make it up as you go along, bumbling through the world, stumbling on cases.
    - Surprisingly effective[^comp]

<img src="https://static.cambridge.org/binary/version/id/urn:cambridge.org:id:binary-alt:20160714021723-30702-mediumThumb-S0269888909000241_fig4g.jpg?pub-status=live">

<img src="/etc/img/rdrdata.png">

<img src="/etc/img/rdradd.png">


[^kol]: Kolodner J. Case-based reasoning. Morgan Kaufmann; 2014 Jun 28.
[^latour]: Laboratory Life: The Social Construction of Scientific Facts, Bruno Latour and Steve Woolgar,  Sage Publications, Beverly Hills, 1979.
[^comp]: Compton, P., Peters, L., Edwards, G., & Lavers, T. G. (2006). Experience with ripple-down rules. In Applications and Innovations in Intelligent Systems XIII: Proceedings of AI-2005, the Twenty-fifth SGAI International Conference on Innovative Techniques and Applications of Artificial Intelligence, Cambridge, UK, December 2005 (pp. 109-121). Springer London.

ripple down rules
instance based reasonng
lab life

Readings: 
- [^malt21], 
- [^easter07]: case study, repgrids
- [^carla19]: many methods 


[^carla18] [Requirements elicitation techniques: a
systematic literature review based on the
maturity of the techniques](https://www.evernote.com/shard/s14/sh/ca43b13b-9399-49a6-b709-22d42be41949/6d9cabfe33843c64a9be8d6d3273269f)
Carla Pacheco,
Ivan García,
Miryam Reyes.
IET Software,
2018, Vol. 12 Iss. 4, pp. 365-378
doi: 10.1049/iet-sen.2017.0144


[^easter07] N. Niu and S. Easterbrook, 
["So, You Think You Know Others' Goals? A Repertory Grid Study,"](https://homepages.uc.edu/~niunn/papers/SW07.pdf)
in IEEE Software, vol. 24, no. 2, pp. 53-61, March-April 2007, doi: 10.1109/MS.2007.52.
