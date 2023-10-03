% uppgift 3	(6p)
% rekursion och backtracking  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Definiera predikatet partstring/3 som givet en lista som 
% första argument genererar en lista F med längden L som 
% man finner konsekutivt i den första listan!
% Alla möjliga svar skall kunna presenteras med hjälp av 
% backtracking om man begär fram dem.

% Till exempel:

% ?- partstring( [ 1, 2 , 3 , 4 ], L, F).

% genererar t.ex.F=[4] och L=1
% eller F=[1,2] och L=2
% eller också F=[1,2,3] och L=3
% eller F=[2,3] och L=2 
% osv.


% Base case: An empty list has no part strings
partstring([], _, []).

% A part string starting from the head of the list
partstring([H|T], L, [H|Part]) :-
    prefix_length([H|T], L, [H|Part]).

% Recurse to generate part strings starting from later in the list
partstring([_|T], L, F) :-
    partstring(T, L, F).

% Helper predicate to get prefixes of a certain length
prefix_length(List, 0, []).
prefix_length([H|T], L, [H|Rest]) :-
    L > 0,
    L1 is L - 1,
    prefix_length(T, L1, Rest).