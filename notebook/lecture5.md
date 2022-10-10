# CSCI 4430 Lecture 5

## Logic programming

Logic programming is declarative programming
- States *what* (logic) not *how* (control)

The logic programming style is characterized by:
- Database of facts and rules, which represent logical relations
- Computation in logic programming is queries over this database of facts and rules
- Use of lists and recursion, which turns out is very similar to the functional programming language style

### Some concepts of logic programming

The Horn Claus: `H <- B1, B2, B3, ..., Bn`

In natural language, this means "`H` assumes the value of `B1 and B2 and B3 and ... and Bn`"

A resolution principle is substitution of terms in Horn clauses

### Prolog

In Prolog, horn clauses are written as
```
h :- b1, b2, ..., bn
```

A horn clause with no tail is a **fact**. If we want to express that Seattle is a rainy city, we can write

```
rainy(seattle)
```

A rule in prolog is a horn clause with a tail, as in it depends on other conditions

```
snowy(X) :- rainy(X), cold(X)
```

Which in natural language is expressing that "for all values of `X`, `snowy(X)` is true for values of `X` such that `rainy(X)` and `cold(X)` are both true"