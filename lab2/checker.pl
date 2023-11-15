Representing a step in the proof
% step(Line, Statement, Rule, References).

% Natural deduction rules
conjunction_intro(Step, Proof) :-
    step(_, _, '&I', [Line1, Line2]) = Step,
    member(step(Line1, P, _, _), Proof),
    member(step(Line2, Q, _, _), Proof),
    Step = step(_, P & Q, '&I', [Line1, Line2]).

conjunction_elim1(Step, Proof) :-
    step(_, _, '&E1', [Line]) = Step,
    member(step(Line, P & _, _, _), Proof),
    Step = step(_, P, '&E1', [Line]).

conjunction_elim2(Step, Proof) :-
    step(_, _, '&E2', [Line]) = Step,
    member(step(Line, _ & Q, _, _), Proof),
    Step = step(_, Q, '&E2', [Line]).

disjunction_intro1(Step, Proof) :-
    step(_, _, '|I1', [Line]) = Step,
    member(step(Line, P, _, _), Proof),
    Step = step(_, P | _, '|I1', [Line]).

disjunction_intro2(Step, Proof) :-
    step(_, _, '|I2', [Line]) = Step,
    member(step(Line, Q, _, _), Proof),
    Step = step(_, _ | Q, '|I2', [Line]).


disjunction_elim(Step, Proof) :-                %Am completely uncertain about this, so check with others about it
    step(_, _, '|E', [DisjLine, SubProof1, SubProof2]) = Step,
    member(step(DisjLine, P | Q, _, _), Proof),
    valid_subproof(P, R, SubProof1, Proof),
    valid_subproof(Q, R, SubProof2, Proof),
    Step = step(_, R, '|E', [DisjLine, SubProof1, SubProof2]).

% Valid subproof
valid_subproof(Assumption, Conclusion, SubProofLines, Proof) :-
    % Extract the sub-proof using the line numbers in SubProofLines
    extract_subproof(SubProofLines, Proof, SubProof),
    % Check the first step of the sub-proof is an assumption of Assumption
    SubProof = [step(_, Assumption, assumption, _) | _],
    % Check the last step of the sub-proof concludes with Conclusion
    last(SubProof, step(_, Conclusion, _, _)).
    
% Extract subproof
extract_subproof(SubProofLines, Proof, SubProof) :-
    % Implementation to extract the lines corresponding to SubProofLines from Proof
    % ...


implication_intro(Step, Proof) :-
    step(_, _, '->I', [Start, End]) = Step,
    member(step(Start, Assumption, assumption, _), Proof),
    member(step(End, Conclusion, _, _), Proof),
    Step = step(_, Assumption -> Conclusion, '->I', [Start, End]).


implication_elim(Step, Proof) :-
    step(_, _, '->E', [Line1, Line2]) = Step,
    member(step(Line1, P, _, _), Proof),
    member(step(Line2, P -> Q, _, _), Proof),
    Step = step(_, Q, '->E', [Line1, Line2]).


negation_intro(Step, Proof) :-
    step(_, _, '~I', [Start, End]) = Step,
    member(step(Start, Assumption, assumption, _), Proof),
    member(step(End, contradiction, _, _), Proof),
    Step = step(_, ~Assumption, '~I', [Start, End]).


% Negation Elimination (~E)     Check unsure!
negation_elim(Step, Proof) :-
    step(_, _, '~E', [Line1, Line2]) = Step,
    member(step(Line1, P, _, _), Proof),
    member(step(Line2, ~P, _, _), Proof),
    Step = step(_, contradiction, '~E', [Line1, Line2]).

contradiction_elim(Step, Proof) :-
    step(_, _, '⊥E', [Line]) = Step,
    member(step(Line, contradiction, _, _), Proof),
    Step = step(_, _, '⊥E', [Line]).

double_negation_elim(Step, Proof) :-
    step(_, _, '~~E', [Line]) = Step,
    member(step(Line, ~~P, _, _), Proof),
    Step = step(_, P, '~~E', [Line]).

modus_tollens(Step, Proof) :-
    step(_, _, 'MT', [Line1, Line2]) = Step,
    member(step(Line1, P -> Q, _, _), Proof),
    member(step(Line2, ~Q, _, _), Proof),
    Step = step(_, ~P, 'MT', [Line1, Line2]).

% Main proof checking function
check_proof([], _).
check_proof([Step | Rest], Proof) :-
    step(_, _, Rule, _) = Step,
    apply_rule(Rule, Step, Proof),
    check_proof(Rest, Proof).

% Apply the appropriate rule
apply_rule('&I', Step, Proof) :- conjunction_intro(Step, Proof).
apply_rule('&E1', Step, Proof) :- conjunction_elim1(Step, Proof).
apply_rule('&E2', Step, Proof) :- conjunction_elim2(Step, Proof).
apply_rule('|I1', Step, Proof) :- disjunction_intro1(Step, Proof).
apply_rule('|I2', Step, Proof) :- disjunction_intro2(Step, Proof).
apply_rule('|E', Step, Proof) :- disjunction_elim(Step, Proof).
apply_rule('->I', Step, Proof) :- implication_intro(Step, Proof).
apply_rule('->E', Step, Proof) :- implication_elim(Step, Proof).
apply_rule('~I', Step, Proof) :- negation_intro(Step, Proof).
apply_rule('~E', Step, Proof) :- negation_elim(Step, Proof).
apply_rule('⊥E', Step, Proof) :- contradiction_elim(Step, Proof).
apply_rule('~~E', Step, Proof) :- double_negation_elim(Step, Proof).
apply_rule('MT', Step, Proof) :- modus_tollens(Step, Proof).
% Add more rules as necessary...

% Final verification
verify_proof(Proof) :-
    last(Proof, step(_, Goal, _, _)),
    check_proof(Proof, Proof),

% Additions to be made?

% Sample proof (to be replaced with actual proof)
sample_proof([step(1, p, assumption, []),
              step(2, q, assumption, []),
              step(3, p & q, '&I', [1, 2])]).

% Example use
% verify_proof(XXX).