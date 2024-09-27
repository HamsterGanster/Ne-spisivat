/*
 * A simple route calculator.
 */

% There are the following places we want to travel between
place(  'Auckland'  ).
place(  'Hamilton'  ).
place(   'Raglan'   ).
place(  'Valmont'   ).
place('Saarbruecken').
place(    'Metz'    ).
place(  'Frankfurt' ).
place(   'Paris'    ).
place(  'Bangkok'   ).
place( 'Singapore'  ).
place( 'LosAngeles' ).

:- use_module(library(clpfd)).

trip('Auckland'    , 'Hamilton'    , car  ). % Traveling from Aucklang to Hamilton by car
trip('Hamilton'    , 'Raglan'      , car  ). % Traveling from Hamilton to Raglan bt car
trip('Valmont'     , 'Saarbruecken', car  ). % Traveling from Valmont to Saarbruecken by car
trip('Valmont'     , 'Metz'        , car  ). % Traveling from Valmont to Metz by car
trip('Metz'        , 'Frankfurt'   , train). % Traveling from Metz to Frankfurt by train
trip('Saarbruecken', 'Frankfurt'   , train). % Traveling from Saarbruecken to Frankruth by train
trip('Metz'        , 'Paris'       , train). % Traveling from Metz to Paris by train
trip('Saarbruecken', 'Paris'       , train). % Traveling from Saarbruecken to Paris by train
trip('Frankfurt'   , 'Bangkok'     , plane). % Traveling from Frankfurt to Bangkok by plane
trip('Frankfurt'   , 'Singapore'   , plane). % Traveling from Frankfurt to Singapore by plane
trip('Paris'       , 'LosAngeles'  , plane). % Traveling from Paris to Los Angeles by plane
trip('Bangkok'     , 'Auckland'    , plane). % Traveling from Bangkok to Aucklang by plane
trip('LosAngeles'  , 'Auckland'    , plane). % Traveling from Los Angeles to Aucklang by plane

% If you can travel from place A to place B by some T then you can do vice versa and
% travel from B to A by the same means. Hence we need to make our graph an undirected graph.
%
% directly_connected(?First, ?Second, ?T) holds iff it is possible to travel from a
% place 'First' to a place 'Second' by 'T' and vise versa.

% <YOUR CODE HERE>
% BAN
% trip(B, A, T) :- trip(A, B, T).
% GOOD:
directly_connected(A, B, T) :- trip(B, A, T); trip(A, B, T).
dc(A, B, T) :- directly_connected(A, B, T).

% Knowing how to travel to the nearest place, now we want to travel to any place possible.

% <YOUR CODE HERE>
%path(from, to, Path, Buffer).
path(N, N, [N], _).
path(A, B, [A,T|Path], Buff) :- 
    dc(A, Next, T), 
    \+ memberchk(Next, Buff),
    path(Next, B, Path, [A|Buff]).
path(A, B, Path) :- path(A, B, Path, []).