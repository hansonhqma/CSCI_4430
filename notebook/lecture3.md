# CSCI 4430 Lecture 3

## Scanning

In the compiler process the scanner sits in between the raw string and the string to be fed into the parser - it simplifies the job of the parser

**Scanner groups characters into tokens**

- Scanner is essentially a finite automaton in that it recognizes and outputs the tokens in the raw string (program)


## Parsing, generalized

Suppose we have a simple language that generates calculator instructions

```
asst_stmt -> id = expr
expr -> expr + expr | expr * expr | id
```

And we have some character stream (raw program line)

```
position = initial + rate * time
```

Our scanner gives us the tokens

```
id = id + id * id
```

The question we pose at this point is how can we quickly build a parse tree from the above sequence of tokens?

There are several well known algorithms that can parse token sequences in essentially n^3 time for n characters, but for compilers that is far to slow

The objective is to build a parse tree for an input sequence of tokens from a single scan of input:
- Only two special subclasses of CFG's can do this: LL and LR
- LL parsers are top-down parsers, they build parse trees from the root to the leaves
- LR parsers are bottom-up parsers, they build parse trees from leaves to the root

Suppose we have a simple grammar for comma separated lists:

```
list -> id tail
tail -> , id tail | ;
```

Which generates strings such as `id ;`, `id, id, id ;`, etc.

## Top-down parsing

Top-down predictive parsing:
- "Predicts" which production rule to applty based on one or more **lookahead** tokens
- We are interested in LL(1)
    - Left-to-right scan, leftmost derivation, needs 1 token of lookahead to predict

Can we show that the above grammar for a comma separated list is LL(1)?

Suppose we have the token sequence `id, id, id ;`

Top-down parsing states that we start with the start symbol `list` and as such our first generation is `id tail`

```
list
id tail
```

Our current sentential form has matched our first token `id`, and our next token is `,`, which is our single lookahead token. Our left-most derivation rule suggests that we have to choose a production rule from the `tail` symbol, from which we have either:
- `tail -> , id tail`
- `tail -> ;`

Given the single lookahead token `,`, the parser can determine that the production rule needed is `tail -> id tail`

This implies that the grammar is an LL(1) grammar
