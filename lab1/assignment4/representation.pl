% Authors: Avid Fayaz and Christofer Gärtner
% uppgift 4 (8p)
% representation

% Du skall definiera ett program som arbetar med grafer.

% Föreslå en representation av grafer sådan att varje nod
% har ett unikt namn (en konstant) och grannarna finns
% indikerade. 

% Definiera ett predikat som med denna representation och
% utan att fastna i en loop tar fram en väg som en lista av 
% namnen på noderna i den ordning de passeras när man utan 
% att passera en nod mer än en gång går från nod A till nod B!
% Finns det flera möjliga vägar skall de presenteras 
% en efter en, om man begär det.

% Example representation
edge(a, b).
edge(b, c).
edge(c, d).
edge(d, e).
edge(a, d).

% Base case: A path from A to A is just the node A itself
path(A, A, _, [A]).

% Recursive case: Find a path from A to B
path(A, B, Visited, [A|Path]) :-
    edge(A, Next),
    \+ member(Next, Visited), % Ensure we don't visit a node twice
    path(Next, B, [Next|Visited], Path).


% path(a, d, [a], P)