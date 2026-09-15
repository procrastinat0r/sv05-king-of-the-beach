#program base.
% usage
% clingo beach_full.lp -c n=<number_of_players> -c f=<number_of_fields>

% number of players
#const n=10.
% number of fields
#const f=2. 
% number of pairs
pc(n*(n-1)/2).
% number of matches
mc(n*(n-1)/4).
% number of rounds with perfect field usage
rc(X/f) :- mc(X).
player(1..n). % players

% pairs --------------------------------
% get pairs
{ pair((N2,N1)) : player(N1) } = n-N2 :- player(N2).
% no duplicates
:- pair((N1,N2)), N1>=N2.
% helper pair for uneven number of pairs
pair((-2,-1)) :- X\2=1, pc(X).
:- 1 < #count{ M : plays((-2,-1),M) }.

% matches ------------------------------
match(1..X/2) :- pc(X).
match(X/2+1) :- X\2=1, pc(X).
% get playing pairs for matches
% 2 pairs per match
{ plays(P,M) : pair(P) } = 2 :- match(M).
% each pair plays only in one match
{ plays(P,M) : match(M) } = 1 :- pair(P).
% all pairs have to play once
%:- pair(P), not plays(P,_).

% no mirror matches
:- plays((N1,N2),M), plays((N1,N3),M), N2!=N3. 
:- plays((N1,N2),M), plays((N3,N1),M), N2!=N3. 
:- plays((N2,N1),M), plays((N1,N3),M), N2!=N3. 
:- plays((N2,N1),M), plays((N3,N1),M), N2!=N3. 

% get matches
match(M,(N1,N2),(N3,N4)) :- plays((N1,N2),M), plays((N3,N4),M), N1<N3.

% get opponent count
opp(P,O,M) :- match(M,(P,_),(O,_)), P>0, O>0.
opp(P,O,M) :- match(M,(P,_),(_,O)), P>0, O>0.
opp(P,O,M) :- match(M,(_,P),(O,_)), P>0, O>0.
opp(P,O,M) :- match(M,(_,P),(_,O)), P>0, O>0.
opp(O,P,M) :- opp(P,O,M).

oppc(P,O,C) :- C= #count{ M : opp(P,O,M)}, player(P),player(O), P!=O, P>0.

ideal_oppc(V) :- mc(X), pc(Y), V = 4*X/Y.
% deviation from ideal opponent count
dev(P,O,D) :- oppc(P,O,C), ideal_oppc(I), D = C-I, D>0, P<O.
dev(P,O,-D) :- oppc(P,O,C), ideal_oppc(I), D = C-I, D<0, P<O.

dev_chain(0).
dev_chain(D) :- dev(P,O,D).
dev_chain(D) :- dev_chain(D+1), D>0.
max_dev(D) :- dev_chain(D), not dev_chain(D+1).

% against each opponent atleast once
%:- oppc(P,O,C), C < 1, player(P), player(O).

% debugging
%#show oppc/3.
%#show dev/3.

% scheduling ---------------------------
% first slot
s(0,0).
% additional slots
{ s(R,M) : match(M) } <= f :- s(R-1,_), R<=X, match(X).
% all matches have to be assigned
:- match(M), not s(_,M).
% assign matches only once
:- s(R1,M), s(R2,M), R1!=R2.
% players only in one match per round
:- s(R,M1), s(R,M2), plays((P,_),M1), plays((P,_),M2), M1!=M2, P>0.
:- s(R,M1), s(R,M2), plays((P,_),M1), plays((_,P),M2), M1!=M2, P>0.
:- s(R,M1), s(R,M2), plays((_,P),M1), plays((P,_),M2), M1!=M2, P>0.
:- s(R,M1), s(R,M2), plays((_,P),M1), plays((_,P),M2), M1!=M2, P>0.

% get which rounds players played in
played(P,R) :- s(R,M), plays((P,_),M).
played(P,R) :- s(R,M), plays((_,P),M).
% count back-to-back matches for each player
btb(P,R) :- played(P,R), played(P,R+1).
btbc(P,C) :- C = #count{ R : btb(P,R) }, player(P).

% output -------------------------------
#show s/2.
#show match/3.

% optimization -------------------------
% sum of absolute deviations
:~ dev(P,O,D). [D@5,P,O]
% avoid large deviations
:~ dev(P,O,D). [D**2@4,P,O]
% maximum deviation
:~ max_dev(D). [D@3]
% number of rounds
:~ s(R,_), not s(R+1,_), rc(C), D=R-C. [D@2]
%#minimize{ 1@2,R : s(R,M), R>0 }.
% number of back-to-back matches per player
#minimize{ C@1,P : btbc(P,C) }.
