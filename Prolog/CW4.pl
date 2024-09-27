% ab ac 
% bd 
% cd cf 
% de df

arc(a, b).
arc(a, c).
arc(b, d).
arc(c, d).
arc(c, f).
arc(d, e).
arc(d, f).

arc(f, a). % теперь есть цикл. Сначала идём по циклу: a-b-d-f-a.

path(N, N).
path(A, B) :- arc(A, Next), path(Next, B).

path(N, N, [N]).
path(A, B, [A | Path]) :- arc(A, Next), path(Next, B, Path). 

:- use_module(library(clpfd)).
ll([], 0).
ll([_|Tail], N) :- N #> 0, N #= N1 + 1, ll(Tail, N1).

path(N, N, [N], _).
path(A, B, Path, Len) :- ll(Path, Len), path(A, B, Path). 

%unitPath()
% upath(A, B, Buff, Path)
% Ps — Tail у меня
upath(N, N, [N], _).
upath(A, B, [A | Ps], Buff) :- 
    arc(A, Next),
    \+ memberchk(Next, Buff),
    upath(Next, B, Ps, [A|Buff]). 

upath(A, B, Path) :- upath(A, B, Path, []).