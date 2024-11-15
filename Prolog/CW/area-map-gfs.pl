/*
 * Greedy First Search on a 2-dimensional map.
 */

:- use_module(library(clpfd)).
:- use_module('area-map').

% came_from(?Where, ?From)
%
% The relation holds if and only if we have come to the cell 'Where'
% from the cell 'From' while traversing the map.
:- dynamic came_from/2.

% unroll(+CurrentNode, +PartialPath, -Path)
%
% Go from Goal to Start, making a path. At each step we add a current node to a path
% and go to the previous node via the came_from/2 relation.
%
% Consider the query:
%
% ?- unroll(Goal, [], Path)
%
% We start at the goal node with an empty partial path.
% Let us assume that there is a node Nk such that came_from(Goal, Nk), meaning we came
% to the Goal from Nk. Then we add Goal to the partial path and proceed from Nk:
% unroll(Nk, [Goal], Path). Let's now assume there is Nk-1 such that came_from(Nk, Nk-1) holds.
% Now we have to unroll(Nk-1, [Nk, Goal], Path). And so on until we find outselves
% at the starting node.
% unroll(Start, [N1, N2, ..., Nk-1, Nk, Goal], Path). Here we should add the starting node to
% our path to make in complete, ending up with Path = [Start, N1, N2, ..., Nk-1, Nk, Goal]

unroll(CurrentNode, PartialPath, Path) :-
  came_from(CurrentNode, FromNode),
  FromNode #>= 0,
  unroll(FromNode, [CurrentNode | PartialPath], Path).
unroll(Start, PartialPath, [Start | PartialPath]) :-
  came_from(Start, From),
  From #< 0.

% h(Goal, Node, H)
%
% Heuristic function. In this case heuristic is a Manhattan distance from a Node to Goal
% Let P1 (x1, y1) and P2 (x2, y2) be points in 2d space. Manhattan distance between P1
% and P2 is computed as follows:
%
% M = |x1 - x2| + |y1 - y2|

h(Goal, Node, H) :-
  grid_cell(Goal, coords(X1, Y1), Cost1), 
  grid_cell(Node, coords(X2, Y2), Cost2), 
  abs(X2 - X1, X),
  abs(Y2 - Y1, Y),
  H #= X + Y.

% insert(+Elem, +Sorted, -ExtendedSorted)
%
% Add an element of a form (Node, H) to a sorted list of similar pairs.
% 'Sorted' is sorted by the second member of a pair ascending.

insert((Node, H), [], [(Node, H)]).
insert((Node, H), [(CurNode, CurH) | Sorted], [(CurNode, CurH) | ExtendedSorted]) :- 
  CurH #< H,
  insert((Node, H), Sorted, ExtendedSorted).
insert((Node, H), [(CurNode, CurH) | Sorted], [(Node, H), (CurNode, CurH) | Sorted]) :-
  CurH #>= H.
% можно поменять местами и добавить cut !
% insert((Node, H), [(CurNode, CurH) | Sorted], [(Node, H), (CurNode, CurH) | Sorted]) :-
%     CurH #>= H,
%     !.
% insert(X, [Y | Sorted], [Y | ExtendedSorted]) :- 
%   insert(X, Sorted, ExtendedSorted).


% update(+NewNodes, +Frontier, -ExtendedFrontier)
%
% Extend frontier with new nodes.

update([], F, F).
update([N | Ns], Acc, Extend) :- 
  insert(N, Acc, Buff),
  update(Ns, Buff, Extend).

% record(+Neighbors, +Node)
%
% add facts of a form came_from(N, Node) where N is a neighbor of Node

record([], _).
record([(Neighbor, _) | Ns], Node) :- asserta(came_from(Neighbor, Node)), record(Ns, Node).


% gs_search(+Goal, +Frontier, -Path)
%	Goal:		cell we want to be in
%	Frontier:	a list of cells we want to traverse; each element of the frontier
%				is a pair of a form (CellID, CellPriority) where CellPriority is a
%				value of the heuristic function on the CellID. Frontier is sorted on
%				in ascending order of the CellPriority.
%	Path:		a path we want to construct
%
% Explore frontier. On each step pick the most promising cell from the frontier,
% which is always the first element of the frontier since the frontier is sorted by priority.
% Then get all the neighbors of the cell picked, and add them to the frontier keeping
% its sorted state.

gf_serach(Goal, [(Goal, _)| Rest], Path) :-
  unroll(Goal, [], Path), % then
  !. % if Goal лежит в голове

gf_search(Goal, [(Curr, CurrH) | TailFrontier], Path) :-
  findall(
    (Nb, NbH), 
      (
        neighbor(Curr, Nb), 
        not(came_from(Nb, Curr)),
        h(Nb, Goal, NbH)
      ), 
    Neighbors
  ),
  record(Neighbors, Curr), % do asserta(came_from(Neighbor, Curr))
  update(Neighbors, Rest, ExtendedRest),
  gf_search(Goal, ExtendedRest, Path). 
  


% greed_search(?Start, ?Goal, -Path)
%	Start:	the cell we start from
%	Goal:	the cell we want to come to
%	Path:	path from Start to Goal as a list of cells
%
%	Traverse the map taking directions shown by the heuristic function.
%	Stops when Goal is reached.

greed_search(Start, Goal, Path) :-
	retractall(came_from(_,_)),		% clean previous data if present
	asserta(came_from(Start, -1)),	% we did not come to the starting point from anywhere
	gf_search(Goal, [(Start, 0)], Path). % 0 is 'Manhetanskoe' distance, our heuristic