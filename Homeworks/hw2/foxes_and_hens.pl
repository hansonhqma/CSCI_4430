% CSCI4430 Homework 2 problem 1
% author: Hanson Ma

% encode the success state
success([3, 3, 1]).

% need rules to encode the validity of a certain state
% let:
%   - Lhen: number of hens crossed
%   - Rhen: number of hens not crossed
%   - Lfox: number of foxes crossed
%   - Rfox: number of foxes not crossed
%   - left: side crossed
%   - right: side uncrossed


% 0 <= num hen <= 3
% 0 <= num fox <= 3
lowerBounds(F, H) :- H >= 0, F >= 0.
upperBounds(F, H) :- H =< 3, F =< 3.
bounds(F, H) :- lowerBounds(F, H), upperBounds(F, H).

% there aren't more foxes than hens crossed. if there are 0 hens we don't care
leftCheck(Lfox, Lhen) :- Lfox =< Lhen ; Lhen is 0.

% there aren't more foxes than hens not crossed ""
% we need to encode this information in terms of Lhen and Lfox
rightFromLeft(Lfox, Rfox, Lhen, Rhen) :- Rfox is 3-Lfox, Rhen is 3-Lhen.
rightCheck(Lfox, Lhen) :- (rightFromLeft(Lfox, Rfox, Lhen, Rhen), Rfox =< Rhen) ; (rightFromLeft(Lfox, _, Lhen, Rhen), Rhen is 0).

% combine these rules to make valid state requirement
% we also use the bang to stop backtrace
validState(Lfox, Lhen) :- bounds(Lfox, Lhen), leftCheck(Lfox, Lhen), rightCheck(Lfox, Lhen), !.

% to describe state space of valid moves:
% - each predicate describes a valid transformation between previous state and next state
% e.g: state1, state2 such that stateTransform(state1, state2) is True
%   where state1 is some [Lfox, Lhen, Lboat] and state 2 is some [NLfox, NLhen, NLboat]
% 
% Mathematically speaking there are 10 different transformations that can be made
% 1. Move two hens
% 2. Move two foxes
% 3. Move a hen and a fox
% 4. Move a single hen
% 5. Move a single fox
%
% x2 for the distinction of moving from right to left (crossing the river)
%   or left to right (un-crossing the river) to get 10 different transformations
%
% Boat position is directly encoded to force predicate matching
%   could write this whole part in half the lines by predicting boat position but nah
%   
% Move two hens right to left:
stateTransform([Lfox, Lhen, 0], [NLfox, NLhen, 1]) :-
    NLfox is Lfox, NLhen is Lhen + 2, validState(NLfox, NLhen).

% Move two foxes right to left:
stateTransform([Lfox, Lhen, 0], [NLfox, NLhen, 1]) :-
    NLfox is Lfox + 2, NLhen is Lhen, validState(NLfox, NLhen).

% Move a hen and a fox right to left:
stateTransform([Lfox, Lhen, 0], [NLfox, NLhen, 1]) :-
    NLfox is Lfox + 1, NLhen is Lhen + 1, validState(NLfox, NLhen).

% Move a single hen right to left:
stateTransform([Lfox, Lhen, 0], [NLfox, NLhen, 1]) :-
    NLfox is Lfox, NLhen is Lhen + 1, validState(NLfox, NLhen).

% Move a single fox right to left:
stateTransform([Lfox, Lhen, 0], [NLfox, NLhen, 1]) :-
    NLfox is Lfox+ 1, NLhen is Lhen, validState(NLfox, NLhen).

% Move two hens left to right:
stateTransform([Lfox, Lhen, 1], [NLfox, NLhen, 0]) :-
    NLfox is Lfox, NLhen is Lhen - 2, validState(NLfox, NLhen).

% Move two foxes left to right:
stateTransform([Lfox, Lhen, 1], [NLfox, NLhen, 0]) :-
    NLfox is Lfox- 2, NLhen is Lhen, validState(NLfox, NLhen).

% Move a hen and a fox left to right:
stateTransform([Lfox, Lhen, 1], [NLfox, NLhen, 0]) :-
    NLfox is Lfox - 1, NLhen is Lhen - 1, validState(NLfox, NLhen).

% Move a single hen left to right:
stateTransform([Lfox, Lhen, 1], [NLfox, NLhen, 0]) :-
    NLfox is Lfox, NLhen is Lhen - 1, validState(NLfox, NLhen).

% Move a single fox left to right:
stateTransform([Lfox, Lhen, 1], [NLfox, NLhen, 0]) :-
    NLfox is Lfox - 1, NLhen is Lhen, validState(NLfox, NLhen).


% now that we have valid state transformations we need to explore them
% in natural language, the predicate that allows us to explore these states
% can be summarized with
%   - my Head state (most recent) isn't the success state AND
%   - the transition state (from Head state) is a valid transition called Tail AND
%   - the transition state (from Head state) isn't a previously discovered state AND
%   - recursively call exploration
%   - OR
%   - we have the final solution
explore(Path, Candidate) :-
    [Head|_] = Path,
    (
        (
            stateTransform(Head, Tail), % generate a state transition
            not(member(Tail, Path)), not(success(Head)), % we haven't succeeded, and this new state is new
            explore([Tail|Path], Candidate) % keep exploring, appending this new state to our path
        ); % or
        (
            success(Head), % found success state
            Candidate = Path
        )

    ).

% solver

solve(Sol) :- explore([[0,0,0]], Sol).
