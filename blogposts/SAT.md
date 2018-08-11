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
program.

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
of the Literal. We dissallow `0` as a Literal. A Clause is a disjunction of Literals,
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
problem :: Problem
problem = [[1, 2], [-2, 3]]
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
      Just assignment -> (negate l:assignment)
      Nothing         -> Nothing
```
The type of `solve` tells us that it will take a problem and either return `Just`
a satisftying assignment, or it will return `Nothing`, indicating that the
problem is `UNSAT`. The implementation is just a simple backtracking search where
we propagate the choice of the literal to the rest of the problem and check
if the smaller problem has a solution or not and act accordingly.
