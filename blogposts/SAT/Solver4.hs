type Literal    = Int
type Clause     = [Literal]
type Problem    = [Clause]
type Assignment = [Literal]

propagate :: Literal -> Problem -> Problem
propagate l p = [ filter (/= negate l) c | c <- p, l `notElem` c ]

solve :: Problem -> [Assignment]
solve []    = [[]]
solve (c:p) = do
  (l:c)  <- [c]
  (l, p) <- [ (l, p), (negate l, c:p) ]
  ass    <- solve (propagate l p)
  return (l:ass)
