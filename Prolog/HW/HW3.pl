:- use_module(library(clpfd)).

:- dynamic derived/2.
:- dynamic asked/1.
:- dynamic rejected/1.

:- op(800, xfx, <==).
:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).

:- op(100, xfx, be).

:- retractall(derived(_,_)),
   retractall(rejected(_)),
   retractall(asked(_)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         KNOWLEDGE BASE                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

askable(humidity, [low, medium, high]).     % Уровень влажности
askable(temperature, [cold, normal, warm]). % Температура
askable(light, [low, medium, high]).        % Освещённость
askable(wind, [calm, breezy, windy]).       % Ветреность

askable(size, [small, medium, large]). % Размер в целом
askable(decorative, [yes, no]).        % Декоративность

askable(stem, [no, small, medium, large]). % Стебель
askable(leaves, [no, few, many]).          % Листья
askable(flowers, [no, few, many]).         % Цветки

% Теневыносливые влажные растения
if
    (humidity be high) and  
    (temperature be cold or temperature be normal) and  
    (light be low) and  
    (wind be calm) 
then
    type be shade_tolerant_wet.

% Теплолюбивые солнечные растения
if
    (humidity be low or humidity be medium) and 
    (temperature be warm) and 
    (light be high) and 
    (wind be windy)
then
    type be warm_loving_sunny.

% Холодоустойчивые теневые растения
if
    (humidity be low or humidity be medium) and 
    (temperature be cold) and 
    (light be low) and 
    (wind be calm)
then
    type be cold_resistant_shade.

% Тенелюбивые теплолюбивые растения
if
    (humidity be medium) and 
    (temperature be warm) and 
    (light be low) and 
    (wind be calm)
then
    type be shade_loving_warm_loving.

% Солнечные влаголюбивые растения
if
    (humidity be high) and 
    (temperature be normal) and 
    (light be high) and 
    (wind be calm)
then
    type be sunny_wet_loving.

% Неприхотливые растения
if
    (humidity be low or humidity be medium) and 
    (temperature be cold or temperature be normal or temperature be warm) and 
    (light be low or light be medium) and 
    (wind be calm or wind be breezy)
then
    type be unpretentious.

% Сквознякоустойчивые светолюбивые растения
if
    (humidity be medium) and 
    (temperature be warm) and 
    (light be high) and 
    (wind be windy)
then
    type be draught_resistant_sunny.

% Малый декоративный
if 
    (size be small) and 
    (decorative be yes)
then
    characteristic be small_decorative.

% Средний декоративный
if 
    (size be medium) and 
    (decorative be yes)
then
    characteristic be medium_decorative.

% Большой декоративный
if 
    (size be large) and 
    (decorative be yes)
then
    characteristic be large_decorative.

% Малый НЕ декоративный
if 
    (size be small) and 
    (decorative be no)
then
    characteristic be small_not_decorative.

% Средний НЕ декоративный
if 
    (size be medium) and 
    (decorative be no)
then
    characteristic be medium_not_decorative.

% Большой НЕ декоративный
if 
    (size be large) and 
    (decorative be no)
then
    characteristic be large_not_decorative.

if
    ((type be shade_tolerant_wet) or (type be cold_resistant_shade) or (type be unpretentious)) and
    (characteristic be medium_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be no)
then
    flower be fern.

if
    (type be shade_tolerant_wet or type be sunny_wet_loving or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be no) and 
    (leaves be many) and 
    (flowers be few or flowers be many)
then
    flower be spathiphyllum.

if
    (type be shade_tolerant_wet or type be cold_resistant_shade) and
    (characteristic be medium_decorative) and 
    (stem be no) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be calathea.

if
    (type be shade_tolerant_wet or type be draught_resistant_sunny or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be no) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be sansevieria.

if
    (type be warm_loving_sunny or type be draught_resistant_sunny) and
    (characteristic be small_decorative or characteristic be medium_decorative) and 
    (stem be small) and 
    (leaves be no) and 
    (flowers be few or flowers be many)
then
    flower be cactus.

if
    (type be warm_loving_sunny or type be draught_resistant_sunny) and
    (characteristic be medium_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be aloe.

if
    (type be warm_loving_sunny or type be draught_resistant_sunny or type be unpretentious) and
    (characteristic be large_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few or flowers be many)
then
    flower be yucca.

if
    (type be shade_tolerant_wet or type be cold_resistant_shade or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be no) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be aspidistra.

if
    (type be shade_tolerant_wet or type be cold_resistant_shade or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be ivy.

if
    (type be shade_tolerant_wet or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be no) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be maranta.

if
    (type be shade_tolerant_wet or type be unpretentious) and
    (characteristic be large_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be philodendron.

if
    (type be shade_tolerant_wet or type be sunny_wet_loving) and
    (characteristic be medium_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few or flowers be many)
then
    flower be anthurium.

if
    (type be shade_tolerant_wet or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be no) and 
    (leaves be many) and 
    (flowers be no)
then
    flower be caladium.

if
    (type be shade_tolerant_wet or type be sunny_wet_loving or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be cyperus.

if
    (type be shade_tolerant_wet or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be no) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be chlorophytum.

if
    (type be shade_tolerant_wet or type be unpretentious) and
    (characteristic be medium_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be golden_pothos.

if
    (type be warm_loving_sunny or type be unpretentious) and
    (characteristic be large_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few or flowers be many)
then
    flower be hibiscus.

if
    (type be shade_tolerant_wet or type be unpretentious) and
    (characteristic be large_decorative) and 
    (stem be large) and 
    (leaves be many) and 
    (flowers be few)
then
    flower be schefflera.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         KNOWLEDGE BASE                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

true(Statement, Statement <== Explanation, _) :- derived(Statement, Explanation).
true(S1 and S2, P1 and P2, Trace) :-
    true(S1, P1, Trace),
    true(S2, P2, Trace).
true(S1 or S2, P, Trace) :-
    true(S1, P, Trace) ;
    true(S2, P, Trace).
true(Conclusion, Conclusion <== ConditionProof, Trace) :-
    if Condition then Conclusion,
    true(Condition, ConditionProof, [if Condition then Conclusion | Trace]).
true(Statement, Proof, Trace) :-
    Statement = Subject be _,
    askable(Subject, Menu),
    \+ derived(Statement, _),
    \+ asked(Subject),
    ask(Statement, Subject, Proof, Trace, Menu).


ask(Statement, Subject, Proof, Trace, [Val]) :-
    format("\nIs it true that ~w is ~w ? Please answer 'yes', 'no' o r 'why'.\n",[Subject, Val]),
    read_string(user_input, "\n", "\r\t", _, Answer),
    process_yes_no(Answer, Statement, Subject, Proof, Trace, [Val]).

ask(Statement, Subject, Proof, Trace, [V,V1|Vs]) :-
    Menu = [V,V1|Vs],
    %    <YOUR CODE HERE>
    format("Choose correct variant for ~w (input line number): \n", [Subject]),
    show_menu(1, Menu),
    read_string(user_input, "\n", "\r\t", _, Answer),
    process(Answer, Statement, Subject, Proof, Trace, Menu). 

show_menu(_, []).
show_menu(Counter, [V|Vs]) :-
    format("~d: ~w\n", [Counter, V]),
    Next #= Counter + 1,
    show_menu(Next, Vs).

process("why", Statement, Subject, Proof, Trace, Menu) :- !,
    show_reasoning_chain(Trace), nl,
    ask(Statement, Subject, Proof, Trace, Menu).

process(StrInd, Statement, Subject, Proof <== was_told, _, Menu) :-
    atom_number(StrInd, Ind),
    nth1(Ind, Menu, MenuVal),
    !,
    Proposition = Subject be MenuVal,
    Proof = Proposition,
    asserta(derived(Proposition, was_told)),
    asserta(asked(Subject)),
    Proposition == Statement.

process(_, Statement, Subject, Proof, Trace, Menu) :-
    write("Incorrect answer! Try again, please\n"),
    ask(Statement, Subject, Proof, Trace, Menu).

process_yes_no("yes", Statement, Subject, Statement <== was_told, _, _) :-
    !,
    asserta(derived(Statement, was_told)),
    asserta(asked(Subject)).
process_yes_no("no", _, Subj, _, _, _) :-
    !,
    asserta(asked(Subj)),
    fail.
process_yes_no("why", Statement, Subject, Proof, Trace, Menu) :-
    !,
    show_reasoning_chain(Trace), nl,
    ask(Statement, Subject, Proof, Trace, Menu).
process_yes_no(_, Statement, Subject, Proof, Trace, Menu) :-
    write("Please answer 'yes', 'no' or 'why'!\n"),
    ask(Statement, Subject, Proof, Trace, Menu).

show_reasoning_chain([]).
show_reasoning_chain([if Cond then Concl | Rules]) :-
    format("\n   To infer ~w, using rule\n   (if ~w then ~w)", [Concl, Cond, Concl]),
    show_reasoning_chain(Rules).

verify(Info, Hyp, Hyp <== How) :-
    if Cond then Hyp,
    contains_term(Info, Cond),
    not(derived(Hyp, _)),
    not(rejected(Hyp)),
    (
        true(Hyp, Hyp <== How, []) % if
        -> !, asserta(derived(Hyp, How)) % then
        ; asserta(rejected(Hyp)), fail % else
    ).

infer(Info, Final, Expl, FinalExpl) :- 
    verify(Info, Hyp, How),
    !, % для убирания лишних бэктреков. А именно, мы не пойдём в Final = Info...
    infer(Hyp, Final, How, FinalExpl) ;

    Final = Info,
    FinalExpl = Expl.

infer(Conclusion, Proof) :-
    infer(_, Conclusion, "Can't infer something from the information provided.", Proof), !.

startBackward :-
    clear,
    write("Welcome to expert system!\n"),
    write("    (Try choose 3 1 1 1 - 2 1 - 4 3 1 to get a fern)"),
    infer(Conclusion, How),
    format("Conclusion: ~w\nExplanation: ~w", [Conclusion, How]).

startForward :- 
    clear,
    write("Forward hi!\n"),
    forward_infer([]).

forward_infer(OldFacts) :-
    findall(NewFact, (if Cond then NewFact, can_infer(Cond), \+ member(NewFact, OldFacts), asserta(derived(NewFact, Cond))), NewFacts),
    
    ((NewFacts == []) -> 
        findall(Y, derived(flower be Y, _), ListOfFlowers),
        format("Forward done. Facts: ~w\nFlowers for you: ~w", [OldFacts, ListOfFlowers])
        ;
        append(OldFacts, NewFacts, UpdatedFacts),
        forward_infer(UpdatedFacts)
    ).

can_infer(Cond) :- true(Cond, _, []).


addFacts :- 
    fact(humidity, high),
    fact(temperature, cold),
    fact(light, low),
    fact(wind, calm),
    
    fact(size, medium),
    fact(decorative, yes),

    fact(stem, large),
    fact(leaves, many),
    fact(flowers, no). 

addFacts2 :- 
    fact(humidity, medium),
    fact(temperature, warm),
    fact(light, high),
    fact(wind, windy),
    
    fact(size, medium),
    fact(decorative, yes),

    fact(stem, small), fact(stem, large),
    fact(leaves, no), fact(leaves, many),
    fact(flowers, few). 

fact(X, Y) :- 
    format("Fact: ~w\n", [X be Y]),
    assertz(derived(X be Y, was_told)),
    assertz(asked(X)).

clear :- 
    retractall(derived(_, _)), 
    retractall(rejected(_)), 
    retractall(asked(_)).

demoBackward :-
    clear,
    write("Welcome to backward demo!\n"),
    addFacts,
    infer(Conclusion, How),
    format("Conclusion: ~w\nExplanation: ~w", [Conclusion, How]). 

demoBackward2 :-
    clear,
    write("Welcome to backward demo!\n"),
    addFacts2,
    infer(Conclusion, How),
    format("Conclusion: ~w\nExplanation: ~w", [Conclusion, How]). 

demoForward :-
    clear,
    addFacts,
    write("Welcome to forward demo!\n"),
    findall(X, derived(X, _), List),
    forward_infer(List).

demoForward2 :-
    clear,
    addFacts2,
    write("Welcome to forward demo!\n"),
    findall(X, derived(X, _), List),
    forward_infer(List).
