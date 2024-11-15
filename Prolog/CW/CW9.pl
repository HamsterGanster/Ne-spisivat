/*
 *
 * Let us consider two problems. The first problem is to find a path in a tree.
 *         a
 *       /   \
 *      b     c
 *    /  \    | \
 *   d    e   g [f]
 *  /    / \      \
 * h    i  [j]    k
 *
 * Let j and f be goal nodes. We want to find all possible paths from a selected
 * node to the one of the goal ones.
 *
 * The second problem is similar to Hanoi tower. Consider the following example:
 *
 * c                      a
 * a            ----->    b
 * b                      c
 * __________             _______________
 *
 * We have 3 blocks a, b and c lying on a table in a stack, and we want them
 * rearranged as the figure shows. The problem is to find a plan for a robot to
 * rearrange a stack. The robot is only allowed to move one block at a time.
 * A block can be grasped only when its top is clear, i.e. there are no blocks atop of it.
 * A block can be put on the table or on some other block. A plan is a sequence of
 * moves transforming left state to the right.
 */

:- use_module(library(clpfd)).

ll([], 0).
ll([_|Ls], N) :- N #> 0, N0 #= N - 1, ll(Ls, N0).

% First let us describe a tree using the following relation.
% ts(?Parent, ?Child) - tree_successor
% It holds if Child is child node of a Parent. Child is a successor of a Parent.
% For example b and c are children of a.
ts(a, b).
ts(a, c).
ts(b, d).
ts(b, e).
ts(c, f).
ts(c, g).
ts(d, h).
ts(e, i).
ts(e, j).
ts(f, k).

% Nodes f and j are goals.
t_goal(j).
t_goal(f).


% For more complex state spaces representing the successor
% relation as a set of facts would be impractical or even
% impossible. Therefore, it could be defined implicitly
% by stating the rules for computing successor nodes of a
% selected node.
%
% ss(?Curr, ?Next) - state successor.
% It holds iff Next is a successor state of the Curr.
% For the stacks of blocks the Next is a successor of Curr
% if there are 2 stacks, S1 and S2 in Curr, and the top block
% of S1 can be moved to S2.
% A state is represented as a list of stacks currently on
% the table. To make it more relevant to real world problem
% let us limit the maximum number of stacks allowed on the table.
% Empty stacks are represented by empty lists.


% Надеюсь, работает как код Алексея Сергеевича 
% (на семинаре не успел переписат — своё накалякал).
% [_1, S1, _2, S2, _3] -> [S1, S2, _1, _2, _3] -> [S1', S2', Rest]
% S1' = S1 без верхушки TopS1
% S2' = S2 + верхушка TopS1
ss(Curr, [S1Tail, [TopS1|S2] | Rest]) :-
    S1 = [TopS1 | S1Tail], % "берём", вершину из S1
    remove(S1, Curr, WithoutS1),
    remove(S2, WithoutS1, Rest).


% ss([[c, a], [b], []], Next).
% Next = ...
% bca, [], []
% c, b, a
% a, cb, []
% 

% remove(what, where, result)
remove(B, [B|Bs], Bs).
remove(B, [B1|Bs], [B1|Bs1]) :- dif(B,B1), remove(B, Bs, Bs1).

% A goal state is any arrangement with the ordered stack
% of required form.
s_goal(S) :- member([a,b,c],S).

% Depth-first search.
% df_search(+SuccRel, +GoalRel, +Seen, +Start, -Solution)
% SuccRel - successor relation (for example ts or ss)
% GoalRel - goal relation (t_goal or s_goal)
% Seen    - list of states we already been in
% Start   - starting node
% Solution- required sequence of state-to-state moves
%
% Note that the predicate constructs solution in a
% straight order, i.e. solution is a list starting
% from the Start and ending with a goal.
% Some other DF-search strategies represent solutions
% in the inverse order.
df_search(_, Goal, _, G, [G]) :- call(Goal, G).
df_search(Succ, Goal, Seen, N, [N|Path]) :-
    call(Succ, N, Sn),
    \+ memberchk(Sn, Seen), % preventing being at the same state more than once
    df_search(Succ, Goal, [Sn|Seen], Sn, Path).

% итеративная глубина глубина первый поиск (ID-DFS)

% Find solutions of our two problems.
% For example:
% ?- solve_tree(a, Sol).
% ?- solve_stacks([[c,a,b],[],[]], Sol).
solve_tree(N, Sol) :-
    df_search(ts, t_goal, [], N, Sol).

solve_stacks(N, Sol) :-
    df_search(ss, s_goal, [], N, Sol).

% iddf_search(Succ, Goal, Node, Sol, Depth)
iddf_search(Succ, Goal, Node, Sol, Depth) :-
    ll(Sol, Depth), % ограничили длину дерева, чтобы в бесконечность не уходить.
    df_search(Succ, Goal, [], Node, Sol).

iddf_search(Succ, Goal, Node, Sol, Depth) :-
    % Нужно узнать, существует ли вообще какой-нибудь путь длины Depth, вдруг мы уже максимум прошли — дальше некуда углубляться.
    ll(ArbitaryPath, Depth), 
    df_search(Succ, =(_), [], Node, ArbitaryPath), % =(_) любая вершина. Просто _ нельзя, потому что должен быть предикат.
    !,
    DepthNext #= Depth + 1,
    iddf_search(Succ, Goal, Node, Sol, DepthNext).


% BFS — поиск в ширину
%
% [Curr, ..., (сюда)]
% ↓             ↑
% [b, a]        ↑
% ↓             ↑
% [c1, b, a] →→→↑
% [c2, b, a] →→→↑
% Внести их в конец списка и убрать Curr, иначе весело будет :)
bf_search(_, Goal, [Sol|_], Sol) :-
    Sol = [G | _],
    call(Goal, G).
bf_search(Succ, Goal, [Curr | Rest], Sol) :-
    % Curr = [b, a] для примера
    Curr = [B | _], 
    % ищем все c (c1, c2...) — детей b.
    % Children = [c1, c2...]
    % ChildrenPlusCurr = [[c1, b, a], [c2, b, a]...]
    findall(
        [C | Curr], % Что ищем
        (
            call(Succ, B, C), % C <- B
            not(memberchk([C | Curr], Rest)) % Такого ещё нет в списке решений
        ), 
        ChildrenPlusCurr
        ), 
    append(Rest, ChildrenPlusCurr, RestAndChildrenPlusCurr),
    bf_search(Succ, Goal, RestAndChildrenPlusCurr, Sol).

% LET'S OPTIMIZE !
bf_search_d(_, Goal, [Sol|_], Sol) :-
    Sol = [G | _],
    call(Goal, G).
bf_search_d(Succ, Goal, [Curr | Rest] - T, Sol) :-
    Curr = [B | _], 
    findall(
        [C | Curr],
        (
            call(Succ, B, C),
            not(memberchk([C | Curr], Rest))
        ), 
        ChildrenPlusCurr
        ), 
    % append
    % T = ChildrenPlus + T1
    % где T — старая пустышка
    %     T1 — новая пустышка
    append(ChildrenPlusCurr, T1, T),
    % проверить что Rest не пуст, а то вычитаем пустышку из ничего — пустышка любая.
    dif(Rest, T1), 
    bf_search(Succ, Goal, Rest - T1, Sol).