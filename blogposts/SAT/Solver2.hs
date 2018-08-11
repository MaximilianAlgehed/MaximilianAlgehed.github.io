type Literal    = Int
type Clause     = [Literal]
type Problem    = [Clause]
type Assignment = [Literal]

propagate :: Literal -> Problem -> Problem
propagate l p = [ filter (/= negate l) c | c <- p, l `notElem` c ]

solve :: Problem -> [Assignment]
solve []        = [[]]
solve ([]:p)    = []
solve ((l:c):p) = 
     [ l:assignment        | assignment <- solve (propagate l p) ]
  ++ [ negate l:assignment | assignment <- solve (propagate (negate l) p) ]

example :: Problem
example = [[1, 2], [-2, 3]]
