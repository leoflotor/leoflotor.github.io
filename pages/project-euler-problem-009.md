+++
title = "PE problem 1"
date = Date(2025, 05, 15)
tags = ["coding", "project-euler", "sbcl", "a-lisp"]
hascode = true
lang = "plaintext"
+++

# Project Euler problem 009

@@colbox-blue
A Pythagorean triplet is a set of three natural numbers, $< b < c$, for which,
$$
a^2 + b^2 = c^2
\label{eq:pythags_theorem}
$$

For example, $3^2 + 4^2 = 5^2$.

There exists exactly one Pythagorean triplet for which $a + b + c = 1000$.

Find the product $a \cdot b \cdot c$.
@@

## Hands-on

Mi first approach was to find $a$ and $b$ such that the square of both numbers summed up to the $c$ squared. I achieved it by providing the desired value of $c$ to find the triplet corresponding to that value.

Because $a < b < c$, it is possible to allow a to start at $a=1$, as a consequence $b=2$, thus making the minimum value c can take equal to $c=3$.
```lisp
;; a: adjacent side
;; b: opposite side
;; c: hypotenuse
(defun find-triplet-aux (a b c &optional (a2 (expt a 2)) (b2 (expt b 2)) (c2 (expt c 2)))
  ;(format t "~a~%" (list a b))
  (cond ((equalp c2 (+ a2 b2)) (list a b c))
        ((< b c) (find-triplet-aux a (1+ b) c a2 (expt (1+ b) 2)))
        ((< a (- c 2)) (find-triplet-aux (1+ a) (+ 2 a) c (expt (1+ a) 2) (expt (+ 2 a) 2)))
        (t nil)))

(defun find-triplet (c)
  (find-triplet-aux 1 2 c))
```
Some triplets can be consulted in the [Pythagorean triplets entry](https://en.wikipedia.org/wiki/Pythagorean_triplet) at Wikipedia, such as:
\nonumber{
$$
\begin{align*}
(3, 4, 5) && (5, 12, 13) && (8, 15, 17) && (7, 24, 25) \\
(20, 21, 29) && (12, 35, 37) && (9, 40, 41) && (28, 45, 53) \\
(11, 60, 61) && (16, 63, 65) && (33, 56, 65) && (48, 55, 73) \\
(13, 84, 85) && (35, 77, 85) && (39, 80, 89) && (65, 72, 97)
\end{align*}
$$}
There are several triplets with the same $c$ value, meaning that `find-triplet` is correct but not complete. I mention this because if `find-triplet` is run with $c = 85$ we get `(13 84 85)` which does appear in the previous shown table of triplets, but `(36 77 85)` can't be obtained with the current implementation of `find-triplet`.
```lisp
> (find-triplet 85)
(13 84 85)
```
Another I figured out to define `find-triplet-aux` is by iterating first through all available number of $a$ instead of $b$, where $a$ will be allowed to take values within the range $1<a<b$ for each value of $b$.
```lisp
(defun find-triplet-aux (a b c &optional (a2 (expt a 2)) (b2 (expt b 2)) (c2 (expt c 2)))
  ;(format t "~a~%" (list a b))
  (cond ((equalp c2 (+ a2 b2)) (list a b c))
        ((< a b) (find-triplet-aux (1+ a) b c (expt (1+ a) 2)))
        ((< b c) (find-triplet-aux 1 (1+ b) c 1 (expt (1+ b) 2)))
        (t nil)))
```
The values of $a$ and $b$ can be seen on both implementations of `find-triplet-aux` by uncommenting the line with the `format` function. Nevertheless, this new implementation of `find-triplet-aux `doesn't solve the problem either because it only returns one single triplet. Although. if called with $c=85$, it doesn't returns `(36, 77, 85)` but instead `(51 68 85)`.
```lisp
> (find-triplet 85)
(51 68 85)
```
Meaning there is not a unique set of values $(a,b)$ that fulfill equation \eqref{eq:pythags_theorem}.

Before reaching this realization, I already implemented a function that started with $c = 3$ until an upper limit $N$ in order to find $(a,b,c)$ such that they sum up to said upper limit, the problem states that $N=1000$. 

The idea is simple, call `find-triplet` with $c=3$, if the resulting triplet sums up to $N$ then return the triplet, else increment $c \gets c+1$. Another case can occur, the one where no triplet is found for the current $c$ value.
```lisp
;; sum: equals to the expected sum of a + b + c
(defun triplet-of-sum (sum &optional (c 3))
  (let ((triplet (find-triplet c)))
    ;(format t "~a ~a ~%" c triplet)
    (cond ((equalp nil triplet)
           (tmp sum (1+ c)))
          ((equalp sum (sum/lst triplet))
           triplet)
          ((< c sum)
           (tmp sum (1+ c)))
          (t nil))))
```
I did not find the correct result of this problem following this approach, `triplet-of-sum` is not able to even find the triplet corresponding to $N$. Although, it does find the correct triplet for other values of $N$ that I tested. I even tried using both implementations of `find-triplet-aux` but with no avail.

The function `sum/lst` is an auxiliary function to sum the elements of a list because it is not implemented in SBCL.
```lisp
(defun sum/lst (lst)
  (reduce #'(lambda (acc x) (+ acc x)) lst :initial-value 0))
```
**This is where I decided to start again.**

### Round 2

I searched for some ideas on the internet, and came up with a simple solution.
```lisp
(defun triplet-of-n (n &optional (a 1) (b 2) (blim (1- (floor n 2))))
  (let ((c (- n a b)))
    ;(format t "~a~%" (list a b c))
    (cond ((is-triplet? a b c) (list a b c))
          ((< a (1- b)) (triplet-of-n n (1+ a) b))
          ((< b blim) (triplet-of-n n 1 (1+ b))))))
```
It is an iterative solution where the value of $c$ is computed as $c = n - a - b$. Instead of trying to find the triplet $(a,b,c)$ that sums up to $N$, it is used to compute the value that $c$ should have. Then, it is asked if the current $(a,b,c)$ is indeed a Pythagorean triplet with `is-triplet?`.
```lisp
(defun is-triplet? (a b c)
  (when (equalp (+ (expt a 2) (expt b 2)) (expt c 2)) t))
```
If $(a,b,c)$ is a Pythagorean triplet, the product $a \cdot b \cdot c$ is easily obtained with `triplet-prod`.
```lisp
(defun triplet-prod (triplet)
  (when triplet (prod/lst triplet)))
```
These functions use `when`, meaning that only in the case that the'll only evaluate if the condition is not `nil`. Lastly, the function `prod/lst` is based on `reduce` just as `sum/lst`.
```lisp
(defun prod/lst (lst)
  (reduce #'(lambda (acc x) (* acc x)) lst :initial-value 1))
```
Some examples of the triplet related functions are shown below.
```lisp
> (is-triplet? 1 1 2)
NIL
> (is-triplet? 3 4 5)
T
> (triplet-of-n 12)
(3 4 5)
> (triplet-of-n 1000)
(200 375 425)
> (triplet-prod (triplet-of-n 12))
60
> (triplet-prod (triplet-of-n 1000))
31875000
```
Lastly, I didn't explained why function `triplet-of-n` has an optional argument that sets the upper limit of $b$ set to $\lfloor N / 2 \rfloor$, so allow me to tackle this point.  First, we have to keep in mind that $a < b < c$, it is easy to deduce that the minimum value that $a$ can take is $a=1$. Because of this, the smallest $b$ value is $b=2$. Similarly, the smallest value $c$ can take is $c=3$.

What about the maximum values? I only assumed the scenario where $a=1$ to find an answer to this question. Assuming this is the case, then 
$$
\begin{align*}
a + b + c & = N \\
1+ b + c & = N \\
b' + c & = N .
\end{align*}
$$
The constraint $b < c$ doesn't apply here, in fact, it is allowed that $b' \leq c$. If both are equal, $b' = c$, that means that $c = b'= \lfloor N/2 \rfloor$. Therefore,
$$
\begin{align*}
b + 1 & = b' \\
b + 1 & = \lfloor N/2 \rfloor \\
b & = \lfloor N/2 \rfloor - 1 .
\end{align*}
$$
Now we have the limits of interest, the lower limit of $a$ and the lower and upper limits of $b$. I didn't tried to find an upper limit for $a$ because I didn't needed it for my implementation. Likewise, I didn't use the upper limit of $c$ in the implementation of `triplet-of-n`, only to find the upper limit of $b$.

`triplet-of-n` starts at $(a,b) = (1,2)$, it doesn't adds 1 unit to $a$ because that violates the condition $a < b$. So, it adds 1 to $b$ and sets $a \gets 1$, making the next pair of values are $(a,b)=(1,3)$, and the second pair of values equal to $(a,b) = (2,3)$. This process continues until a triplet is found or $(a,b) = (\lfloor N \rfloor - 2, \lfloor N \rfloor - 1)$.

I didn't mention this before but there can exists a set of values $(k \cdot a, k \cdot b, k \cdot c)$ for any $k$ in the natural numbers that is also a Pythagorean triplet. This can be another way of finding the result, but I didn't explore it further.

~
