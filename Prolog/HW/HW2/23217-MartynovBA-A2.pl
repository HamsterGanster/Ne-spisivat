:- use_module(library(clpfd)).
:- use_module('/wnload/prolog/wn').

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

ll([], 0).
ll([_|Tail], N) :- N #> 0, N #= N1 + 1, ll(Tail, N1).

notLonger(List, MaxLen) :- 
    Len #=< MaxLen,
    ll(List, Len).

upath(N, N, [], _).
upath(Word1/PoS1/Sense1/SynSet1, Word2/PoS2/Sense2/SynSet2, [SynSetConnectionMore | Tail], Buff) :- 
    % anyConnection(SynSet1, SynSetNext, SynSetConnection), % связь есть
    % (
    %     SynSetConnection = (SynSet1, Type, SynSetNext);
    %     SynSetConnection = (SynSetNext, Type, SynSet1)
    % ),
    anyConnection(SynSet1, SynSetNext, (_, Type, _)), % связь есть
    
    AllNext = WordNext/PoSNext/SenseNext/SynSetNext,
    All1 = Word1/PoS1/Sense1/SynSet1,
    All2 = Word2/PoS2/Sense2/SynSet2,

    \+ memberchk(AllNext, Buff), % связи не было
    wn_s(SynSetNext, _, WordNext, PoSNext, SenseNext, _), % подборать слова, части речи и значение к SynSetNext

    SynSetConnectionMore = (All1, Type, AllNext),
    upath(AllNext, All2, Tail, [AllNext|Buff]). % рекурсивно искать и смотреть, что связи A не будет

hasConnection(All1, All2, Path) :- upath(All1, All2, Path, [All1]).

parseConnection([], []).
parseConnection([(Word1/PoS1/Sense1/SynSet1, Type, Word2/PoS2/Sense2/SynSet2) | SynSetConnectionTail], [CurConnection | ConnectionTail]) :-
    % wn_s(SynSet1, _, Word1, PoS1, Sense1, _),
    % wn_s(SynSet2, _, Word2, PoS2, Sense2, _),
    CurConnection = r(Word1/PoS1/Sense1, Type, Word2/PoS2/Sense2),
    parseConnection(SynSetConnectionTail, ConnectionTail).

related_words(Word1/PoS1/Sense1/SynSet1, Word2/PoS2/Sense2/SynSet2, MaxDist, Connection) :-
    wn_s(SynSet1, _, Word1, PoS1, Sense1, _),
    wn_s(SynSet2, _, Word2, PoS2, Sense2, _),
    notLonger(SynSetConnectionMore, MaxDist),
    hasConnection(Word1/PoS1/Sense1/SynSet1, Word2/PoS2/Sense2/SynSet2, SynSetConnectionMore),
    parseConnection(SynSetConnectionMore, Connection).
