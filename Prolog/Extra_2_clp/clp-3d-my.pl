/*
 * Трехмерная версия задачи "блоки в коробках".
 * Мы продолжаем использовать предопределенные блоки вместо
 * получения их в качестве параметров командной строки, потому что
 * это в данный момент не имеет значения.
 */

:- use_module(library(clpr)).

:- op(400, xfx, inside).
:- op(400, xfx, no_overlap).


% Блоки
% Теперь блоки имеют не только ширину и высоту, но и глубину.
% Давайте обозначим размеры блоков как _x, _y и _z.
block(b1, d(1.0, 3.0, 2.0)).
block(b2, d(2.0, 2.0, 1.0)).
block(b3, d(2.0, 1.0, 1.0)).
block(b4, d(2.0, 1.0, 1.0)).
block(b5, d(1.0, 1.0, 1.0)).
block(b6, d(1.0, 1.0, 1.0)).
block(b7, d(1.0, 1.0, 1.0)).
block(b8, d(1.0, 1.0, 1.0)).

block(b9,  d(2.0, 1.0, 1.0)).
block(b10, d(2.0, 1.0, 1.0)).
block(b11, d(2.0, 1.0, 1.0)).
block(b12, d(2.0, 1.0, 1.0)).
block(b13, d(2.0, 2.0, 1.0)).

block(b14, d(2.0, 2.0, 2.0)).

% Коробки (name, size)

box(box1, d(6.0, 6.0, 6.0)).
box(box2, d(3.0, 3.0, 2.0)).
box(box3, d(2.0, 2.0, 2.0)).
box(box4, d(2.0, 2.0, 2.0)).

% rot(?Rect, ?RotatedRect)
% Поворот прямоугольника в трехмерном пространстве
%
% Повороты ZX и YX имеют избыточное ограничение
% _y =\= _z, которое необходимо для отсечения лишних
% обратных вызовов. Рассмотрим следующий пример:
%
% rot(_, d(2, 1, 1), R).
% Существует только 3 различных поворота:
% R = (2, 1, 1)
% R = (1, 2, 1)
% R = (1, 1, 2)
% Но без ограничения избыточности правила поворота могли бы возвращать
% избыточные решения, которые уже были возвращены предыдущими правилами.

% Вариант как у вас — без фильтрации.
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(X, Y, Z))). % Нулевой поворот, "вертикальна" ось X
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(X, Z, Y))). % Поворот на 90 градусов вокруг оси X.
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Y, X, Z))). % Нулевой поворот, "вертикальна" ось Y.
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Y, Z, X))). % Поворот на 90 градусов вокруг оси Y.
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Z, X, Y))). % Нулевой поворот, "вертикальна" ось Z.
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Z, Y, X))). % Поворот на 90 градусов вокруг оси Z.

% Начал перебирать все варинаты на листочке но так и не дошёл до нужных условий {}:
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(X, Y, Z))). % Нулевой поворот, "вертикальна" ось X
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(X, Z, Y))) :- {Y =\= Z}. % Поворот на 90 градусов вокруг оси X, если Y != Z. Иначе дубликаты будут
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Y, X, Z))) :- {X =\= Y}. % Нулевой поворот, "вертикальна" ось Y, если Y != X. Иначе дубликат.
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Y, Z, X))) :- {X =\= Y, X =\= Z}. % Поворот на 90 градусов вокруг оси Y. Условие для 2 и 3.
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Z, Y, X))) :- {Z =\= X, Z =\= Y}. % Нулевой поворот, "вертикальна" ось Z
% rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Z, X, Y))) :- {Z =\= X, Z =\= Y, X =\= Y}. % Поворот на 90 градусов вокруг оси Z. Условие для 5 и 3.

% % Поэтому решил брать все перестановки и отсеивать повторы:
rot(rect(Pos, d(X, Y, Z)), rect(Pos, d(Xret, Yret, Zret))) :- memberchk([Xret, Yret, Zret], Perm), permutations_without_repetition([X, Y, Z], Perm).
permutations_without_repetition(List, GoodPermutation) :-
    % нашёл этот предикат на сайте SWI-Prolog
    setof(Permutation, permutation(List, Permutation), GoodPermutation).

% Размещение блока в коробке, что означает назначение минимального прямоугольника, который вмещает блок.
% place_block(+BlockName, -Place).
% Place = rect(Pos, Dim).

place_block(BlockName, rect(Pos, Dim)) :-
    % Получить блок
    block(BlockName, BDim),
    % Блок может быть повернут, чтобы подогнаться к позиции
    % Обратите внимание, что это может быть нулевой поворот
    rot(rect(Pos, BDim), rect(Pos, Dim)).


% inside(+Rect1, +Rect2)
% Предикат выполняется тогда и только тогда, когда Rect1 полностью находится внутри Rect2

inside(rect(pos(X1, Y1, Z1), d(W1, H1, D1)), rect(pos(X2, Y2, Z2), d(W2, H2, D2))) :-
    {X1 >= X2,
     Y1 >= Y2,
     Z1 >= Z2,
     X1 + W1 =< X2 + W2,
     Y1 + H1 =< Y2 + H2,
     Z1 + D1 =< Z2 + D2}.


% no_overlap(+Rect1, +Rect2)
% Выполняется тогда и только тогда, когда Rect1 и Rect2 не пересекаются
%
% Обратите внимание, что мы добавили избыточные ограничения,
% чтобы предотвратить ненужные обратные вызовы. Это лучше,
% чем добавление cuts, потому что они разрушают 
% декларативную семантику ограничений.

no_overlap(rect(pos(X1, Y1, Z1), d(W1, H1, D1)), rect(pos(X2, Y2, Z2), d(W2, H2, D2))) :-
    {X1 + W1 =< X2 ;
     X2 + W2 =< X1 ;
     Y1 + H1 =< Y2 ;
     Y2 + H2 =< Y1 ;
     Z1 + D1 =< Z2 ;
     Z2 + D2 =< Z1}.


% arrange(+Box, ?Arranged, ?NotArranged)
% Box         : Имя коробки
% Arranged    : Список блоков, которые уже размещены в коробке
% NotArranged : Список блоков, которые еще не размещены
arrange(_, _, []).
arrange(Box, Arranged, [Bname/Bi|Bs]) :-
    place_block(Bname, Bi),
    Bi inside Box,
    maplist(no_overlap(Bi), Arranged),
    arrange(Box, [Bi|Arranged], Bs).

% arrange(+BoxName, +Blocks)
% BoxName  : имя коробки, в которую мы хотим поместить блоки
% Blocks   : список блоков, где каждый элемент имеет следующий вид:
%            BlockName/Rectangle3D
%
% ?- arrange(box1, [b1/R1,b2/R2,b3/R3,b4/R4]).
% R1 = rect(pos(1.0, 3.0), d(5.0, 3.0)),
% R2 = rect(pos(0.0, 1.0), d(6.0, 2.0)),
% R3 = rect(pos(0.0, _A), d(1.0, 2.4)),
% R4 = rect(pos(1.0, 0.0), d(5.0, 1.0)),
% {_A=<3.6, _=3.0-_A, _A>=3.0} ;
% ...
arrange(BoxName, Blocks) :-
    box(BoxName, BoxDim),               % найти коробку (name, size)
    Box = rect(pos(0.0, 0.0, 0.0), BoxDim),  % Box - прямоугольная область, занимаемая коробкой
    arrange(Box, [], Blocks).
 

% Часть "для себя":
% Подсчёт количества расстановок
count(BoxName, Blocks, Count, List) :-
    findall(Blocks, arrange(BoxName, Blocks), List),
    length(List, Count).