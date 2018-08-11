type Literal    = Int
type Clause     = [Literal]
type Problem    = [Clause]
type Assignment = [Literal]

propagate :: Literal -> Problem -> Problem
propagate l p = [ filter (/= negate l) c | c <- p, l `notElem` c ]

solve :: Problem -> Maybe Assignment
solve []        = Just []
solve ([]:p)    = Nothing
solve ((l:c):p) = 
  case solve (propagate l p) of
    Just assignment -> Just (l:assignment)
    Nothing         -> case solve (propagate (negate l) (c:p)) of
      Just assignment -> Just (negate l:assignment)
      Nothing         -> Nothing

example :: Problem
example = [[1, 2], [-2, 3]]
