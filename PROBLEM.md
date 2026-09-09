# Problem Description

* Fact 1: There are 2 courts. C1 is court 1 and C2 is court 2.
* Fact 2: There are $n$ players. P1 is player 1, P2 is player 2, and so on.
* Fact 3: A team consists of 2 different players. T1(P1, P2) is team 1 and
  consists of player 1 and player 2. T2(P3, P4) is team 2 and consists of
  players 3 and 4.
* Fact 4: A match is played by 2 different teams and allocates a court. M1(T1,
  T2) is match 1 and lets play T1 against T2.


* Condition 1: Each player has to team exactly once with each other player.
* Condition 2: All teams have to play exactly 1 match.
* Condition 3: A court can be allocated by 1 match only.
* Condition 4: A player can only be in exactly 1 team in the parallel running
  matches of the courts.

  Example: if M1 runs in parallel to M3, then none of the players in M1 are allowed to be in M3.


* Goal 1: All players should play against the other players the same number of matches
* Goal 2: The courts should be used in parallel as much as possible


* Task 1: Create measures for the goals.
* Test 1: Compute the measures for a given configuration.


* Task 2: Create a list with all required team setups.
* Test 2: Verify, that the team list from task 2 matches condition 1.


* Task 3: List all required matches optimizing the goal 1 (schedule). If for the
  last match no second team is available, then create a dummy team, to get the
  match filled. Print the measure for goal 1.
* Test 3: Verify, that the schedule matches condition 2.


* Task 4: Distribute the matches to the courts optimizing goal 2 (plan). List
  the sequence of matches for each court.

  Example:
  C1: M1, M3, ...
  C2: M4, M2, ...
  The matches M1 and M4 are running first and parallel. Then matches M3 and M2 run 2nd in parallel.
  
* Test 4: verify, that the plan matches conditions 3 and 4.


