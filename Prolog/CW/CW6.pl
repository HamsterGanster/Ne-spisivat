% :- dynamic no_rain, kitchen_dry.

hall_wet.
bathroom_dry.
window_closed.

leak_in_bathroom :-
    hall_wet,
    kitchen_dry.

problem_in_kitchen :- 
    hall_wet,
    bathroom_dry.

no_water_from_outside :-
    no_rain;
    window_closed.

leak_kitchen :-
    problem_in_kitchen,
    no_water_from_outside. 


known(hall_wet).
known(bathroom_dry).
known(window_closed).

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).

true(Hyp) :- known(Hyp).
true(Hyp1 and Hyp2) :- true(Hyp1), true(Hyp2).
true(Hyp1 or Hyp2) :- true(Hyp1); true(Hyp2).
true(Hyp) :- if P then Hyp, true(P).

if 
    hall_wet and kitchen_dry
then 
    leak_in_bathroom.

if 
    hall_wet and bathroom_dry
then 
    leak_kitchen.

if 
    window_closed or no_rain
then  
    no_water_from_outside.


:- dynamic derived/1.
:- restractall(derived(_)).

fact(F) :- derived(F).
fact(F1 and F2) :- fact(F1), fact(F2).
fact(F1 or F2) :- fact(F1); fact(F2).


forward :- write("----------------").
forward_infernce() :- 
    restarctall(derived(_)) ,
    asserta(derivaed(F) :- known(F)),
    forward.

supposed(Hyp) :- if P then Hyp существует F derived(F), occur(F, P).
supposed(Hyp) :- if P then Hyp существует F derived(F), occur(F, P).

supposed(Hyp) :- 
    derived(Fact),
    (
        Cond = Fact;
        Cond = Fact and _;
        Cond = _ and Fact;
        Cond = Fact or _;
        Cond = _ or Fact
    ),
    if Cond then Hyp,
    not(derived(Hyp)),
    not(rejected(Hyp)).

hybrid :-
    supposed(Hyp), !,
    (
        true(Hyp) 
            -> format("Inferred that ~w.\n", [Hyp]),
            asserta(derived(Hyp)) % кстати, зачем asserta а не assertz. Потому что мы добавим гипотезу наверх, и следующие правила будут проверяться на наиболее сежей информации.
        ;
        assertz(rejected(Hyp))
    ),
    hybrid.

hybrid :- write("----------------").

hybrid_interface :-
    restarctall(derived(_)), % почисти
    restarctall(rejected(_)), % почтисти
    asserta(derived(F) :- known(F)),
    hybrid.