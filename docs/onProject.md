## Project 

(Note: you may not understand some parts of the following... yet;  patience, dear reader.)


Using at least 10 data set for [here](https://github.com/timm/tested/tree/main/etc/data)
write a 
multi-objective  
semi-supervised explanation system:
- Multi-objective; i.e. $|Y|>1$
- Semi-supervised; i.e. given $N$ examples, you only have a limited budget
  $B_0 \ll N$ of times you can access the $Y$ values of any one example.
- Explanation (bonus marks): extract some _useful_ succinct summary from the data
  - here, _useful_ means if that summary is applied  to the data, then some 
   $m \ll N$ good examples
    will be selected (and "good" means "has good $Y$ values).

Note: avoid many-goal problems at this point. That will be bonus marks, below.

Expected Sections:

- Introduction 
  - First 4 paras:
    1. Everyone does X
    2. There is a problem with X
    3. We have a novel insight that means that problem might be solvable
    4.  So here's what we did. 
  - Section 1.1 : Structure of this paper
    - List of research questions and a very brief summary of your answers
    - List of overall contributions (the elevator speech, why is this paper is good).
    - Caveats (for this study, we did not explore Z because of Y)
- Related work
  - What every else did in the past
  - Why that is not good enough, for our purposes (i.e. why are we not doing it some old way)
  - What system from past work is state of the art (and will be used in your comparisons)
  - Note: your related work section must:
    - show that you've read around regarding related work
    - demonstrate your understand the multi-objective semi-supervised explanation problem.
    - show that thinking that lead to this new method.
- Methods
  - Algorithms
  - Data
  - Performance measures
  - Summarization methods
    - statistical methods, what you selected and why
      - please demonstrate that you understand effect size and significance testing
    - explaining any novel visualizations you will use in your results section (if there are any)
  - Note: please demonstrate that you actually have a clear understanding of all these methods.
- Results
   - Run with different y-sampling budgets $B_0\in$ (10,25,50,100,200,500...):
     - For different methods 
        - Compare your preferred method
            - to at least one prior state-of-the-art method;
            - to just selection $B_0$ items at random
            - to one of more  human-level sampling process (seeTable1 of Baltes et al.[^ralph])
        - Repeated 20 times (with different random number seeds)
        - Some presentation of median and spread of results over 20 runs 
        - Non-parametric effect size and significance tests
  - Perform a "prudence" study 
    - as sampling size increases, your proposed methods should get better
  - Discussion of your results divided into your research questions.
    - a clear commentary on what worked best
    - if any unusual results, then acknowledge them and comment on them
  - Tables, figures, with best results distinguished from the non-best
- Discussion
  - Threats to Validity
  - Discussion: any bigger picture insights not present in the rest of the text?
  - Future work: what you did not have time to do, what you suggest to do next
- Conclusion
- References

### Bonus marks

#### B1: Repeat the above for many-goal problems.

Defined above

#### B2: Perform a _REQUIREMENTS STUDY_
- For 5 humans, run 5 repertory grids studies. 
- Compare the results:
  - against a recursive bi-clustering  of the data plus
    some hierarchical feature selection
  - against results from other humans
  - Is there anyway way the intra-human views (or the view between human an data)
    can be aligned? (HINT: maybe not)
- Include a commentary on your experience with rep grids (any surprises?) 

#### B3: Perform a _FEBRUARY STUDY_ 
Requires an explanation facility, as described above.
- If analysts used budget $B_0$ in January to reach some conclusions, what is learned
   such that this kind of future analysis gets simpler.
- So pretend its February and we have come back to a some similar problem (like what was
      studied in January). Using what was learned in January, can the same task be solved
      with less budget $B_1 < B_0$?

#### B4: Perform an _ABLATION STUDY_
- Given a preferred method $M$ containing two to four main ideas
  - Disable (or change) each one  thing. If anything get worse, declare that thing important.

#### B5: Perform an _HPO study_
- Apply these minimal sampling methods to learning good $Z$ values for a learner
- Your goal should be to compare your minimal sampling methods with some established optimization method.

### Word limit

The following limits exclude references.

- No less that five pages,no more than eight 
- HARD LIMITS:
  - we will not grade after eight pages.
  - we will not read if less than five.
  - we will not read if it is the wrong format (see below)

### How to write

Create an overleaf.com account

- Go to https://www.overleaf.com/gallery/tagged/ieee-official
- Select :IEEE Bare Demo Template for conferences"
  -  https://www.overleaf.com/latex/templates/ieee-bare-demo-template-for-conferences/ypypvwjmvtdf
- Hit "open as template"
- Add your name and email to list of authors.
-  Add these lines before `\begin{document}`

         \usepackage[switch]{lineno}
         \linenumbers


[^ralph]: Baltes, S., Ralph, P. Sampling in software engineering research: 
          a critical review and guidelines. Empir Software Eng 27, 94 (2022).
          https://doi.org/10.1007/s10664-021-10072-8
          https://arxiv.org/pdf/2002.07764.pdf

