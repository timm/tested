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


# Discretization

Here's a magic trick to make inference simpler, and to generate tiny theories:

- Take some data
- Find what values are different in different classes
- Divide numeric ranges to emphasis those differences
- Only reason about the most interesting ranges

This is called  _discretizaion_: 

> <em> the transformation a set of continuous attributes into discrete ones, by associating categorical values to intervals and thus transforming quantitative data into qualitative data[^garcia].</em>

For example, here the magic applied to diabetes data. Note that:
- No useful divisions were found for `pres`,and `skin` (and attributes whose ranges have the same distributions in all classes are boring)
- Most ranges make very little change to the default class distribution shown bottom right (blue:red = `not`:`diabetic` = 5:3).
  - But there are some beauties e,g, 
    - `plas=hi` is strongly associated with  for `diabetic`
    - `mass=lo` or `plas=lo` is strongly associated with `not`

<img src="/etc/img/diabetes.png" width=600>

For another example, suppose we can clustered some data:

```
398  {:Acc+ 15.6 :Lbs- 2970.4 :Mpg+ 23.8}
| 199
| | 99
| | | 49
| | | | 24  {:Acc+ 17.3 :Lbs- 2623.5 :Mpg+ 30.4}
| | | | 25  {:Acc+ 16.3 :Lbs- 2693.4 :Mpg+ 29.2}
| | | 50
| | | | 25  {:Acc+ 15.8 :Lbs- 2446.1 :Mpg+ 27.2}
| | | | 25  {:Acc+ 16.7 :Lbs- 2309.2 :Mpg+ 26.0}
| | 100
| | | 50
| | | | 25  {:Acc+ 16.2 :Lbs- 2362.5 :Mpg+ 32.0}
| | | | 25  {:Acc+ 16.4 :Lbs- 2184.1 :Mpg+ 34.8}
| | | 50
| | | | 25  {:Acc+ 16.2 :Lbs- 2185.8 :Mpg+ 29.6} <== best?
| | | | 25  {:Acc+ 16.3 :Lbs- 2179.4 :Mpg+ 26.4}
| 199
| | 99
| | | 49
| | | | 24  {:Acc+ 16.6 :Lbs- 2716.9 :Mpg+ 22.5}
| | | | 25  {:Acc+ 16.1 :Lbs- 3063.5 :Mpg+ 20.4}
| | | 50
| | | | 25  {:Acc+ 17.4 :Lbs- 3104.6 :Mpg+ 21.6}
| | | | 25  {:Acc+ 16.3 :Lbs- 3145.6 :Mpg+ 22.0}
| | 100
| | | 50
| | | | 25  {:Acc+ 12.4 :Lbs- 4320.5 :Mpg+ 12.4}
| | | | 25  {:Acc+ 11.3 :Lbs- 4194.2 :Mpg+ 12.8} <== worst
| | | 50
| | | | 25  {:Acc+ 13.7 :Lbs- 4143.1 :Mpg+ 18.0}
| | | | 25  {:Acc+ 14.4 :Lbs- 3830.2 :Mpg+ 16.4}
```

And then we use the same algorithm to wind our way down to the best leaf cluster:

```
398  {:Acc+ 15.6 :Lbs- 2970.4 :Mpg+ 23.8}
| 199
| | 100
| | | 50
| | | | 25  
| | | |   12 {:Acc+ 17.2 :Lbs- 2001.0 :Mpg+ 33.2}
```

Let _best_ be the 12 examples in best cluster and _rest_ be $|\text{best}|*4$ of
the others, picked at random (aside: why not use them all?)

Now we are going to divide all the numeric ranges into 16 buckets, then recursively
merge ranges with the same distribution in _best_ and _rest_. Here's what we get
(and on the RHS, we score how much of each class is selected by that range). Note that
- strongly associated with `best` are `volume=[90..115)` and `Cylinders=3` and `origin=3`  
- most associated with `rest` is `volume >= 115` 


```
all                                       {:best 12 :rest 48}

          [lo<=x< hi)
          ===========
Clndrs    -inf       3        | 0.08     | {:best 1}
Clndrs    3          4        | 0.64     | {:best 11 :rest 19}
Clndrs    4        inf        | 0.0      | {         :rest 29}

Volume    -inf     90         | 0.69     | {:best 9  :rest 3}
Volume    90      115         | 0.17     | {:best 3  :rest 6}
Volume    115     inf         | 0.0      | {         :rest 39}

Model    -inf      77         | 0.0     | {         :rest 30}
Model    77        78         | 0.28    | {:best 4  :rest 3}
Model    78        79         | 0.12    | {:best 2  :rest 3}
Model    79        80         | 0.43    | {:best 6  :rest 4}
Model    80       inf         | 0.0     | {         :rest 8}

origin    1         1         | 0.0     | {         :rest 33}
origin    2         2         | 0.0     | {         :rest 8}
origin    3         3         |0.87     | {:best 12 :rest 7}
```

Note that there are very few most powerful ranges
- This is a common result (i.e. a few things matter and the rest can go to he\*ck).
- Once we know the above, then all subsequent inference is just a search through a couple of ranges. Ezy,pezy.

## How to Discretize

