:- use_module(library(clpfd)).
:- use_module('/wnload/prolog/wn').
% % не вышло ничего с относительным путём :(
% :- prolog_load_context(directory, HWDir),
%     atom_concat(HWDir, '/', WNDB),
%     absolute_file_name(WNDB, WNDBPath),
%     asserta(user:file_search_path(wndb, WNDBPath)).

anyConnection(SynSet1, SynSet2, Connection) :-
    hyponym(SynSet1, SynSet2, Connection);
    memberMeronym(SynSet1, SynSet2, Connection);
    partMeronym(SynSet1, SynSet2, Connection).

% S1 ∈ S2 (так сказать "подмножество") или наоборот.
hyponym(SynSet1, SynSet2, Connection) :-
    (
        wn_hyp(SynSet1, SynSet2),
        Connection = (SynSet1, hyper, SynSet2)
    );
    (
        wn_hyp(SynSet2, SynSet1),
        Connection = (SynSet2, hyper, SynSet1)
    ).

% S1 ∈ S2 (так сказать "подмножество") или наоборот.
% Что-то из SynSet1 является "живой" частью чего-то из SynSet2.
% Напрмиер, вратарь — член/часть команды.
memberMeronym(SynSet1, SynSet2, Connection) :-
    (
        wn_mm(SynSet1, SynSet2),
        Connection = (SynSet1, member, SynSet2)
    );
    (
        wn_mm(SynSet2, SynSet1),
        Connection = (SynSet2, member, SynSet1)
    ).

% S1 ∈ S2 (так сказать "подмножество") или наоборот.
% Что-то из SynSet1 является неодушевлённой частью чего-либо из SynSet2.
% Например, ножка — часть стола.
partMeronym(SynSet1, SynSet2, Connection) :-
    (
        wn_mp(SynSet1, SynSet2),
        Connection = (SynSet1, part, SynSet2)
    );
    (
        wn_mp(SynSet2, SynSet1),
        Connection = (SynSet2, part, SynSet1)
    ).

% len of list from seminar 4.
ll([], 0).
ll([_|Tail], N) :- N #> 0, N #= N1 + 1, ll(Tail, N1).

notLonger(List, MaxLen) :- 
    Len #=< MaxLen,
    ll(List, Len).

% Find 'path' from seminar 4
upath(N, N, [], _).
% Вместо [A | Ps] я склеиваю Connections, то есть тройки вида (A, connection, B). 
upath(A, B, [Connection | Tail], Buff) :- 
    anyConnection(A, Next, Connection), % связь есть
    \+ memberchk(Next, Buff), % связи не было
    upath(Next, B, Tail, [Next|Buff]). % рекурсивно искать и смотреть, что связи A не будет

% [SynSet1] нужен, чтоб к перовому элементу не возвращаться.
% Щаметил прямо перед отправкой, сравнивая свой вывод (а именно пятый) с примером в задании.
hasConnection(All1, All2, Path) :- upath(All1, All2, Path, [All1]).

parseConnection([], []).
parseConnection([(SynSet1, X, SynSet2) | SynSetConnectionTail], [CurConnection | ConnectionTail]) :-
    wn_s(SynSet1, _, Word1, PoS1, Sense1, _),
    wn_s(SynSet2, _, Word2, PoS2, Sense2, _),
    CurConnection = r(Word1/PoS1/Sense1, X, Word2/PoS2/Sense2),
    parseConnection(SynSetConnectionTail, ConnectionTail).

related_words(Word1/PoS1/Sense1/SynSet1, Word2/PoS2/Sense2/SynSet2, MaxDist, Connection) :-
    wn_s(SynSet1, _, Word1, PoS1, Sense1, _),
    wn_s(SynSet2, _, Word2, PoS2, Sense2, _),
    notLonger(SynSetConnection, MaxDist),
    hasConnection(SynSet1, SynSet2, SynSetConnection),
    parseConnection(SynSetConnection, Connection).
