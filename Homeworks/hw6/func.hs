myeven x  = if x==0 then True else not (myeven (x-1))


even2::Integer -> Bool
even2 x = if mod x 2==0 then True else False
