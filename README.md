# sv05-king-of-the-beach
Create match plans for SV05 King of the Beach

Problem: see [PROBLEM.md](PROBLEM.md)

## Goal 1 metrics

Goal 1 is to ensure that all players play against each other as evenly as possible. The relevant quantity is the number of matches played between each pair of players.

Let $c_{ij}$ be the number of matches in which player $i$ and player $j$ are opponents, and let $\bar{c}$ be the ideal average value per pair. The goal is to make the values $c_{ij}$ as uniform as possible.

The ideal average value is computed as follows. If the schedule contains $M$ matches, then each match contributes exactly 4 opponent-pairs, so the total number of pairwise opponent encounters is $4M$. Since there are $\binom{n}{2}$ player pairs in total, the ideal value per pair is:

$$
\bar{c} = \frac{4M}{\binom{n}{2}} = \frac{4 \left\lceil \frac{1}{2}\binom{n}{2} \right\rceil}{\binom{n}{2}}
$$

This is the target value that each $c_{ij}$ should approach as closely as possible.

### 1) Sum of absolute deviations

This metric is defined as:

$$
\Delta_{abs} = \sum_{i < j} |c_{ij} - \bar{c}|
$$

Reference: [Absolute deviation](https://en.wikipedia.org/wiki/Absolute_deviation)

Advantages:
- Very easy to understand.
- Directly measures the total amount of imbalance in the schedule.
- Intuitive for optimization, because it rewards globally balanced opponent counts.

Disadvantages:
- It is not a standard statistical dispersion measure in the same way as variance or standard deviation.
- Large deviations are not penalized more strongly than many small deviations.
- It may be less sensitive to the worst single imbalance.

### 2) Standard deviation

This metric is defined as:

$$
\sigma = \sqrt{\frac{1}{N} \sum_{i < j} (c_{ij} - \bar{c})^2}
$$

where $N$ is the number of player pairs.

Reference: [Standard deviation](https://en.wikipedia.org/wiki/Standard_deviation)

Advantages:
- Standard statistical measure of spread.
- Penalizes large deviations more strongly than small ones because of the squared term.
- Useful when the objective is to minimize overall dispersion around the ideal value.

Disadvantages:
- Less directly interpretable in a scheduling context than the total absolute deviation.
- A single very bad pair can be hidden by a generally low variance if the distribution is otherwise compact.
- It does not directly express the total fairness error across all pairs.

### 3) Maximum distance

This metric is defined as:

$$
\Delta_{max} = \max_{i < j} |c_{ij} - \bar{c}|
$$

Reference: [Maximum absolute deviation](https://en.wikipedia.org/wiki/Deviation_(statistics))

Advantages:
- Measures the worst-case fairness violation directly.
- Very useful if one wants to avoid any pair being far away from the ideal value.
- Easy to interpret: it tells the largest imbalance in the schedule.

Disadvantages:
- It ignores the overall distribution of all pairwise imbalances.
- A schedule may have a small maximum deviation but still contain many moderately uneven pairs.
- It is less informative for global optimization than the total deviation or standard deviation.

### Recommendation

For a practical implementation, the most useful combination is to report all three:
- the sum of absolute deviations as the primary global fairness score,
- the standard deviation as a statistical spread measure,
- the maximum distance as a worst-case fairness indicator.

This gives a balanced view of both total fairness and the strongest local imbalance.

### Example with 6 players

Consider a valid 6-player schedule with 8 matches:

- M1: (P1,P2) vs (P3,P4)
- M2: (P1,P3) vs (P2,P5)
- M3: (P1,P4) vs (P5,P6)
- M4: (P1,P5) vs (P2,P4)
- M5: (P1,P6) vs (P3,P5)
- M6: (P2,P3) vs (P4,P6)
- M7: (P2,P6) vs (P4,P5)
- M8: (P3,P6) vs Dummy

The resulting opponent counts for all player pairs are:

- $c_{12}=2$
- $c_{13}=2$
- $c_{14}=2$
- $c_{15}=3$
- $c_{16}=1$
- $c_{23}=2$
- $c_{24}=4$
- $c_{25}=3$
- $c_{26}=1$
- $c_{34}=1$
- $c_{35}=1$
- $c_{36}=2$
- $c_{45}=2$
- $c_{46}=3$
- $c_{56}=3$

There are $\binom{6}{2} = 15$ player pairs, and the schedule has $M=8$ matches. Hence the ideal average value is:

$$
\bar{c} = \frac{4M}{\binom{6}{2}} = \frac{4\cdot 8}{15} = \frac{32}{15} \approx 2.133
$$

The three Goal 1 metrics are then:

1. Sum of absolute deviations:

$$
\Delta_{abs} = \sum_{i < j} |c_{ij} - \bar{c}| \approx 10.667
$$

2. Standard deviation:

$$
\sigma = \sqrt{\frac{1}{15}\sum_{i < j} (c_{ij} - \bar{c})^2} \approx 0.884
$$

3. Maximum distance:

$$
\Delta_{max} = \max_{i < j} |c_{ij} - \bar{c}| \approx 1.867
$$

This example shows how the same schedule can be evaluated with different fairness viewpoints: the total imbalance is captured by $\Delta_{abs}$, the overall spread by $\sigma$, and the worst single imbalance by $\Delta_{max}$.

