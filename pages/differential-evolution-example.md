+++
title = "An example on differential evolution"
date = Date(2023, 8, 24)
tags = ["coding", "differential-evolution", "racket", "evolutionary-algorithm"]
hascode = true
lang = "scheme"
+++

# Differential Evolution

Hi! Welcome.

I hope this entry to be kind of different to the first one I made a looong time ago.

I started using vanilla [Emacs](https://www.gnu.org/software/emacs/) recenlty, I give thanks to professor [Guerra](https://www.uv.mx/personal/aguerra/) for this. I learned some [SBCL](https://www.sbcl.org/) during his [lectures](https://www.uv.mx/personal/aguerra/docencia/), and I became amazed of how integrated the coding experience writting `lisp` using [SLIME](https://slime.common-lisp.dev/) is. I come from *Julia land* where the workflow is heavily based on using the Julia REPL.

Eventually I found myself enjoying more writting `lisp` than `julia` using their respective workflows, but I really missed `julia`'s package manager.

Then, due to my itching curiosity, I stumbled upon other lisp-like languages. First I found [Clojure](https://clojure.org/), then I found [Racket](https://racket-lang.org/). I first liked `clojure` the most because of the *build your own products vibe*, but quickly became confused in the docs. On the other hand, `racket` seemed very very similar to what I already knew. Then, as always, I lost my time reading blog posts on which one to choose or if I should keep up with `sbcl` instead.

Now I was in the same hole we all get to when learning a new programming language: *what project(s) can I do? which tutorials can I follow?* and so on... You know how this goes. The neverending days of zero progress, just me and tutorial hole. Oh, and don't forget the imposter syndrome.

I hope `racket` perseveres and becomes a thriving language in the future just like I hope the same for `julia`, kudos to the communities behind both languages.


@@colbox-blue

What is differential evolution?

~
@@


The fist function that will be taken as aptitude function is
$$
F(\vec{x}) = \sum\limits_{i = 1}^n x_i^2
$$
where $n$ is the number of components of vector $\vec{x}$.

\begin{figure}{**Figure 1.** Plot of $F$.}\fig{/assets/differential-evolution-example/plot-function-f.png}\end{figure}

The second function is
$$
G(\vec{x}) = 10 n + \sum\limits_{i=1}^n \left[y_i^2 - 10 \cos(2 \pi y_i)\right]
$$

\begin{figure}{**Figure 2.** Plot of function $G$.}\fig{/assets/differential-evolution-example/plot-function-g.png}\end{figure}

## Hands-on

Before anything else, the following libraries are the ones used for this project.

```scheme
#lang racket/base

(require racket/list)
(require racket/random)
(require racket/math)
(require plot)

;; Evaluations counter
(define *evals-count* 0)

;; Default number of guests to create mutant list
(define *guests-count* 3)
```

Don't give much importance now to `*evals-count*` and `*guests-count*`, both are used as global variables, but the important one is `*evals-count
*` because that variable will help us to keep track of how many *evaluations* have been made. Each time one solution is created or a currently existing solution is modified, the evaluation count increases by 1 until a maximum has been reached, it is associated with the action of computing a score to a solution.

Okay, so lets get started. First we need one way of storing the solutions, one way would be to use association lists or hash tables, these two data structures are readily available in Racket and would allow us to keep the solution itself and a score that will let us know how *good* the solution is. An alternative is to use structs,

```scheme
;; Struct to store the relevant information of a solution
(struct solution
 (slist sscore)
  #:mutable #:transparent)
```
where the solution is stored in `slist`, and its score in `sscore`. 

~
