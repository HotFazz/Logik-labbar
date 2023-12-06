% Load model, initial state and formula from file.
verify(Input) :-
  see(Input), read(T), read(L), read(S), read(F), seen,
  validate(T, L, S, [], F).

% and
validate(Transitions, Labels, State, [], and(F1, F2)) :-
  validate(Transitions, Labels, State, [], F1),
  validate(Transitions, Labels, State, [], F2).

% or
validate(Transitions, Labels, State, [], or(F, _)) :-
  validate(Transitions, Labels, State, [], F), !.
validate(Transitions, Labels, State, [], or(_, F)) :-
  validate(Transitions, Labels, State, [], F), !.

% ax
validate(Transitions, Labels, State, U, ax(F)) :-
  getList(Transitions, State, Paths),
  validate_next(Transitions, Labels, Paths, U, F).

% ex
validate(Transitions, Labels, State, U, ex(F)) :-
  % Get all available paths from the given State.
  getList(Transitions, State, States),

  member(S1, States),
  validate(Transitions, Labels, S1, U, F).

% ag
validate(_, _, State, U, ag(_)) :-

  member(State, U).
validate(Transitions, Labels, State, U, ag(F)) :-
  
  validate(Transitions, Labels, State, [], F),

  validate(Transitions, Labels, State, [State|U], ax(ag(F))).

% eg
validate(_, _, State, U, eg(_)) :-
  % Stop if the current state has been visited before.

  member(State, U), !.

validate(Transitions, Labels, State, U, eg(F)) :-
  % Ensure the formula holds in the current state.

  validate(Transitions, Labels, State, [], F),
  % Get all paths from the current state.

  getList(Transitions, State, Paths),
  % See ex/5 for further comments.

  member(S1, Paths),
  validate(Transitions, Labels, S1, [State|U], eg(F)).

% ef
validate(Transitions, Labels, State, U, ef(F)) :-   % Ensure the current state has not been visited before.

  \+ member(State, U),    % Ensure the formula holds in the current state.

  validate(Transitions, Labels, State, [], F).

validate(Transitions, Labels, State, U, ef(F)) :-
  % Ensure the current state has not been visited before.

  \+ member(State, U),    % Get all paths from the current state.
  getList(Transitions, State, Paths),   % See ex/5 for furter comments.
  member(S1, Paths),
  validate(Transitions, Labels, S1, [State|U], ef(F)).

% af
validate(Transitions, Labels, State, U, af(F)) :-   % Ensure the current state has not been visited before.
  \+ member(State, U),    % Ensure the formula holds in the current state.
  validate(Transitions, Labels, State, [], F).


validate(Transitions, Labels, State, U, af(F)) :-
  % See ef/5 for furher comments.
  \+ member(State, U),
  validate(Transitions, Labels, State, [State|U], ax(af(F))).
 
% neg
validate(_, Labels, State, [], neg(F)) :-
  getList(Labels, State, Formulas),
  % Ensure the given formula is not present in the list of formulas that holds
  % in the current state.
  \+ member(F, Formulas).

% arbitrary formula
validate(_, Labels, State, [], F) :-
  % Get all formulas that holds in the current state.
  getList(Labels, State, Formulas),
  member(F, Formulas).

% Iterate over all given states and ensure the given formula holds in all states.
validate_next(_, _, [], _, _).
validate_next(T, L, [State|States], U, F) :-
  validate(T, L, State, U, F), !,
  validate_next(T, L, States, U, F).


getList([[State, Paths]|_], State, Paths) :- !.
getList([_|T], State, Paths) :- getList(T, State, Paths).
