+2 

# Blog  

## 4/30/22 11:47 AM @research

I am pleased to post a draft version of *Minimal Experiments* joint with [P.J. Healy](https://healy.econ.ohio-state.edu/).

![MinEx](../files/Images/minex.png)

## 2/13/22, 1:48 PM @misc
Just like everyone else, I have been playing Wrodle. Here are notable solutions.   

Wordle 239 2/6  

🟩⬛⬛🟩🟩  

🟩🟩🟩🟩🟩  


Wordle 228 3/6   

⬛⬛🟨🟨⬛  

🟨⬛🟨⬛⬛  

🟩🟩🟩🟩🟩  


Wordle 225 4/6  

🟨⬛⬛⬛🟨  

⬛⬛⬛⬛⬛  

⬛🟩🟩🟩🟩  

🟩🟩🟩🟩🟩  


Wordle 212 3/6  

This was my first game of Wordle. Getting this in three hooked me on the game.  

🟨🟨🟨🟨⬛  

🟩⬛🟩🟩🟩  

🟩🟩🟩🟩🟩  

## Chocolate Flavors 1/18/22 @programming

This week’s [Tidy Tuesday](https://github.com/rfordatascience/tidytuesday) data is a record of chocolate ratings. I created a simple Shiny App that provides a text description of chocolates in a certain cocoa percentage range. For instance:

``Chocolates with cocoa percentage ranging from 85% to 100% are most often described as: bitter, spicy, earthy, intense, and mild-bitter. They most often originate from: Blended Origins, Ecuador, and Belize.``

https://g-econ.shinyapps.io/chocolate/

## Flight of the Bumblebees 1/10/22 @programming

[Tidy Tuesday](https://github.com/rfordatascience/tidytuesday) is a weekly data science “challenge” for the R community. This week’s dataset tracks bee colonies in the US over the past few years.  

This week, I made an R Shiny web app that converts data on the number of colonies in each state into a song. My favorite state is listen to is Georgia (my home state). When played fast enough, these little songs sound vaguely like [Flight of the Bumblebee](https://www.youtube.com/watch?v=M93qXQWaBdE).

[The app can be found here](https://g-econ.shinyapps.io/Flight_of_the_Bumblebees). 

*At the moment it does not work on iphone, but has been tested on windows, linux, and android.*

## 12/01/21, 9:15 PM @computing

Happy new year!

During winter break, I worked on a new project using my 3d printer. I attached a small keybaord to a Raspberry Pi 4 and 7.9" waveshare screen to create a tiny linux terminal. It is easy to cary around, energy efficeint, and powerful enough for working on papers, taking notes, and editing my webpage. 

![Cyberdeck](../files/Images/cyberdeck.jpeg)

## Code Golf Abundant Numbers 11/15/21 @programming

The goal in *code golf* is to produce a program that solves a problem with as few characters as possible. Here is a code golf problem where R does pretty well.

This problem comes from [Here](<https://code.golf/abundant-numbers>](https://code.golf/abundant-numbers).

*An abundant number is a number for which the sum of its proper divisors (divisors not including the number itself) is greater than the number itself. For example **12** is abundant because its proper divisors are **1**, **2**, **3**, **4**, and **6** which add up to **16**.*

*Print all the abundant numbers from **1** to **200** inclusive, each on their own line.*

This code takes advantage of R’s matrix functions and operators. It is **46 Characters**

```{r abundant}
a=1:200
t(t(a[((!outer(a,a,”%%”))%*%a)>=2*a]))
```


## 11/4/21, 7:14 PM @academic

Andrew Dustan, Kristine Koutout and I have completed a new working paper: [Reduction in Belief Elicitation](../2.Working_Papers/Reduction.html).

## 11/1/21, 7:32 PM @computing

I am now on gopherspace at [gopher://gopher.gregcleo.com:70/](gopher://gopher.gregcleo.com:70/).

My gopher server runs in a docker container on a docker “swarm” in my raspberry pi zero cluster. Here’s a picture of this funny little server:

![Pi Zero Cluster](../files/Images/picluster.jpeg)

The [Gopher Protocol](https://mncomputinghistory.com/gopher-protocol/) is an alternative to HTTP that was created in 1991 at the University of Minnesota. It is a very simple protocol for the distribution of (primarily) text. Gopher has had a resurgence recently thanks to the “Small Internet” movement that aims to get away from the bloat and noise of the modern internet. I remember Gopher vaguely from my childhood. It’s a digital world that has been stuck in twilight for 25 years.

You have a few options for visiting Gopherspace. If you have Linux, you can use the Lynx browser, which supports both gopher and http. On Windows or Mac, you can look for a native gopher client, or use the Firefox add-on client called [“Overbite”](https://gopher.floodgap.com/overbite/). If you do not want to download a client, you can also use the [Floodgap Public Gopher Proxy](https://gopher.floodgap.com), which allows you to view the Gopherspace through your http browser.

## 10/25/21, 12:34 PM @computing

I write a lot of stuff in LaTeX, but I was curious what else was around when LaTeX was created. ChiWriter is a document editor for MsDos with built-in math fonts written by Cay Horstmann in 1986 (two years *after* the introduction of LaTeX). It’s awesome and available as abandonware on [Cay Hortsmann's Website.](https://horstmann.com/ChiWriter/)

So blue...

![ChiWriter in Action](../files/Images/chiwriter.png)

Here is a snip of the "printed" Postscript output.

![ChiWriter Output](../files/Images/chiwriteroutput.png)

## 10/16/21 @academic

I have added an updated working paper [Subgame Perfect Coalition Formation](https://gregcleo.com/2.Working_Papers/SPGS.html) (joint with Eugene Vorobeychik and Myrna Wooders).

In this paper, we analyze a dynamic coalition formation game, the "seqeuential proposer game". A player proposes a coalition. The players in that coalition accpet or reject the proposal. As long as each player is able to make enough proposals, the equilibrium outcome is Pareto optimal.

## 8/20/21 @academic

[Matching Soulmates](https://gregcleo.com/1.Papers/Matching_Soulmates.html) has been accepted in the Journal of Public Economic Theory. The latest version of the paper is available [here](https://gregcleo.com/files/Papers/PUB_Matching-Soulmates.pdf).

![xkcd 770](https://imgs.xkcd.com/comics/all_the_girls.png)
<center>[xkcd #770](https://xkcd.com/770/)</center>

## 8/12/21 @webpage

Welcome to my new website. This new website generator is written in R. The theme (which has since been updated), celebrates the [30th anniversary of the public World Wide Web](https://en.wikipedia.org/wiki/History_of_the_World_Wide_Web#1991%E2%80%931995:_The_Web_goes_public,_early_growth). See for instance: [Caine, Farber & Gordon](http://cfg.com).

This page builds automatically using github actions! This lets me update the page and add content from *anywhere*. In fact, I posted this update from my [Pocket C.H.I.P](https://opensource.com/article/17/2/pocketchip-or-pi).

![Pocket CHIP](../files/Images/pocketchip.jpeg)