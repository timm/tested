<img src="docs/img/banner.png">

When trying new things, its good to thrash around for a while,
trying this and trying that. 

But afterwards, there should
be a clean-up stage where lessons learned from all the work are used
to
clarify and simplify the code.

So after 25 years of AI programming, here is my clean-up. 
Based on all that experience, this code makes
numerous short-cuts

- The data structures used in one AI tool and reused for another.

```mermaid
graph LR;
    NUM-->DATA-->NaiveBayes;
    SYM-->DATA;
    DATA-->clustering;
    clustering->semiSupervisedLearning;
    zitzler-->DATA-->optimization;
    DATA-->discretization;
    RANGE-->discretization;
    decisionTree-->contrast;
    decisionTree-->plan;
    decisionTree-->minitor;
```



It is offered as a teaching tool
for newbie AI people: 

- The code
is delivered in tiny chunks, each one suitable for a weekly homework
for a graduate class.  
- The code is written in Lua which is a pretty
simple Python-like high-level language. I ask my students to recode
all this, in some non-Lua language.

Share and enjoy. And please, write [issues](http://github.com/timm/lua/issues)
about the stuff that does not work or could work better.

## Contents
- **_[101](101.md)_: scripting 101. Handling command line. Test suites
- **_[about](about.md)_**: Collects stats **about** a csv file.
- **_[lib](lib.md)_**: Standard tricks.

## Motivation
The main goal here is to create systems that other people can understand, critique, 
and suggest modifications. But how to foster such accountability?

> Several mechanisms heighten an individual’s perception of
accountability: identifiability, awareness of logging, awareness
of audit, and electronic presence (_identifiability_ is a person’s
“knowledge that (their) outputs could be linked to (them)” and _presence_
is "a state of mind in which self-focused attention is increased and
performance is modified in the presence of those who can disapprove
or approve of actions")[^Vance13].


This code is an experiment in another way to teach AI. Instead of viewing AI as something machines do,
this code has tools that emulate how humans sample a domain[^Niu07] [^Baltes22]. Then we play the _fishing game_.
- First, all examples are labeled by some omniscient  being. The examples are sorted, most to least interesting (where "interesting" is a domain-specific criteria).
- Second, humans go fishing  using some of the known sampling strategies seen in qualitative research or cognitive science.
- Third, some AI algorithm goes fishing using anything at all.

These fishing policies are assessed via how well they find the most interesting examples. Note that
when fishing, humans or AI are run with various budgets of how many labels they can inspect. Committees of humans, for example, can offer 10 labels for 10 examples in about an hour
(generating those labels is easy but _justifying_ those labels takes much longer). Hence, budgets should range from dozens to millions (but only the algorithms can go fishing a million times).



This code is  also an experiment in ethical AI. AI is all too often viewed as a black-box algorithm that is too complex for mere mortals to understand.
That view complicates informed ethical disputes about
what the current code is doing;
what the current code _should_ be doing;
and what changes need to be made to the code.
So here's the experiment:
- Code up AI as simply as we can.
- Using symbolic learners (so people can read the model)
- Offer automatic tuning agents (to find options that people might have missed)
- Augment the above with  anomaly detectors  (to recognize things that are out-of-scope for these models)
- Benchmark the conclusions from an AI system against humans (using the fishing game);
- Benchmark this simplicity approach against the more complex.

Warning: a repeated result in my research is that _my straw men do not burn_. XXX


## Short-cuts
This code
is all about three kinds of short-cuts:

- After building one AI tool, those data structures and algorithms can be mixed and
  matched to quickly implant another AI tool.

### Data Structures

DATA comes in tables and  tables have ROWs and columns (which are either NUMeric or SYMbolic).
ROWs divide into inputs or outputs, also known as independent or dependent. Dependent variables
are called various things such as classes, goals or objectives. Goals are usually numeric and
are things we want to minimize or maximize.

NUM and SYM and classes to incrementally summarize numeric and symbolic information. XXX keep. distance. discretmization


### Algorithms

#### Zitzler Multi-Objective "Domination" Predicate

Some ROWs are better than others. To sort the rows better to worse, some `__lt` operator. For
single objectives, that is just a simple "&lt;" operator. For multi-objectives, some 

 

[^Baltes22]: Baltes, S., Ralph, P. [Sampling in software engineering research: a critical review and guidelines](https://arxiv.org/pdf/2002.07764.pdf);  Empir Software Eng 27, 94 (2022);  https://doi.org/10.1007/s10664-021-10072-8.
	
[^Niu07]: Nan Niu, Steve M. Easterbrook: [So, You Think You Know Others' Goals? A Repertory Grid Study](https://www.cse.msstate.edu/~niu/papers/SW07.pdf); IEEE Softw. 24(2): 53-61 (2007) https://ieeexplore.ieee.org/document/4118651.
	
[^Vance13]:  Anthony Vance , Paul Benjamin Lowry & Dennis Eggett (2013); [Using Accountability to Reduce Access Policy Violations in Information Systems](https://www.tandfonline.com/doi/pdf/10.2753/MIS0742-1222290410); Journal of Management Information Systems, 29:4, 263-290;  DOI: 10.2753/MIS0742-1222290410.


