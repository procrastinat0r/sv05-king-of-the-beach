# Solving the Problem using Answer Set Programming

## Answer Set Programming

[Answer Set Programming (ASP)](https://en.wikipedia.org/wiki/Answer_set_programming)
is a declarative approach to solving combinatorial search and optimization problems.
Instead of writing an algorithm that constructs a schedule step by step,
the encoding describes the possible choices, the constraints that must hold, and
the objectives that should be optimized.
An ASP solver then computes stable models, which represent solutions to the encoded problem.

This makes ASP a good fit for the volleyball scheduling problem: teams,
matches, rounds, and court assignments are discrete choices with many
interacting constraints. The conditions can be written directly as rules, and
different schedules can be compared using optimization criteria.
This project uses the [Potassco](https://potassco.org/) tool suite, in particular
[clingo](https://potassco.org/clingo/), developed by the Potassco group for
ASP modeling, grounding, solving, and optimization.

## Usage

Install `clingo` using the instructions in the
[Potassco documentation](https://potassco.org/clingo/), then run the encoding
from this directory. For example, to schedule 10 players on 2 courts use:

```text
clingo beach.lp -c n=10 -c f=2
```

The output consists of matches and their round assignments, i.e. atoms of the form `match/3` and `s/2`:
- `s(R,M)`: match `M` is played in round `R`. Distributing matches of the same round to different courts, is left to the user.
- `match(M,(P1,P2),(P3,P4))`: Players `P1` and `P2` play against `P3` and `P4` in match `M`.

Player pairs with negative player numbers are placeholders for any player pair.
Round 0 can be ignored.

<details>

<summary>Example result for n=8,f=2</summary>

The output is formatted for better visibility.

```
s(0,0)
s(1,9)
s(1,5)
s(2,4)
s(2,3)
s(3,13)
s(3,7)
s(4,12)
s(4,8)
s(5,6)
s(5,1)
s(6,11)
s(6,2)
s(7,14)
s(7,10)
match(1,(1,8),(2,3))
match(2,(3,8),(4,5))
match(3,(3,6),(7,8))
match(4,(1,5),(2,4))
match(5,(2,6),(3,4))
match(6,(4,6),(5,7))
match(7,(2,8),(4,7))
match(8,(2,5),(6,8))
match(9,(1,7),(5,8))
match(10,(1,6),(4,8))
match(11,(1,2),(6,7))
match(12,(1,4),(3,7))
match(13,(1,3),(5,6))
match(14,(2,7),(3,5))
Optimization: 0 0 0 0 48
```

</details>


## Optimization Criteria

The `beach.lp` encoding encodes the following optimization (minimization)criteria
with descending priority:
- Sum of the absolute deviation of individual opponent counts from the ideal opponent count
- Sum of the quadratic deviation of individual opponent counts from the ideal opponent count
- Maximum absolute deviation of individual opponent counts from the ideal opponent count
- Number of rounds
- Sum of the number of back-to-back matches for each player
