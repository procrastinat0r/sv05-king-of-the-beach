# Problem Description

* Fact 1: There are 2 courts.
* Fact 2: There are $n$ players.
* Fact 3: A team consists of 2 different players.
* Fact 4: A match is played by 2 different teams and allocates a court.


* Condition 1: Each player has to team exactly once with each other player.
* Condition 2: All teams have to play exactly 1 match.
* Condition 3: A court can be allocated by 1 match only.
* Condition 4: A player can only be in exactly 1 team in the parallel running matches of the courts.


* Goal 1: All players should play against the other players the same number of matches
* Goal 2: The courts should be used in parallel as much as possible


* Task 1: Create measures for the goals.
* Test 1: Compute the measures for a given configuration.


* Task 2: Create a list with all required team setups.
* Test 2: Verify, that the team list from task 2 matches condition 1.


* Task 3: List all required matches optimizing the goal 1 (schedule). If for the last match no second team is available, then create a dummy team, to get the match filled. Print the measure for goal 1.
* Test 3: Verify, that the schedule matches condition 2.


* Task 4: Distribute the matches to the courts optimizing goal 2 (plan). List the sequence of matches for each court.
* Test 4: verify, that the plan matches conditions 3 and 4.


