---
title: A Very Small SAT Solver
---

For those who don't know, my co-supervisor (yes, that is the person
who does the opposite of a supervisor) is Koen Claessen.
Koen is important to me, he is the man who got me into research
by picking me up in the second year of my B.Sc. at Chalmers.
Actually, Ramona Enache also deserves a special thanks for her
involvement in that. Anyway, that's a story for a different time.
Back to the topic of this post. For those who don't know him, Koen likes SAT.
Koen likes SAT _a lot_. So to honour Koen I'm going to show you how
to build a truly tiny SAT solver in Haskell.

We are going to go through a few iterations of our design, gradually refining it
to eventually end up with a one line 97 character marvel of an incomprehensible
program. All the code for this blogpost is available [here](../blogposts/SAT).

We begin by trying to understand the problem. In SAT we are given a propositional
logic formula in Conjunctive Normal Form (CNF). 
CNF simply means that the formula is a _conjunction of disjunctions_.
As an example, below is a CNF with variables $x_1$, $x_2$, and $x_3$.
$$
(x_1 \vee x_2) \wedge (\neg x_2 \vee x_3)
$$
We are asked to find an assignment to the variables of the formula which
make the formula true. In the example above one such assignment is
$$
x_1 = \top, x_2 = \bot, x_3 = \top
$$
Where $\top$ denotes `True` and $\bot$ `False`. If there is no such assignment,
as is the case for the formula $x_1 \wedge \neg x_1$, we are asked to return `UNSAT`.

With an intuition for the problem formed we are ready to start to tackle the problem
in Haskell. We start with some definitions. A Literal is either a variable, a positive Literal,
or the negation of a variable, a negative Literal.
One way to represent this in Haskell is with a fancy sum type:
```Haskell
type Variable = Int
data Literal  = Positive Variable | Negative Variable
```
However, we are going to go for something slightly simpler:
```Haskell
type Literal = Int
```
Where a positive integer `x` represents a positive Literal and `-x` the negation
of the Literal. We disallow `0` as a Literal. A Clause is a disjunction of Literals,
we represent this simply as a list of `Literal`s:
```Haskell
type Clause = [Literal]
```
Similarly, a Problem is a conjunction of Clauses, represented as a list of Clauses:
```Haskell
type Problem = [Clause]
```
Using this representation the Problem above can be coded as:
```Haskell
example :: Problem
example = [[1, 2], [-2, 3]]
```
With our encoding of problems complete we move on to solutions.
A solution to the SAT problem is an Assignment of variables to truth values.
Alternatively, we can think of an Assignment as a list of true literals, with
the constraint that the same variable appears at most once in the list.
```Haskell
type Assignment = [Literal]
```
Our solution to SAT is going to involve a simple search procedure, we pick
a literal and check if it should be true or false. We do this by propagating
the choice of the value of a literal to the rest of the problem, reducing
the problem to a simpler one:
```Haskell
propagate :: Literal -> Problem -> Problem
propagate l p = [ filter (/= negate l) c | c <- p, l `notElem` c ]
```
With all preliminaries in place we can finally move on to building our
first SAT solver:
```Haskell
solve :: Problem -> Maybe Assignment
solve []        = Just []
solve ([]:p)    = Nothing
solve ((l:c):p) = 
  case solve (propagate l p) of
    Just assignment -> Just (l:assignment)
    Nothing         -> case solve (propagate (negate l) (c:p)) of
      Just assignment -> Just (negate l:assignment)
      Nothing         -> Nothing
```
The type of `solve` tells us that it will take a problem and either return `Just`
a satisfying assignment, or it will return `Nothing`, indicating that the
problem is `UNSAT`. The implementation is just a simple backtracking search where
we propagate the choice of the literal to the rest of the problem and check
if the smaller problem has a solution or not and act accordingly.

If we run our solver on the problem from above we get the following solution:
```Shell
ghci> solve example
Just [1,-2]
```

## Multiple Solutions

