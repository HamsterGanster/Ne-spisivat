/*
* Более общий вариант решения задачи размещения прямоугольных блоков в коробке.
* Теперь предикат arrange/2 принимает имя коробки и список блоков в следующем виде:
* [BlockName/BlockRect, ...].
*/
:- use_module(library(clpr)).
:- op(400, xfx, inside).
:- op(400, xfx, no_overlap).

% Размещение блоков в коробке
%
% block(+BlockName, +BlockDim).
% BlockDim = d(W, H) - размеры блока.
%
%  ___________________
% |                   |
% |                   |
% |___________________|
% y
% ^
% |
% ---> x
%
% Существует 4 предопределенных блока.

block(b1, d(5.0, 3.0)).
block(b2, d(2.0, 6.0)).
block(b3, d(1.0, 2.4)).
block(b3_, d(1.0, 1.0)).
block(b3_, d(0.5, 0.5)).
block(b4, d(1.0, 5.0)).

% Также существует 3 различные коробки

box(box1, d(6.0, 6.0)).
box(box2, d(7.0, 5.0)).
box(box3, d(6.0, 5.0)).

% Представление прямоугольной области, занимаемой блоком внутри контейнера, следующее:
% rect(+Pos, +Dim)
% Pos = pos(X, Y) - координаты левого нижнего угла блока.
% Dim = d(W, H)   - размеры блока
%
% rect/2 представляет прямоугольник размера W, H в позиции (X, Y).
%
% Положение прямоугольника в коробке определяется координатами левого нижнего угла прямоугольника,
% относительно левого нижнего угла коробки.

% rot(?Rect, ?RotatedRect)
% Возможные повороты прямоугольника в двумерном пространстве. Очевидно, что прямоугольный
% блок может находиться только в двух позициях: d(W, H) или d(H, W).

% Ваш вариант, квадрат учитывается дважды.
rot(rect(Pos, Dim), rect(Pos, Dim)). % Нулевой поворот
rot(rect(Pos, d(W, H)), rect(Pos, d(H, W))). % Поворот на 90 градусов

% rot(rect(Pos, Dim), rect(Pos, Dim)). % Нулевой поворот
% rot(rect(Pos, d(W, H)), rect(Pos, d(H, W))) :- {W =\= H}. % Поворот на 90 градусов

% Размещение блока в коробке, что означает назначение минимального прямоугольника, который вмещает блок.
% place_block(+BlockName, -Place).
% Place = rect(Pos, Dim).

% (BName, Bi)
place_block(BlockName, rect(Pos, Dim)) :-
    % Получить блок
    block(BlockName, BDim),
    % Блок может быть повернут, чтобы подогнаться к позиции
    % Обратите внимание, что это может быть нулевой поворот
    rot(rect(Pos, BDim), rect(Pos, Dim)).

% inside(+Rect1, +Rect2)
% Предикат выполняется тогда и только тогда, когда Rect1 полностью находится внутри Rect2
inside(rect(pos(X1, Y1), d(W1, H1)), rect(pos(X2, Y2), d(W2, H2))) :-
    {X1 >= X2,               % X1 должен находиться справа от X2
     Y1 >= Y2,
     X1 + W1 =< X2 + W2,     % Rect1 не должен выходить за пределы Rect2
     Y1 + H1 =< Y2 + H2}.

% no_overlap(+Rect1, +Rect2)
% Выполняется тогда и только тогда, когда Rect1 и Rect2 не пересекаются
no_overlap(rect(pos(X1, Y1), d(W1, H1)), rect(pos(X2, Y2), d(W2, H2))) :-
    { X1 + W1 =< X2 ; % Прямоугольники находятся слева или справа друг от друга
      X2 + W2 =< X1 ;
      Y1 + H1 =< Y2 ; % Прямоугольники находятся выше или ниже друг друга
      Y2 + H2 =< Y1 }.

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
%            BlockName/Rectangle
%
% ?- arrange(box1, [b1/R1,b2/R2,b3/R3,b4/R4]).
% R1 = rect(pos(1.0, 3.0), d(5.0, 3.0)),
% R2 = rect(pos(0.0, 1.0), d(6.0, 2.0)),
% R3 = rect(pos(0.0, _A), d(1.0, 2.4)),
% R4 = rect(pos(1.0, 0.0), d(5.0, 1.0)),
% {_A=<3.6, _=3.0-_A, _A>=3.0} ;
% ...
arrange(BoxName, Blocks) :-
    box(BoxName, BoxDim),               % найти коробку
    Box = rect(pos(0.0, 0.0), BoxDim),  % Box - прямоугольная область, занимаемая коробкой
    arrange(Box, [], Blocks).


% Часть "для себя":
% Подсчёт количества расстановок
count(BoxName, Blocks, Count, List) :-
   findall(Blocks, arrange(BoxName, Blocks), List),
   length(List, Count).
% Без List
count(BoxName, Blocks, Count) :-
    findall(Blocks, arrange(BoxName, Blocks), List),
    length(List, Count).