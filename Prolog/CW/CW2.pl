mm(X, [X | _]) :- !.
mm(X, [_ | Tail]) :- mm(X, Tail).

% мы точки на плоскости
f(1).
f(2).
f(3).

g(10).
g(20).
g(30).

f1(X,Y) :- f(X), g(Y).
f1(100, 200).

% ?- f1(X, Y).
% X = 1,
% Y = 10 ;
% X = 1,
% Y = 20 ;
% X = 1,
% Y = 30 ;
% X = 2,
% Y = 10 ;
% X = 2,
% Y = 20 ;
% X = 2,
% Y = 30 ;
% X = 3,
% Y = 10 ;
% X = 3,
% Y = 20 ;
% X = 3,
% Y = 30 ;
% X = 100,
% Y = 200.

% отрезали все иксы кроме 1 и решение (100, 200)
f2(X, Y) :- f(X), !, g(Y).
f2(100, 200).

%?- f2(X, Y).
% X = 1,
% Y = 10 ;
% X = 1,
% Y = 20 ;
% X = 1,
% Y = 30.

%?- f2(100, 200). 
% true





%%%%%%%%%%%%%%%%%%%%%%%%%%

animal(dog).
animal(cat).
animal(viper). % гадюка

snake(apple).

% 2 строки ниже вечный false
likes(mary, A) :- snake(A), !, fail.
likes(mary, A) :- animal(A).

neg(G) :- G, !, fail. % если G доказали, строка дальше не вызовется, будет fail (== false)
neg(G).
% Аналогичный вариант.
neg_(G) :- G, !, fail; true.
% Вечный false. Потому что сращу отсекаем и никогда не попадём в true.
% Либо G. значит false. Либо ничего, так как в true попасть невозможно.
neg_(G) :- !, G, fail; true. 

likes_(mary, X) :- animal(X), neg(snake(X)).

% ?- write_canonical((2*2)).
% *(2,2).

% Как же всё-таки посчитать?
% ?- X is 2*2.
% X = 4.

:- use_module(library(clpfd)).
fn(0, 1).
% fn(1, 1).
fn(N, Res) :- 
    N #> 0,
    N1 #= N - 1, 
    fn(N1, Res1), 
    Res #= N*Res1.

fc(N, F) :- N #> 0, fc(N, 1, 1, F).
fc(N, N, F, F).
fc(N, C, B, F) :-
    C #< N,
    Cnext #= C + 1,
    Bnext #= B * Cnext,
    fc(N, Cnext, Bnext, F).

fib(0, 0).
% fib(1, 1).
% fib(2, 1).
% fib(N, Answer) :- 
%     N #> 1,
%     S1 #= N-2,
%     S2 #= N-1,
%     Answer #>= Ans2,
%     fib(S1, Ans1),
%     fib(S2, Ans2), 
%     Answer #= Ans1 + Ans2.

fib(N, F) :- N #> 0, fib(N, 1, 0, 1, F).
fib(N, N, F1, F, F).
fib(N, C, B1, B2, F) :-
    C #< N,
    Cnext #= C + 1,
    B1Next #= B2,
    B2Next #= B1 + B2, 
    fib(N, Cnext, B1Next, B2Next, F).