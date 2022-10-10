likes(eve, pie).
likes(al, eve).
likes(eve, tom).
likes(eve, eve).

food(pie).
food(apple).
person(tom).
person(al).
person(eve).

wanttoeat(A, B) :- likes(A, B), food(B).
likesperson(A, B) :- likes(A, B), person(B).

d(A, B, 0, A) :- A < B.
d(A, B, Q, R) :- A >= B, A1 is A-B, d(A1, B, Q1, R), Q is Q1+1.
