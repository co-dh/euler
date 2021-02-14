/
# List all primes under X

## Naive mod and filter out
~~~q
    / Given an initial list of all number under 200 except 0 and 1
    show x: 2_til 200;  i:0
    
    / at first we filter out all number that can be divided by 2 except 2 itself
    show x:x where (x=x[i]) or 0<>x mod x[i]
    
    / then we increase i, so it point to 3
    show x i+:1
    
    / and filter by 3
    show x:x where (x=x[i]) or 0<>x mod x[i]
    / and we continue until i>sqrt cnt, since to test all prime < 100, there is no need to divide by 11.
~~~
\
listPrime:{[cnt]x:2_til cnt;i:0;while[x[i]<1+sqrt[cnt]; x:x where(x=x[i])or 0<>x mod x[i]; i+:1]; x}
/
~~~q
/ Verify by number of primes
4 25 168 1229~count each listPrime each 10 100 1000 10000

/ and how fast is it?
\ts listPrime 10*1000*1000
~~~
\

/
## Sieve of Eratosthenes
There are many divisions in the listPrime function. We can rid of them by use bit mask of 2, 3,5, 7, ...
~~~q
/ For numbers under 200,
n:200
/ A bitmask that filters out even numbers is like this:
n#01b

/ except 0 1 2 should not be filtered out, so we assign 1 to it.
where 0N!@[n#01b; til 3; :; 1b]

/ Similarly, a bitmask that filter out numbers that are dividable by 3 is:
where @[n#011b; til 4; :; 1b]
\

/return a bit mask of all numbers below n that can not be divided by d 
ndiv:{[n; d] @[n#0b,(d-1)#1b; til 1+d; :; 1b]}

/
~~~q
f: 2; m: ndiv[n;f] /Initially, the filter is 2, and m is non divisible mask of 2
~~~
\

/ next filter is the next number that are non divisiable by all previous filters  
nextFilter:{[f; m]w: where m; first w where w > f}

/
~~~q
nextFilter[2;m]
where ndiv[n; 3]

/ the new mask will give all numbers that are not dividable by 2 or 3
where m: m & ndiv[n; f:nextFilter[0N!f;m]]
where m: m & ndiv[n; f:nextFilter[0N!f;m]]
where m: m & ndiv[n; f:nextFilter[0N!f;m]]

/ and we continue until m > sqrt n
~~~
\
EraSieve:{[n] f: 2; m: ndiv[n;f]; while[f<sqrt n;m&:ndiv[n; f:nextFilter[f;m]]]; 2_ where m}

/
~~~q
4 25 168 1229 ~ count each EraSieve each 10 100 1000 10000
\ts EraSieve 10*1000*1000
~~~
It has the same speed as our naive solution, but use only half of the memory.

## Wheel sieve

Wikipedia has a very good explanation of Wheel factorization.

let's try it with
/~~~q
n: 2 3 5
show wheelSize: prd n
/ let's find all composite of n under 30 as candidates
show c: 1+where not any 0=(1+til wheelSize) mod/: n
/ and all number of 30*x + c is also candidates.
c +/: 30 * til 3


\~~~

\

