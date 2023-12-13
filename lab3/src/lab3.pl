% Load model, initial state and formula from file.
verify(Input) :-
  see(Input), read(T), read(L), read(S), read(F), seen,
  check(T, L, S, [], F).


% and
check(Transitions, Labels, State, [], and(F1, F2)) :-
  check(Transitions, Labels, State, [], F1),
  check(Transitions, Labels, State, [], F2).

% or
check(Transitions, Labels, State, [], or(F, _)) :-
  check(Transitions, Labels, State, [], F), !.

check(Transitions, Labels, State, [], or(_, F)) :-
  check(Transitions, Labels, State, [], F), !.


% ax
% all next
% For all paths the next step satisfies F
check(Transitions, Labels, State, U, ax(F)) :-
  getList(Transitions, State, Paths),
  check_next(Transitions, Labels, Paths, U, F).


% ex
% exists next
% There exists a path where the next state satisfies F
check(Transitions, Labels, State, U, ex(F)) :-
  % Get all available paths from the given State

  getList(Transitions, State, States),
  member(S1, States),
  check(Transitions, Labels, S1, U, F).


% ag
% always globally 
% For all paths, in all states, F is satisfied
check(_, _, State, U, ag(_)) :-
  member(State, U).
check(Transitions, Labels, State, U, ag(F)) :-
  check(Transitions, Labels, State, [], F),
  check(Transitions, Labels, State, [State|U], ax(ag(F))).


% eg
% exists globally
% There exists a path where in all states, F is satisfied
check(_, _, State, U, eg(_)) :-   %Stop if visited
  member(State, U), !.

check(Transitions, Labels, State, U, eg(F)) :-    % Check the formula holds in the current state
  check(Transitions, Labels, State, [], F),       % Get all paths from the current state
  getList(Transitions, State, Paths),
  member(S1, Paths),
  check(Transitions, Labels, S1, [State|U], eg(F)).


% ef
% exists finally
% There exists a path where F will eventually be satisfied
check(Transitions, Labels, State, U, ef(F)) :-   % Check the current state has not been visited 
  \+ member(State, U),                           % Check the formula holds in the current state
  check(Transitions, Labels, State, [], F).


check(Transitions, Labels, State, U, ef(F)) :-   % Check the current state has not been visited before

  \+ member(State, U),                           % Get all paths from the current state
  getList(Transitions, State, Paths),   
  member(S1, Paths),
  check(Transitions, Labels, S1, [State|U], ef(F)).



% af
% or all future
% For all paths, F will eventually be satisfied
check(Transitions, Labels, State, U, af(F)) :-   % Check that the current state has not been visited 
  \+ member(State, U),                           % Check that the formula holds in the current 
  check(Transitions, Labels, State, [], F).      


check(Transitions, Labels, State, U, af(F)) :-
  \+ member(State, U),
  check(Transitions, Labels, State, [State|U], ax(af(F))).
 

% neg
% The formula F is not satisfied in the current state
check(_, Labels, State, [], neg(F)) :-
  getList(Labels, State, Formulas),              % Check iven formula is not present in the list of formulas that holds
  % in the current state.
  \+ member(F, Formulas).


% arbitrary formula
check(_, Labels, State, [], F) :-                % Get all formulas that holds in the current state
  getList(Labels, State, Formulas),
  member(F, Formulas).


% Iterate over all given states and check the given formula holds in all 
check_next(_, _, [], _, _).
check_next(T, L, [State|States], U, F) :-
  check(T, L, State, U, F), !,
  check_next(T, L, States, U, F).


% Helper predicates
% retrieve a list of paths or formulas associated with a particular state
getList([[State, Paths]|_], State, Paths) :- !.
getList([_|T], State, Paths) :- 
getList(T, State, Paths).


% ! is used to prevent backtracking in certain parts of the code to ensure that once a condition is met, Prolog does not continue to search for other solutions.
% This is used in the eg and ef functions to prevent the program from continuing to search for other solutions once a solution has been found.
