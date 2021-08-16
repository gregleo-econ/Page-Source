+4

# Code Golf: Abundant Numbers and Floats

From [Here](<https://code.golf/abundant-numbers>](https://code.golf/abundant-numbers):

*An abundant number is a number for which the sum of its proper divisors (divisors not including the number itself) is greater than the number itself. For example **12** is abundant because its proper divisors are **1**, **2**, **3**, **4**, and **6** which add up to **16**.*

*Print all the abundant numbers from **1** to **200** inclusive, each on their own line.*

## Code: (71 Characters)

This code takes advantage of coercing a vector to a column by doubly-applying transpose "t". This is bending the rules a little since the problem asks for just the numbers to be printed.

```{r abundant}
n=200
a=1:n
t(t(a[rowSums((outer(a,a,"%%")==0)*t(a%o%rep(1,n)))>=2*a]))
```
