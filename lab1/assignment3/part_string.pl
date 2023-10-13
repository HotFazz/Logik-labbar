% uppgift 3	(6p)
% rekursion och backtracking  

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
partstring(List, L, F) :-
    append(_, Temporary, List),  % Ignore some elements at the begining, anonymous variable (_), including the empty set
    append(F, _, Temporary),     % Capture the front of the resulting list
    length(F, L).

    /* The append/3 predicate takes three lists. It checks if the third list (List) is formed by appending the first two lists.

    % partstring( [ 1, 2 , 3 , 4 ], L, F).


