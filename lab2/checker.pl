% Proof Verification Entry Point
check_proof_validity(Filename) :-
    access_proof(Filename),
    read(InitialPremises), read(TargetGoal), read(StepsOfProof),
    end_proof_access,
    (proof_is_valid(InitialPremises, TargetGoal, StepsOfProof) 
        -> write("Proof is valid.\n")
        ; write("Proof is not valid.\n"), false).

% Validating Entire Proof
proof_is_valid(Premises, Goal, ProofSteps) :- steps_validation(Premises, Goal, ProofSteps, []).

% Final Step Validation
steps_validation(Premises, Goal, [[_, Goal, RuleApplied]], AlreadyProven)
   :- rule_application(RuleApplied, Premises, AlreadyProven, Goal).

% Normal Step Validation
steps_validation(Premises, Goal, [[LineNumber, TermEvaluated, RuleApplied]|OtherSteps], AlreadyProven)
   :- rule_application(RuleApplied, Premises, AlreadyProven, TermEvaluated),
      steps_validation(Premises, Goal, OtherSteps, [[LineNumber, TermEvaluated, RuleApplied]|AlreadyProven]).

% Entering with an Assumption
steps_validation(Premises, Goal, [CurrentSection|OtherSteps], AlreadyProven)
   :- CurrentSection = [FirstRow|RestOfSection],
      FirstRow = [_, _, assumption],
      (RestOfSection = [] ; proof_is_valid(Premises, _, RestOfSection, [FirstRow|AlreadyProven])),
      steps_validation(Premises, Goal, OtherSteps, [CurrentSection|AlreadyProven]).

%% Rules for Inference
% Rule for Premise
rule_application(premise, Premises, _, A) :- member(A, Premises).

% Rule for Copy
rule_application(copy(X), _, Proven, A) :- member([X, A, _], Proven).

% Rule for And Introduction
rule_application(and_intro(X, Y), _, Proven, and(A, B))
    :- member([X, A, _], Proven),
       member([Y, B, _], Proven).

% Rule for And Elimination 1
rule_application(and_elim1(X), _, Proven, A)
    :- member([X, and(A, _), _], Proven).

% Rule for And Elimination 2
rule_application(and_elim2(X), _, Proven, A)
    :- member([X, and(_, A), _], Proven).

% Rule for Or Introduction 1
rule_application(or_intro1(X), _, Proven, or(A, _))
    :- member([X, A, _], Proven).

% Rule for Or Introduction 2
rule_application(or_intro2(X), _, Proven, or(_, A))
    :- member([X, A, _], Proven).

% Rule for Or Elimination
rule_application(or_elim(X, Y, U, V, W), _, Proven, A)
   :- member([X, or(B, C), _], Proven),
      validate_box([Y, B, assumption], [U, A, _], Proven),
      validate_box([V, C, assumption], [W, A, _], Proven).

% Rule for Implication Introduction
rule_application(imp_intro(X, Y), _, Proven, imp(A, B))
   :- validate_box([X, A, assumption], [Y, B, _], Proven).

% Rule for Implication Elimination
rule_application(imp_elim(X, Y), _, Proven, B)
    :- member([X, A, _], Proven),
       member([Y, imp(A, B), _], Proven).

% Rule for Negation Introduction
rule_application(neg_intro(X, Y), _, Proven, neg(A))
   :- validate_box([X, A, assumption], [Y, cont, _], Proven).

% Rule for Negation Elimination
rule_application(neg_elim(X, Y), _, Proven, cont)
    :- member([X, A, _], Proven),
       member([Y, neg(A), _], Proven).

% Rule for Contradiction Elimination
rule_application(cont_elim(X), _, Proven, _) :- member([X, cont, _], Proven).

% Rule for Double Negation Introduction
rule_application(negneg_intro(X), _, Proven, neg(neg(A)))
    :- member([X, A, _], Proven).
 
% Rule for Double Negation Elimination
rule_application(negneg_elim(X), _, Proven, A)
    :- member([X, neg(neg(A)), _], Proven).

% Rule for Modus Tollens
rule_application(mt(X, Y), _, Proven, neg(A))
    :- member([X, imp(A, B), _], Proven),
       member([Y, neg(B), _], Proven).

% Rule for Proof by Contradiction
rule_application(pbc(X, Y), _, Proven, A)
   :- validate_box([X, neg(A), assumption], [Y, cont, _], Proven).

% Rule for Law of Excluded Middle
rule_application(lem, _, _, or(A, neg(A))).

%% Helper Functions
validate_box(Start, End, Proven) :- member(Box, Proven),
                                    Box = [Start|_],
                                    append(_, [End], Box).

% Proof File Handling
access_proof(FilePath) :- see(FilePath).
end_proof_access :- seen.
