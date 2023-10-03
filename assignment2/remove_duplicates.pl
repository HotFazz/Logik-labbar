%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uppgift 2 	(6p)
% representation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% En lista är en representation av sekvenser där 
% den tomma sekvensen representeras av symbolen []
% och en sekvens bestående av tre heltal 1 2 3 
% representeras av listan [1,2,3] eller i kanonisk syntax 
% '.'(1,'.'(2,'.'(3,[]))) eller [1|[2|[3|[]]]]

% Den exakta definitionen av en lista är:

list([]).
list([H|T]) :- list(T).


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




/* The goal of remove duplicate is take a list as input and return a new list 

