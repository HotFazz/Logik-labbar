% Proof Verification Entry Point
verify_proof(Filename) :-
    open_proof(Filename),
    read(Premises), read(Goal), read(ProofSteps),
    close_proof,
    (is_proof_valid(Premises, Goal, ProofSteps) 
        -> write("yes\n")
        ; write("no\n"), false).

% Validating Entire Proof
is_proof_valid(Premises, Goal, Proof) % acts as a wrapper to start the recursive validation of the proof
    :- validate_steps(Premises, Goal, Proof, []). %initilizes an empty list that will contain the proven steps

% Final Step Validation
validate_steps(Premises, Goal, [[_, Goal, AppliedRule]], Proven) %recursive function for validating each step in the proof
   :- validate_rule(AppliedRule, Premises, Proven, Goal).

% Normal Step Validation
validate_steps(Premises, Goal, [[StepNum, Term, AppliedRule]|RestSteps], Proven)
   :- validate_rule(AppliedRule, Premises, Proven, Term),
      validate_steps(Premises, Goal, RestSteps, [[StepNum, Term, AppliedRule]|Proven]).

% Entering with an Assumption
validate_steps(Premises, Goal, [Section|RestSteps], Proven)
   :- Section = [FirstLine|RestOfSection],
      FirstLine = [_, _, assumption],
      (RestOfSection = [] ; is_proof_valid(Premises, _, RestOfSection, [FirstLine|Proven])),
      validate_steps(Premises, Goal, RestSteps, [Section|Proven]).

%% Rules for Inference
% Rule for Premise
validate_rule(premise, Premises, _, A) :- member(A, Premises).

% Copy
validate_rule(copy(X), _, Proven, A) :- 
    member([X, A, _], Proven).

% And Introduction
validate_rule(andint(X, Y), _, Proven, and(A, B)) :- 
    member([X, A, _], Proven),
    member([Y, B, _], Proven).

% And Deletion 1
validate_rule(andel1(X), _, Proven, A) :- 
    member([X, and(A, _), _], Proven).

% And Deletion 2
validate_rule(andel2(X), _, Proven, A) :- 
    member([X, and(_, A), _], Proven).

% Or Introduction 1
validate_rule(orint1(X), _, Proven, or(A, _)) :- 
    member([X, A, _], Proven).

% Or Introduction 2
validate_rule(orint2(X), _, Proven, or(_, A)) :- 
    member([X, A, _], Proven).

% Or Elimination
validate_rule(orel(X, Y, U, V, W), _, Proven, A) :- 
    member([X, or(B, C), _], Proven),
    has_box([Y, B, assumption], [U, A, _], Proven),
    has_box([V, C, assumption], [W, A, _], Proven).

% Implication Introduction
validate_rule(impint(X, Y), _, Proven, imp(A, B)) :- 
    has_box([X, A, assumption], [Y, B, _], Proven).

% Implication Elimination
validate_rule(impel(X, Y), _, Proven, B) :- 
    member([X, A, _], Proven),
    member([Y, imp(A, B), _], Proven).

% Negation Introduction
validate_rule(negint(X, Y), _, Proven, neg(A)) :- 
    has_box([X, A, assumption], [Y, cont, _], Proven).

% Negation Elimination
validate_rule(negel(X, Y), _, Proven, cont) :- 
    member([X, A, _], Proven),
    member([Y, neg(A), _], Proven).

% Contradiction Elimination
validate_rule(contel(X), _, Proven, _) :- 
    member([X, cont, _], Proven).

% Double Negation Introduction
validate_rule(negnegint(X), _, Proven, neg(neg(A))) :- 
    member([X, A, _], Proven).

% Double Negation Elimination
validate_rule(negnegel(X), _, Proven, A) :- 
    member([X, neg(neg(A)), _], Proven).

% Modus Tollens
validate_rule(mt(X, Y), _, Proven, neg(A)) :- 
    member([X, imp(A, B), _], Proven),
    member([Y, neg(B), _], Proven).

% Proof by Contradiction
validate_rule(pbc(X, Y), _, Proven, A) :- 
    has_box([X, neg(A), assumption], [Y, cont, _], Proven).

% Law of Excluded Middle
validate_rule(lem, _, _, or(A, neg(A))).

%% Helper Functions

% Box Validation
has_box(Start, End, Proven) :- 
    member(Box, Proven),
    Box = [Start|_],
    append(_, [End], Box).

% Proof File Handling
open_proof(FilePath) :- see(FilePath).
close_proof :- seen.