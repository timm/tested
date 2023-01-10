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




# ROADMAP

To present this work as a syllabus, here is a weekly guide (assumes a 14 week semester)

|Week |Task|Lecture|Code (to reproduce)| Terms (to understand)|
|----|-----|-------|------------------|-----------------------|
|0   | fishing| [onFish](/docs/onFishing.md) |  - |  stakeholder, developer, bias, discrimination, decision space, objective space, $(W,X,Y,Z,B)$, fishing, active learning; why limited budgets?; semi-supervised learning; |
|1   | scripting| [onScript](/docs/onScript.md)| ([src](/src/script.lua)::[doc](/docs/script.md)::[out](/etc/out/script.out)) <br> do not use CLI or testing library (roll your own) |version control,test-driven development, red-green-refactor, command-line interfaces, regular expressions,random number seeds|
|2   | data| [onData](/docs/onData.md) | ([src](/src/data.lua)::[doc](/docs/data.md)::[out](/etc/out/data.out)) <br> do not use PANDAS or the like (roll your own) |coercion (string to thing), normal(Gaussian), Weibull, ,mean, median, mode, standard deviation, entropy, Welford, Aha, row (example), column (attribute, feature,goal)| 
|3   | clustering | [onCluster](/docs/onCluster.md)<br>[OnOptimise](/docs/onOptimize.md) | ([cluster](/src/cluster.lua)::[doc](/docs/cluster.md)::[out](/etc/out/cluster.out)) | distance, Euclidean, Aha, LSH, Fastmap, cosine rule, k-means, mini-batch k-means, out-liners, multi-goal, many-goal, bdom(binary domination); cdom(continuous domination, Zitzler)|
|4   | repertory grids| ([src](/src/grid.lua)::[doc](/docs/grid.md))::[out](/etc/out/grid.out)  | | requirements engineering|
|4b  | requirements engineering | | - | |
|5   | bins and trees|   |  | discretization, decision trees|
|5a  | data mining     | | - | |
|5b  | XAI             | | - | |
|6   | incompetency |    |  | anomaly detection|
|7   | knn, naive bayes|  |  | |
|8   | stats |           |  |  | | 
|9   | hpo |           |  |  | | 
|10  | DL |            |  |- | | 
|11  | theorem proving |  |- | | 

TBD: xai, optimization, theorem proving, commercial AI pipeline

After all that, students can end with a [four week project](docs/onProject.md).

## Hints for coding

To read this code, at first pass, think of it as some cut-down version of Python.
- But for the real deal, read [learnlua](https://learnxinyminutes.com/docs/lua/)

All code /src/X.lua has:
- a help file /docs/X.md
- a sample output file /etc/out/X.out. 
- and there may also be a support lecture /docs/onX.md.

This code (mostly)
follows the conventions described [here](https://github.com/timm/tested/blob/main/docs/onScript.md#some-coding-convetions).

To stop team members running over each other, bust up example files into many smaller files:
- one file per class
- a "lib" file for miscellaneous support stuff
- the test suite
- a main file that loads the rest
- Do this in a separate sub directory for each week. 
  - and in a sub-sub directory have `etc/out` where you store the outputs when you run (e.g.) `python3 week3.py -g all`.

Watch for small variations in the same class for different weeks. 
- Sometimes there are tiny changes in the code that are BIG changes in functionality
- So first thing is to run a `diff` on my code week[i-1], week[i]
