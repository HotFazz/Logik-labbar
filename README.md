# Logic labs
Axiomatica Logicae!

Task:
```pl
% Labb i logikprogrammering, 
% del av D1351 Logik för dataloger 2022
% Thomas Sjöland, EECS/CS/SCS
%
% DD1351.2022.? 

Delkursansvarig: 
Thomas Sjöland,  sjoland@kth.se, 08 - 790 4113


% Här är några generellt användbara definitioner av 
% predikat som du kan använda:
% Andra predikat som definierats i bibliotek i ert 
% prologsystem får inte användas. Skriv definitionen
% explicit, kanske med ett annat namn,
% så att den inte krockar.

append([],L,L).
append([H|T],L,[H|R]) :- append(T,L,R).

appendEl(X, [], [X]).
appendEl(X, [H | T], [H | Y]) :-
           appendEl(X, T, Y).

length([],0).
length([_|T],N) :- length(T,N1), N is N1+1.

nth(N,L,E) :- nth(1,N,L,E).
nth(N,N,[H|_],H).
nth(K,N,[_|T],H) :- K1 is K+1, nth(K1,N,T,H).

subset([], []).
subset([H|T], [H|R]) :- subset(T, R).
subset([_|T], R) :- subset(T, R).

select(X,[X|T],T).
select(X,[Y|T],[Y|R]) :- select(X,T,R).

member(X,L) :- select(X,L,_).

memberchk(X,L) :- select(X,L,_), !.


% Uppgifterna 1, 2, 3, 4 skall läsas för godkänt betyg! 
% Den sista uppgiften ger inga extra poäng.
% De angivna poängtalen visar ungefärliga svårighetsgraden.

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% uppgift 4       (8p)
% representation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extra uppgift (utan poäng, enbart för ert höga nöje!)
% stabil regering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Landet Filurien har åtta partier i parlamentet.

% Senaste valet blev rafflande. Ingen vann.

% Partierna fick dessa mandat: 
% p1 38 , p2 17, p3 51, p4 23, p5 27, p6 35, p7 18, p8 25

% Varje parti bedömde hur mycket de har gemensamt med de 
% andra partierna på en skala från -10 till +10,
% Vi har alltså en matris med 8*8 signifikanta värden. 
% Hitta på lämpliga värden själv! 
% Sätt värdet 0 som partiets självvärdering.


% En stabil regering uppfyller två villkor:

% 1. summan av antalet mandat för de valda partierna är 
%    minst hälften av totalantalet.
% 2. summan av gemensam-index för de valda partierna 
%    sinsemellan är positivt. 
%   (De har totalt mer gemensamt än motsatsen.)


% Skriv ett Prolog-program som föreslår 
% en stabil regering i Filurien!


%	Lycka till!
%	Thomas
```
