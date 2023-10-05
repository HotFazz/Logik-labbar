%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uppgift 1	(4p)
% unifiering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Betrakta denna fråga till ett Prologsystem:
%
% ?- T=f(a,Y,Z), T=f(X,X,b).
%
% Vilka bindningar presenteras som resultat?
%
% Ge en kortfattad förklaring till ditt svar!


% The given query is 

?- T=f(a,Y,Z), T=f(X,X,b).

% If we break down this query 

% T is unified with f(a, Y, Z), and is therfore bound to it
% T is also bound to f(X,X,b), meaning that f(a,Y,Z) is unified with f(X,X,b) as they have the same functor and arity
% This in turn results in 
    % a being unified with X
    % Y being unified with X
    % Z being unified with b


