+2

# Matching Soulmates in R

```{r, IMSsetup, echo=FALSE}
#Operator "m %r% f" applies function "f" to matrix "m" by rows. 
`%r%` <- function(m,f){t(apply(m,1,match.fun(f)))}

#Operator "m %rm% i" removes rows and column indicies "i" from matrix "m". 
`%rm%` <- function(m,i){if(length(i)>0){m[-i,-i]}else{m}}  

#Operator applies function "f" across list "l" with sapply.
`%s%` <- function(l,f){sapply(l,match.fun(f))}

#Ensures objects is a matrix.
matrixify <- function(m){as.matrix(m)}

#Returns Hadamard product of matrix m with its transpose.
hadamard <- function(m){m * t(m)}

#Given preference matrix, returns vector of player indicies who are first-order soulmates.
whos_a_soulmate <- function(p){which((p%r%rank%>%hadamard%r%min)==1)}

#Removes first order soulmates from preference matrix p.
remove_soulmates <- function(p){p %rm% whos_a_soulmate(p) %>% matrixify}

#Recursively applies remove_soulmates until there's none left to remove.
ims <- function(p){if(dim(p)[1]==0 || identical(remove_soulmates(p),p)){p}else{ims(remove_soulmates(p))}}

#Create a random roommates preference matrix with "dim" players.
create_preference <- function(dim){
p <- matrix(runif(dim*dim),dim,dim)
diag(p)<- 1
p %r% rank
}
```

## Intro

In [Matching Soulmates](../2.%20Working%20Papers/MatchingSoulmates.html), my co-authors and I study a a recursive process in matching that
forms coalitions that are mutually most-preferred by members of that coalition. We call this process the iterated matching of soulmates: *IMS*. We show that mechanisms that implement IMS have strong properties among those who are matched by IMS. /

How many people can "usually" be matched by IMS? This depends a lot on the environment and structure of preferences. But what about in totally unstructured environments? /

Here is some R code that takes advantage of R's array-centric functions and some custom operators to count the number of people that can be matched as soulmates in 10000 random 10-person [stable roommates problems](https://en.wikipedia.org/wiki/Stable_roommates_problem). /

The core of this code is contained in the *whos_a_soulmate* function. This function is somewhat non-standard R code. It is inspired by the type of programming normally done in one of R's predecessors [APL](https://tryapl.org). Here is the function: /

```{r, whos, eval=FALSE}
whos_a_soulmate <- function(p){which((p%r%rank%>%hadamard%r%min)==1)}
```

Let's setup an example preference matrix. /

```{r, setupp, eval=TRUE}
p <- matrix(c(3,1,2,1,3,2,2,1,3),3,3,byrow=TRUE)
p
```

Plyer 1 likes 2 best, player 2 likes 1 best, player 3 likes 2 best. Note that 1 and 2 are soulmates. /

The first step of the function ensures the matrix "p" is a ranking matrix. We apply the "rank" function to the "p" matrix by row using the by-row operator created here. /

```{r, step1, eval=TRUE}
p %r% rank
```

Now we rake this matrix and take its Hadamard product with its own transpose by piping it to our "hadamard" function with the built-in R pipe. /

```{r, step2, eval=TRUE}
p %r% rank %>% hadamard
```

Note how off diagonal 1's in this matrix represent positions where both players prefer eachother most. /


Now we look for players who have a soulmatr by taking the min of each row (using the by-row operator). If a 1 is present, that player has a soulmate. /


```{r, step3, eval=TRUE}
p %r% rank %>% hadamard %r% min
```

Now we compare this vector to 1. The indicies that are equal to 1 are players who have a soulmate. /


```{r, step4, eval=TRUE}
p %r% rank %>% hadamard %r% min == 1
```

## Code

```{r, IMS, echo=TRUE}
#Operator "m %r% f" applies function "f" to matrix "m" by rows. 
`%r%` <- function(m,f){t(apply(m,1,match.fun(f)))}

#Operator "m %rm% i" removes rows and column indicies "i" from matrix "m". 
`%rm%` <- function(m,i){if(length(i)>0){m[-i,-i]}else{m}}  

#Operator applies function "f" across list "l" with sapply.
`%s%` <- function(l,f){sapply(l,match.fun(f))}

#Ensures objects is a matrix.
matrixify <- function(m){as.matrix(m)}

#Returns Hadamard product of matrix m with its transpose.
hadamard <- function(m){m * t(m)}

#Given preference matrix, returns vector of player indicies who are first-order soulmates.
whos_a_soulmate <- function(p){which((p%r%rank%>%hadamard%r%min)==1)}

#Removes first order soulmates from preference matrix p.
remove_soulmates <- function(p){p %rm% whos_a_soulmate(p) %>% matrixify}

#Recursively applies remove_soulmates until there's none left to remove.
ims <- function(p){if(dim(p)[1]==0 || identical(remove_soulmates(p),p)){p}else{ims(remove_soulmates(p))}}

#Create a random roommates preference matrix with "dim" players.
create_preference <- function(dim){
p <- matrix(runif(dim*dim),dim,dim,byrow=TRUE)
diag(p)<- 1
p %r% rank
}

#Set up parameters. "dim" is the number of players. "n" is the number of random trials. 
dim <- 10
n <- 10000

#Create List of "n" Preference Matricies with "dim" players.
preference_list <- lapply(1:n,function(x){create_preference(dim)})

#Apply IMS to the list of preferences then count the number of players remaining.
remaining <- preference_list %s% ims %s% dim 

#Get the number of players removed by IMS.
removed <- dim - remaining[1,]

#Make a table of frequencies of the number of removed players.
removed %>% table/n

```

