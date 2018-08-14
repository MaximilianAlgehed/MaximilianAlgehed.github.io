type Literal    = Int
type Clause     = [Literal]
type Problem    = [Clause]
type Assignment = [Literal]

propagate :: Literal -> Problem -> Problem
propagate l p = [ filter (/= negate l) c | c <- p, l `notElem` c ]

solve :: Problem -> [Assignment]
solve []    = [[]]
solve (c:p) = do
  (l:c) <- [c]
  ([ l:as | as <- solve (propagate l p) ] ++ [ negate l:as | as <- solve (propagate (negate l) (c:p)) ])

example :: Problem
example = [[1, 2], [-2, 3]]
