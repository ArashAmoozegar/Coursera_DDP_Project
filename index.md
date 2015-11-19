---
title       : News Sentiment Analysis
subtitle    : (using Web Mining, NLP, Harvard GI Dictionaries, Shiny, and Slidify)
author      : Arash Amoozegar
job         : November 16, 2015
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Introduction

```r
"Hello!"
```

```
## [1] "Hello!"
```
The News Sentiment Analysis Shiny application, provides the most recent news sentiment for any of the S&P500 publicly-traded stocks in New York Stock Exchange. 

The application uses Web Mining to collect data and NLP and Dictionaries to match words from news articles to words in 8 different dictionaries. In order to calculate the sentiment, I calculate 4 pairs of opposing sentiments and report the average of these 4 pairs as the overall relative positivity of the news for that stock. 

In addition, the application presents the most recent news article along with its title, source, and timestamp. 

---

## Data

I use the [tm.plugin.webmining package in R](https://cran.r-project.org/web/packages/tm.plugin.webmining/vignettes/ShortIntro.pdf) to download the 20 most recent news articles from Google Finance. 

This package enables me to collect news articles along with their meta data including the articles title, source, and timestamp. 

---

## Methodology

After downloading the news articles, the code performs the following actions to calculate the sentiment:

I. Using 8 different dictionaries from [Harvard General Inquirer](http://www.wjh.harvard.edu/~inquirer/) dictionaries, the code counts the number of times each of the words in dictionaries appear in the article. These 8 categories are words signaling different sentiments (Positive or Negative, Active or Passive, Strong or Weak, Overstated or Understated). 

II. I use the 4 pairs of opposing 8 sentiments to calculate 4 ratios.

III. I find the average of these 4 pairs to report only one score indicating the positivity of the article. 

---

## Output Sample

![](http://s24.postimg.org/60thrds91/Pic.jpg)


```r
"Thank You and Bye!"
```

```
## [1] "Thank You and Bye!"
```
