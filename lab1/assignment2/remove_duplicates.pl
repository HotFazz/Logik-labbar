% Authors: Avid Fayaz and Christofer Gärtner
% uppgift 2 	(6p)
% representation 

% En lista är en representation av sekvenser där 
% den tomma sekvensen representeras av symbolen []
% och en sekvens bestående av tre heltal 1 2 3 
% representeras av listan [1,2,3] eller i kanonisk syntax 
% '.'(1,'.'(2,'.'(3,[]))) eller [1|[2|[3|[]]]]

% Den exakta definitionen av en lista är:

list([]).
list([H|T]) :- list(T).         % For [H|T] to be a list, T (the tail) must also be a list.        

% Vi vill definiera ett predikat som givet en lista som 
% representerar en sekvens skapar en annan lista som 
% innehåller alla element som förekommer i inlistan i 
% samma ordning, men 
% om ett element har förekommit tidigare i listan skall det 
% inte vara med i den resulterande listan.

% Till exempel: 

% ?- remove_duplicates([1,2,3,2,4,1,3,4], E).
%
% skall generera E=[1,2,3,4]

% Definiera alltså predikatet remove_duplicates/2!
% Förklara varför man kan kalla detta predikat för en
% funktion!




% The goal of remove duplicate is take a list as input and return a new list that
% contains all the unique elements from the input list, preserving the original order.

remove_duplicates(InList, OutList) :-       % remove_duplicates/2 calls remove_duplicates/3 with and additional argument 
    remove_duplicates(InList, [], OutList). % an empty list that is used to keep track of elements that have been seen so far 
                                            % while traversing 'InList'

remove_duplicates([], _, []).               % The first clause of remove_duplicates/3 is the base case,
remove_duplicates([H|T], Seen, [H|OutT]) :-  
    \+ memberchk(H, Seen),                  % remove_duplicates/3 deals with the case where the head H of InList has not been seen before (\+ memberchk(H, Seen)).
    remove_duplicates(T, [H|Seen], OutT).
remove_duplicates([H|T], Seen, OutList) :-
    memberchk(H, Seen),
    remove_duplicates(T, Seen, OutList).

% The third clause of remove_duplicates/3 handles the case where H has been seen before. 

% Why remove_duplicates/2 could be referred to as a function:
% In mathematical logic and computer science, a function is a relation that uniquely 
% associates members of one set with members of another set. 
% A function f from set A to set B assigns to each element x of A exactly one element y of B.