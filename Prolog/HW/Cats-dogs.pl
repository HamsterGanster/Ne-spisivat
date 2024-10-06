/*
 * Logical puzzle.
 *
 * Butsie is a brown cat, Cornie is a black cat, Mac is a red cat.
 *
 * Flash, Rover and Spot are dogs.
 * Flash is a spotted dog, Rover is a red dog and Spot is a white dog.
 * Fluffy is a black dog.
 *
 * Tom owns any pet that is either brown or black.
 * Kate owns all nonwhite dogs, not belonging to Tom.
 *
 * All pets Kate or Tom owns are pedigree animals.
 *
 * Alan owns Mac if
 *  1) Kate does not own Butsie
 *  2) Spot is not a pedigree animal.
 *
 * Write a Prolog program that answers, which animals do not have an owner.
*/


% YOUR CODE HERE

cat("Butsie"). 
cat("Cornie"). 
cat("Mac").

dog("Flash").  
dog("Rover").  
dog("Spot").
dog("Fluffy"). 

color("Butsie", "brown").
color("Cornie", "black").
color("Mac", "red").

color("Flash", "spotted").
color("Rover", "red").
color("Spot", "white").
color("Fluffy", "black").


% BY THE WAY, Tom have to own ONE pet, but he has THREE — Cornie, Fluffy, Butsie.
own("Tom", P)  :- color(P, "black"); color(P, "brown").
own("Kate", P) :- dog(P), not(color(P, "white")), not(own("Tom", P)).

pedigree(P)    :- own("Kate", P); own("Tom", P).

own("Alan", "Mac") :- not(own("Kate", "Butsie")), not(pedigree("Spot")).

answer(Pet) :- (dog(Pet);cat(Pet)), not(own(A, Pet)).