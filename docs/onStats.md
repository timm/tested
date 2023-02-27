

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

# onStats.lua

## Your task this week

As a team, implement the [stats.lua](/src/stas.lua) examples shown in
[stats.out](/etc/out/stats.out)


## What Does "equal" Mean?

Take two stochastic search engines 
(e.g. simulated annealing and genetic algorithms).
Run them 10 times on the same problem.
Collect some scores.
Is one betters than another?

Example1

```
rx1.sa   10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
rx2.ga   12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
```

Is GA better than SA? How to find out?

When faced with new data, always chant the following mantra:

- First visualize it to get some intuitions;
- Then apply some statistics to double check those intuitions.

BTW, Sometimes, visualizations are enough:


- [CHIRP: A new classifier based on Composite Hypercubes on Iterated Random Projections](https://www.cs.uic.edu/~tdang/file/CHIRP-KDD.pdf)
- [Simpler Questions Can Lead To Better Insights](https://github.com/ds4se/chapters/blob/master/turhanb/theGraph.md), from
  Perspectives on Data Science for Software Engineering, Morgan-Kaufmann, 2015
  [Applications of Psychological Science for Actionable Analytics](https://download.arxiv.org/pdf/1803.05067v1.pdf)


But when you gotta do stats:

1. Visualize the data, somehow.
2. Check if the central tendency of one distribution is better than the other;
   e.g. compare their median values.
3. Check the different between the central tendencies is not some _small effect_.
4. Check if the distributions are _significantly different_;

So to kinds of tests, two kinds of background assumptions

| analysis| assumptions  | effect-size  | significance test|
|---------|---------------|-------------|-----------------|
|parametric | data look like bell-shaped curves| e.g. cohen's D | t-test|
|non-parametric | nil | cliff's delta | mann-whitney U test|


As to what value of d to use in this analysis, we take the advice of a
widely cited paper by Sawilowsky [^saw] (this 2009 paper has 1100 citations).
That paper asserts that “small” and “medium” effects can be measured using
d = 0.2 and d = 0.5 (respectively). Splitting the difference, we will analyze
this data looking for differences larger than d = (0.5 + 0.2)/2 = 0.35.

[^saw]: Sawilowsky, S.S.: New effect size rules of thumb. Journal of Modern Applied Statistical
Methods 8(2), 26 (2009)