There are so many ways to implement discretization [^garcia]:

[^garcia]: Salvador Garcia, Julian Luengo, Jose A. Saez, Victoria Lopez, and Francisco Herrera. 2013. 
  [A Survey of Discretization Techniques: Taxonomy and Empirical Analysis in Supervised Learning](/etc/pdf/discretization.pdf). 
  IEEE Trans. on Knowl. and Data Eng. 25, 4 (April 2013), 734–750. https://doi.org/10.1109/TKDE.2012.35


![](/etc/pdf/dischow.png)

<img align=right src="/etc/img/ewdefd.png" width=500>

Lets just list some simple ones:

- Unsupervised (make no reference to $x$ attributes):
  - EWD: equal width discretization:  `(max-min)/the.bins`
  - EFD: equal frequency discretization: sort numbers, divide into (say) 10% chunks
- Supervised (divide $x$ by reflecting on $y$)
  - EMD: entropy merge discretization
    - post-processor to unsupervised discretization:
      - divide into (say) 16 bins, then remove uninformative bins
      - recursively combine adjacent bins (if the parts are less informative than the combination)

eg. can `alive` supervise our discretization of `age`?

```
age | alive
----|------
  5 | y
500 | y
 33 | y
100 | n
 60 | y
800 | y
 10 | y
120 | n
 40 | y
200 | n  
 90 | n
700 | y
 99 | y
 50 | y
130 | n
999 | y
```
Step1, sort on `age`:

```
age | alive
----|------
  5 | y
 10 | y
 33 | y
 40 | y
 50 | y
 60 | y
 90 | n
 99 | y
100 | n
120 | n
130 | n
200 | n  
500 | y
700 | y
800 | y
900 | y
```
So we seem to have some long lived  aliens amongst us. 

Now one way to find our bins is to first divide the day into (say) five bins of size two,
then look for adjacent bins that are so similar that we can merge them:

```
age | alive | bins
----|-------|-----
  5 | y     | one
 10 | y     | one
 ------------------
 33 | y     | two
 40 | y     | two
 ------------------
 50 | y     | three
 60 | y     | three
 ------------------
 90 | n     | four
 99 | y     | four
 ------------------
100 | n     | five
120 | n     | five
 ------------------
130 | n     | six
200 | n     | six
 ------------------
500 | y     | seven
700 | y     | seven
 ------------------
800 | y     | eight
900 | y     | eight
```

See note the numbers of "alive=y" and "alive=n" are the same in bins one+two+three and five+six and seven+eight. And a similar pattern happens in the middle (but that 99 messes things up a little).
But accommodating a little bit of noise then we get three bins.

```
age | alive | combined bins
----|-------|-----
  5 | y     | one
 10 | y     | one
 33 | y     | one
 40 | y     | one
 50 | y     | one
 60 | y     | one
 ------------------
 90 | n     | two
 99 | y     | two
100 | n     | two
120 | n     | two
130 | n     | two
200 | n     | two
 ------------------
500 | y     | three
700 | y     | three
800 | y     | three
900 | y     | three
```

OK, lets code that up.

Note: in the above we did EMD as a port-processor to EFD (equal frequency discretization). 
It turns out that it is much easier to use EWD (equal width discretization)
instead (see below).



bins is size (900-5)/16=56

feature reduction is good
More generally, this process is based on the manifold assumption (used extensively in semi-supervised learning) that higher-dimensional data can be mapped to a lower dimensional space without loss of signal.
- In the following examples, the first attributes already occurring in the domain and the second uses an attribute synthesized from the data (the direction of greatest spread of the data)


<img width=500 src="https://user-images.githubusercontent.com/29195/131709651-2b8f6932-023a-479f-9505-0fffa1921ba0.png">


volumnes not points


explain things


show where things change


Decision tree learning is just recursive discretiztion


James Dougherty, Ron Kohavi, Mehran Sahami
[Supervised and Unsupervised Discretization of Continuous Features](/etc/pdg/dou95.pdf)
Twelfth International Conference, 1995, Morgan Kaufmann Publishers, San Francisco, CA.


 From: AAAI-92 Proceedings. Copyright ©1992, AAAI (www.aaai.org). All rights reserved.
[ChiMerge: Discretization of Numeric Attributes](/etc/pdf/chiMerge92.pdf)
Randy Kerber


[Discretization: An Enabling Technique](https://sci2s.ugr.es/keel/pdf/algorithm/articulo/liu1-2.pdf)
Huan Liu
Farhad Hussain 
Chew Lim Tan 
Manoranjan Dash
Data Mining and Knowledge Discovery, 6, 393–423, 2002


Ramírez-Gallego, Sergio & García, Salvador & Mouriño-Talín, Héctor & Martinez, David 
and Bolón-Canedo, Verónica & Alonso-Betanzos, Amparo & Benítez, José & Herrera, Francisco. (2015). 
[Data discretization: Taxonomy and big data challenge](https://www.researchgate.net/publication/284786447_Data_discretization_Taxonomy_and_big_data_challenge)
Discovery. 6. n/a-n/a. 10.1002/widm.1173. 


Equal-Width Discretization


Equal-Frequency Discretization


 Discretization with Decision Trees
