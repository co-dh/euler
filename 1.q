
/1. Sum of all multiples of 3 or 5 below 1000
sum {x where (0=x mod 3) or 0=x mod 5} til 1000
/2. sum of all even terms of Fibonacci sequence that <= 4,000,000
fib: 1 2
Next: {x,sum -2#x}
even:{x where 0=x mod 2}
sum even -1_{last[x]<4000000} Next/ fib
/3. Larget prime factor of 600851475143
x:600851475143
1+floor sqrt x



