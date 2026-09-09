# match(M,(P1,P2),(P3,P4)) : M: Match Nummer, P1-P4 Spieler
# Match mit negativen Spielern kann ignoriert werden (übriges Paar)
#
# s(R,M): R: Runde, M: Match Nummer
# s(0,0) kann ignoriert werden

use strict;
use warnings;

# my $input = "s(0,0) s(1,10) s(1,3) s(2,9) s(3,2) s(4,11) s(5,7) s(6,4) s(7,6) s(8,8)
# s(9,1) s(10,5) match(1,(1,6),(2,7)) match(2,(1,5),(4,6))
# match(3,(1,2),(3,4)) match(4,(1,3),(6,7)) match(5,(3,6),(4,5))
# match(6,(2,6),(4,7)) match(7,(1,4),(2,5)) match(8,(1,7),(3,5))
# match(9,(2,3),(5,6)) match(10,(-2,-1),(5,7)) match(11,(2,4),(3,7))
# Optimization: 0 44 5 10 15
# ";
# Read entire stdin into a string
my $input = do { local $/; <STDIN> };

my %matches = ();
my $n_matches = 0;
my %players = ();
my %pairs = ();
my $dummy_players = 0;
my %cross = ();
my %n_played = ();

while ($input =~ /match\((\d+),\((-?\d+),(-?\d+)\),\((-?\d+),(-?\d+)\)\)/sg)
{
  print "match $1: $2,$3 <-> $4,$5\n";
  die "Error: $2 can't play with itself\n" if $2 == $3;
  die "Error: $4 can't play with itself\n" if $4 == $5;
  die "Error: match $1 already exists\n" if exists $matches{$1};
  $matches{$1} = [$2,$3,$4,$5];
  $n_matches++;
  $dummy_players++ if ($2 < 0); # we have a dummy player
  $dummy_players++ if ($3 < 0); # we have a dummy player
  $dummy_players++ if ($4 < 0); # we have a dummy player
  $dummy_players++ if ($5 < 0); # we have a dummy player
  $players{$2} = 1;
  $players{$3} = 1;
  $players{$4} = 1;
  $players{$5} = 1;
  die "Error: pair $2,$3 is playing twice\n" if exists $pairs{"$2-$3"};
  $pairs{"$2-$3"} = 1;
  $pairs{"$3-$2"} = 1;
  die "Error: pair $4,$5 is playing twice\n" if exists $pairs{"$4-$5"};
  $pairs{"$4-$5"} = 1;
  $pairs{"$5-$4"} = 1;
  $cross{"$4-$2"} = $cross{"$2-$4"} = exists $cross{"$2-$4"} ? $cross{"$2-$4"} + 1 : 1;
  $cross{"$5-$2"} = $cross{"$2-$5"} = exists $cross{"$2-$5"} ? $cross{"$2-$5"} + 1 : 1;
  $cross{"$4-$3"} = $cross{"$3-$4"} = exists $cross{"$3-$4"} ? $cross{"$3-$4"} + 1 : 1;
  $cross{"$5-$3"} = $cross{"$3-$5"} = exists $cross{"$3-$5"} ? $cross{"$3-$5"} + 1 : 1;
  $n_played{"$2"} = exists $n_played{"$2"} ? $n_played{"$2"} + 1 : 1;
  $n_played{"$3"} = exists $n_played{"$3"} ? $n_played{"$3"} + 1 : 1;
  $n_played{"$4"} = exists $n_played{"$4"} ? $n_played{"$4"} + 1 : 1;
  $n_played{"$5"} = exists $n_played{"$5"} ? $n_played{"$5"} + 1 : 1;
}

my $n_players = (scalar keys %players) - $dummy_players;
print "number of players: $n_players\n";

# check, that we have all players present
for (my $i = 1; $i <= $n_players; $i++)
{
  die "Error: player $i missing\n" unless exists $players{$i};
}

# check, that we have all pairs playing
for (my $i = 1; $i <= $n_matches; $i++)
{
  for (my $j = $i + 1; $j <= $n_players; $j++)
  {
    die "Error: pair $i,$j missing\n" unless exists $pairs{"$i-$j"};
  }
}

my %rounds = ();
my $n_rounds = 0;

while ($input =~ /s\((\d+),(\d+)\)/sg)
{
  next if ($1 == 0) && ($2 == 0); # ignore s(0,0)
  print "round: $1, match: $2\n";
  die "Error: match $2 does not exist\n" unless exists $matches{$2};
  die "Error: round $1 already have 2 matches\n" if exists $rounds{"$1-1"};
  if (exists $rounds{"$1-0"})
  {
    $rounds{"$1-1"} = $2;
  }
  else
  {
    $rounds{"$1-0"} = $2;
    $n_rounds++;
  }
}
print "number of rounds: $n_rounds\n";

# check, that we have all rounds present
for (my $i = 1; $i < $n_rounds; $i++)
{
  die "Error: round $i missing\n" unless exists $rounds{"$i-0"};
}

# check cross table
for (my $i = 1; $i <= $n_players; $i++)
{
  my $min_against_the_same = $n_players + 1;
  my $max_against_the_same = 0;
  for (my $j = 1; $j <= $n_players; $j++)
  {
    next if $i == $j;
    my $c1 = $cross{"$i-$j"};
    my $c2 = $cross{"$j-$i"};
    die "Error: invalid cross tables for $i,$j ($c1 <-> $c2)\n" unless $c1 == $c2;
    $min_against_the_same = $c1 if $c1 < $min_against_the_same;
    $max_against_the_same = $c1 if $c1 > $max_against_the_same;
  }
  print "player $i: $min_against_the_same $max_against_the_same\n";
}

sub print_cross_table
{
  # header
  print "\n         ";
  foreach my $i (1..$n_players)
  {
    printf("%2d ", $i);
  }
  print "\n";
  my $globalStat = 0.0;
  foreach my $i (1..$n_players)
  {
    my $statValue = 0.0;
    printf("%2d (%2d): ", $i, $n_played{$i});
    foreach my $j (1..$n_players)
    {
      if ($i == $j) { printf("%2d ", 0); next; }
      my $c1 = $cross{"$i-$j"};
      my $v = defined $c1 ? $c1 : 0;
      $statValue += $v;
      printf("%2d ", $v);
    }
    my $median = $statValue / ($n_players-1);
    printf(" - %5.3f ", $median);
    $globalStat += $statValue;
    # Varianz berechnen
    $statValue = 0.0;
    foreach my $j (1..$n_players)
    {
      next if $i == $j;
      my $c1 = $cross{"$i-$j"};
      my $v = defined $c1 ? $c1 : 0;
      my $diff = $v - $median;
      $statValue += ($diff * $diff);
    }
    printf(" - %5.3f\n", $statValue / ($n_players-1));
    #print "\n";
  }
  my $globalMedian = $globalStat / ($n_players-1) / $n_players;
  printf("Mittelwert: %5.3f\n", $globalMedian);
  # globale Varianz berechnen
  $globalStat = 0.0;
  foreach my $i (1..$n_players)
  {
    foreach my $j (1..$n_players)
    {
      next if $i == $j;
      my $c1 = $cross{"$i-$j"};
      my $v = defined $c1 ? $c1 : 0;
      my $diff = $v - $globalMedian;
      $globalStat += ($diff * $diff);
    }
  }
  printf("Varianz: %5.3f\n", $globalStat / ($n_players-1) / $n_players);
}

print_cross_table;