With our initial solver completed we are ready to start golfing.
The first thing we are going to do is to make our solver slightly more powerful.
Instead of having it spit out only the first solution it finds, we are going to make it
enumerate solutions. The new type of `solve` is the following:
```Haskell
solve :: Problem -> [Assignment]
```
Instead of returning a `Maybe Assignment` we now return a list of Assignments, where `[]`
represents `UNSAT`. The first two cases are straightforward:
```Haskell
solve [] = [[]]
solve ([]:p) = []
```
We simply replace `Just []` with `[[]]` and `Nothing` with `[]`. The case which actually
does the solving is also relatively straightforward:
```Haskell
solve ((l:c):p) =
     [ l:assignment        | assignment <- solve (propagate l p) ]
  ++ [ negate l:assignment | assignment <- solve (propagate (negate l) (c:p)) ]
```
We simply concatenate all the solutions we get from considering both `l` and `negate l`.

If we run this solver on the example from above we get the following:
```Shell
ghci> solve example 
[[1,-2],[1,2,3],[-1,2,3]]
```

## Do-bious syntax

Ok, so this is ultimately about using Haskell to get as small a piece of code as possible
to perform the SAT task. Since we are using Haskell we have access to a very powerful abstraction,
_Monads_. In particular, we have access to the list monad. What does this mean? In effect this means
that we have a special syntax to apply the `concatMap` function. Here is how it works, if I write the
code that looks like this:
```Haskell
example :: [Int]
example = do
  x <- [1..5]
  replicate x x
```
The code should be read "for every number x in the range 1 to 5, produce x copies of x".
That is to say, the variable `x` is bound to the elements of `[1..5]` individually.
It de-sugars into code that looks, basically, like this:
```Haskell
example :: [Int]
example = concatMap (\x -> replicate x x) [1..5]
```
Which evaluates to:
```Shell
ghci> example
[1,2,2,3,3,3,4,4,4,4,5,5,5,5,5]
```
Having a convenient syntax for doing `concatMap` is nice, but what does it give us when we
are trying to solve SAT? It turns out we can also use this syntax to do pattern-matching.
The following code:
```Haskell
tail :: [Int] -> [Int]
tail xs = do
  (y:ys) <- [xs]
  ys
```
Which de-sugars into:
```Haskell
tail :: [Int] -> [Int]
tail xs = concatMap (\ys -> case ys of { y:ys -> ys; _ -> [] }) [xs]
```
This is to say, if the pattern on the left-hand-side of the binding (`y:ys <- ...`) doesn't match
then we default to the empty list `[]` in the function being mapped.
We can use this trick to simplify our solver a little bit, getting rid of one of the pattern-matches
in the definition:
```Haskell
solve :: Problem -> [Assignment]
solve []    = [[]]
solve (c:p) = do
  (l:c) <- [c]
  ([l:as | as <- solve (propagate l p)] ++ [negate l:as | as <- solve (propagate (negate l) (c:p))])
```
This code can be further simplified by breaking the implicit backtracking from the recursive calls to
solve out:
```Haskell
solve :: Problem -> [Assignment]
solve []    = [[]]
solve (c:p) = do
  (l:c)  <- [c]
  (l, p) <- [(l, p), (negate l, c:p)]
  map (l:) solve (propagate l p)
```
We have broken the choice between $\ell$ and $\neg\ell$ out into another implicit call to `concatMap`,
where the mapped function (the "continuation") consists of the recursive call to `solve`.
Finally we are ready for the 97 character version of our solver, all we need to do is to inline `propagate`
and further inline some of the `do` notation.
```Haskell
f=filter;s[]=[[]];s(c:p)=do(l:c)<-[c];(l,p)<-[(l,p),(-l,c:p)];(l:)<$>s(f(/=0-l)<$>f(notElem l)p)
```
We have renamed `solve` to `s` in order to keep the number of characters to a minimum, but other than that
there is no significant difference between this code and the one above, other than that we have used
the inline version of `map`, `(<$>)`, to reduce the number of necessary brackets to make everything parse
correctly.
