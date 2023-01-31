
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

# onGrid.lua

grid.lua implements an requirements engineering tool for finding tacit knowledge.
Why is that improtant?

A common theme in many reports of algorithmic discrimination is that the developers of "it" are not sensitive (enough)
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

## Tool Support

How can we look outside our current tools? Find out what people really want? Without those questions being distorted by a 100 existing design decisions.

- Optimizers, thoerem provers, data miners all explore the space of ideas in some data set or some program.
- But how do we break out of that myopic view?
- Look for the thing that we do not know, yet, but should?
- How do we find the tacid knowledge that lays around us, invisible to our current gaze?

Let's go ask George Kelly (1905–1967), American psychologist, therapist, educator and personality theorist. 


> "Who can say what nature is? Is it what now exists about us, including all the tiny hidden
things that wait so patiently to be discovered? Or is it the vista of all that is destined to occur,
whether tomorrow or in some distant eon of time? Or is nature, infinitely more varied than this,
the myriad trains of events that might ensue if we were to be so bold, ingenious, and irreverent
as to take a hand in its management?"<br>&nbsp;<br>
"Personal construct theory neither offers nor demands a firm answer to any of these questions, and in this respect it is unique. Rather than depending upon bedrock assumptions about
the inherent nature of the universe, or upon fragments of truth believed to have been accumulated, it is a notion about how man (sic) may launch out from a position of admitted ignorance, and
how he (sic)  may aspire from one day to the next to transcend his  (sic) own dogmatisms. It is, then, a
theory of man’s  (sic) personal inquiry—a psychology of the human quest. It does not say what has
or will be found, but proposes rather how we might go about looking for it."    
-- George Kelly


Repertory grids are a tool proposed by the  cognitive psychologist George Kelly as a method for eliciting  tacit knowledge. From [Wikipedia](https://en.wikipedia.org/wiki/George_Kelly_(psychologist)):

- Kelly believed in a non-invasive or non-directive approach to psychotherapy.
- Rather than having the therapist interpret the person's psyche (which would amount to imposing the doctor's constructs on the patient)
- The therapist should just act as a facilitator of the patient finding his or her own constructs. 
- The patient's behavior is then mainly explained as ways to selectively observe the world, act upon it and update the construct system in such a way as to increase predictability. 
To help the patient find his or her constructs, Kelly developed the repertory grid interview technique.

Kelly explicitly stated that each individual's task in understanding their personal psychology is to put in order the facts of his or her own experience. 

- Then the individual, like the scientist, is to test the accuracy of that constructed knowledge by performing those actions the constructs suggest.
- If the results of their actions are in line with what the knowledge predicted, then they have done a good job of finding the order in their personal experience.
- If not, then they can modify the construct: their interpretations or their predictions or both.
- This method of discovering and correcting constructs is roughly analogous to the general scientific method that is applied in various ways by 
   modern sciences to discover truths about the universe.


- Nui and Easterbrook comment that repertory grids are widely recognized as a domain-independent method for externalizing individuals’ personal constructs. 

Interviewees are invited to offer their own examples from their own domain. 
- Then they are asked: “Given 3 examples (picked at random), on what dimension is one example most different to the other two?”   

[^easter07]: N. Niu and S. Easterbrook, 
  ["So, You Think You Know Others' Goals? A Repertory Grid Study,"](https://homepages.uc.edu/~niunn/papers/SW07.pdf)
   in IEEE Software, vol. 24, no. 2, pp. 53-61, March-April 2007, doi: 10.1109/MS.2007.52.

[^kelly]: Kelly, George A. ["A brief introduction to personal construct theory."](https://www.aippc.it/wp-content/uploads/2019/04/2017.01.003.025.pdf)
    Perspectives in personal construct theory 1 (1970): 29.
