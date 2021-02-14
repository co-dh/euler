
~~~q
~~~
# List all primes under X

## Naive mod and filter out
~~~q
/ Given an initial list of all number under 200 except 0 and 1
q)show x: 2_til 200;  i:0
2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 3..
q)
q)/ at first we filter out all number that can be divided by 2 except 2 itself
q)show x:x where (x=x[i]) or 0<>x mod x[i]
2 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53 5..
q)
q)/ then we increase i, so it point to 3
q)show x i+:1
3
q)
q)/ and filter by 3
q)show x:x where (x=x[i]) or 0<>x mod x[i]
2 3 5 7 11 13 17 19 23 25 29 31 35 37 41 43 47 49 53 55 59 61 65 67 71 73 77 ..
q)/ and we continue until i>sqrt cnt, since to test all prime < 100, there is no need to divide by 11.
~~~
~~~q
listPrime:{[cnt]x:2_til cnt;i:0;while[x[i]<1+sqrt[cnt]; x:x where(x=x[i])or 0<>x mod x[i]; i+:1]; x}
~~~
~~~q
/ Verify by number of primes
q)4 25 168 1229~count each listPrime each 10 100 1000 10000
1b
q)
q)/ and how fast is it?
q)\ts listPrime 10*1000*1000
4555 536871520
~~~
~~~q

~~~
## Sieve of Eratosthenes
There are many divisions in the listPrime function. We can rid of them by use bit mask of 2, 3,5, 7, ...
~~~q
/ For numbers under 200,
q)n:200
q)/ A bitmask that filters out even numbers is like this:
q)n#01b
01010101010101010101010101010101010101010101010101010101010101010101010101010..
q)
q)/ except 0 1 2 should not be filtered out, so we assign 1 to it.
q)where 0N!@[n#01b; til 3; :; 1b]
11110101010101010101010101010101010101010101010101010101010101010101010101010..
0 1 2 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 ..
q)
q)/ Similarly, a bitmask that filter out numbers that are dividable by 3 is:
q)where @[n#011b; til 4; :; 1b]
0 1 2 3 4 5 7 8 10 11 13 14 16 17 19 20 22 23 25 26 28 29 31 32 34 35 37 38 4..
~~~q

q)/return a bit mask of all numbers below n that can not be divided by d
q)ndiv:{[n; d] @[n#0b,(d-1)#1b; til 1+d; :; 1b]}
q)
~~~
~~~q
f: 2; m: ndiv[n;f] /Initially, the filter is 2, and m is non divisible mask of 2
~~~
~~~q

q)/ next filter is the next number that are non divisiable by all previous filters
q)nextFilter:{[f; m]w: where m; first w where w > f}
q)
~~~
~~~q
nextFilter[2;m]
3
q)where ndiv[n; 3]
0 1 2 3 4 5 7 8 10 11 13 14 16 17 19 20 22 23 25 26 28 29 31 32 34 35 37 38 4..
q)
q)/ the new mask will give all numbers that are not dividable by 2 or 3
q)where m: m & ndiv[n; f:nextFilter[0N!f;m]]
2
0 1 2 3 5 7 11 13 17 19 23 25 29 31 35 37 41 43 47 49 53 55 59 61 65 67 71 73..
q)where m: m & ndiv[n; f:nextFilter[0N!f;m]]
3
0 1 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 49 53 59 61 67 71 73 77 79 83 89..
q)where m: m & ndiv[n; f:nextFilter[0N!f;m]]
5
0 1 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 10..
q)
q)/ and we continue until m > sqrt n
~~~
~~~q
EraSieve:{[n] f: 2; m: ndiv[n;f]; while[f<sqrt n;m&:ndiv[n; f:nextFilter[f;m]]]; 2_ where m}
~~~
~~~q
4 25 168 1229 ~ count each EraSieve each 10 100 1000 10000
1b
q)\ts EraSieve 10*1000*1000
5727 218104368
~~~
It has the same speed as our naive solution, but use only half of the memory.

## Wheel sieve

Wikipedia has a very good explanation of Wheel factorization.

let's try it with a wheel of size 30=2*3*5.
~~~q
n: 2 3 5
q)show wheelSize: prd n
30
q)/ let's find all composite of n under 30 as candidates
q)show c: 1+where not any 0=(1+til wheelSize) mod/: n
1 7 11 13 17 19 23 29
q)/ and all number of 30*x + c is also candidates.
q)c +/: 30 * til 3
1  7  11 13 17 19 23 29
31 37 41 43 47 49 53 59
61 67 71 73 77 79 83 89
~~~

~~~q

q)
q)