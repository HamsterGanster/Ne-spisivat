/*
 * Consider there is a set of rectangular blocks. It could be parcels or pallets. The question is, do they fit into a
 * given container. And if yes, how can they be placed into the container so they fit?
 *
 * Let us be in planar, 2-dimensional space for now.
 *
 * We will represent the dimensions of an object in the program by the predicate d(W, H), where W is a width, and H
 * is a height.
 */

:- use_module(library(clpr)).

:- op(400, xfx, inside).
:- op(400, xfx, no_overlap).

% Placing blocks into a box
%
% block(+BlockName, +BlockDim).
% BlockDim = d(W, H) - block dimensions.
%
%  ___________________
% |                   |
% |                   |
% |___________________|
% 
% y
% ^
% |
% ---> x
%
% Consider that there are 4 predefined blocks.

block(b1, d(5.0, 3.0)).
block(b2, d(2.0, 6.0)).
block(b3, d(1.0, 2.4)).
block(b4, d(1.0, 5.0)).

% and 3 different boxes.

box(box1, d(6.0, 6.0)).
box(box2, d(7.0, 5.0)).
box(box3, d(6.0, 5.0)).

% Representation of rectangular space a block occupied inside a container is the following:
% rect(+Pos, +Dim)
% Pos = pos(X, Y) - coordinates of the bottom-left corner of a block.
% Dim = d(W, H)   - block's dimensions
%
% rect/2 represents a rectangle of a size W, H at the position (X, Y).
%
% The position of a rectangle in a box is determined by the coordinates of the left-bottom corner of a
% rectangle, relative to the left-bottom corner of the box.

% rot(?Rect, ?RotatedRect)
% Possible rotations of a rectangle in the 2-dimensional space. It is obvious enough that a rectangular
% block can only be in two positions: d(W, H) or d(H, W).

rot(rect(Pos, Dim), rect(Pos, Dim)). % Zero rotation
rot(rect(Pos, d(W, H)), rect(Pos, d(H, W))). % Rotated by 90 degrees

% Place block into a box, which means assign a minimal rectangle that accomodates a block.
% place_block(+BlockName, -Place).
% Place = rect(Pos, Dim).

place_block(BlockName, rect(Pos, Dim)) :-
    % Get a block
    block(BlockName, BDim),
    % Block could be rotated to fit the position
    % Note that it could be a zero rotation
    rot(rect(Pos, BDim), rect(Pos, Dim)).

% inside(+Rect1, +Rect2)
% The predicate holds iff Rect1 is completely inside Rect2
inside(rect(pos(X1, Y1), d(W1, H1)), rect(pos(X2, Y2), d(W2, H2))) :-
    {X1 >= X2,               % X1 must be on the right-hand side of X2
     Y1 >= Y2,
     X1 + W1 =< X2 + W2,     % Rect1 must not go beyond Rect2
     Y1 + H1 =< Y2 + H2}.


% no_overlap(+Rect1, +Rect2)
% Holds iff Rect1 and Rect2 do not overlap
no_overlap(rect(pos(X1, Y1), d(W1, H1)), rect(pos(X2, Y2), d(W2, H2))) :-
    { X1 + W1 =< X2 ; % Rectangles are left or right of each other
      X2 + W2 =< X1 ;
      Y1 + H1 =< Y2 ; % Rectangles are above or below of each other
      Y2 + H2 =< Y1 }.

% arrange(+BoxName, -B1, -B2, -B3, -B4)
% Fit 4 blocks into a Box. B1, B2, B3 and B4 are rectangles that fit into a box.
%
% ?- arrange(box1, B1,B2,B3,B4).
% B1 = rect(pos(0.0, 0.0), d(5.0, 3.0)),
% B2 = rect(pos(0.0, 3.0), d(6.0, 2.0)),
% B3 = rect(pos(5.0, _A), d(1.0, 2.4)),
% B4 = rect(pos(0.0, 5.0), d(5.0, 1.0)),
% {_A>=0.0, _= -0.5999999999999996+_A, _A=<0.5999999999999996} ...
%
% Иlock И1 is arranged so that its bottom-left corner is at (0,0),
% and lies so that its width is 5 and its height is 3.
% At the last line do not mind _ = -0.59999... stuff. Look only at _A variable:
% _A >= 0, _A < 0.6.

arrange(BoxName, B1, B2, B3, B4) :-
    box(BoxName, BoxDim),
    Box = rect(pos(0.0, 0.0), BoxDim),
    place_block(b1, B1), B1 inside Box,
    place_block(b2, B2), B2 inside Box,
    place_block(b3, B3), B3 inside Box,
    place_block(b4, B4), B4 inside Box,
    B1 no_overlap B2,
    B1 no_overlap B3,
    B1 no_overlap B4,
    B2 no_overlap B3,
    B2 no_overlap B4,
    B3 no_overlap B4.
