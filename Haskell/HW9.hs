module {-смотри девятую презентацию-} where
import {-смотри девятую презентацию-}

newtype Stack = Stack [Int]
    deriving Show

emptyStack :: Stack
emptyStack = Stack []

push :: Stack -> Int -> Stack
push (Stack arr) int = Stack (int:arr)

pop :: Stack -> (Int, Stack)
pop (Stack []) = (0, Stack [])
pop (Stack (x:arr)) = (x, Stack arr)


data Instruction = {-смотри девятую презентацию-}

computeInstructions :: [Instruction] -> Int
computeInstructions [] = 0
computeInstructions arr = answer where Stack (answer:_) = foldl (\acc x -> (func acc x)) emptyStack arr
--                                                                             ↓
-- ↓←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
-- ↓
func :: Stack -> Instruction -> Stack 
func st x = case x of
        Push y -> push st y
        Add -> push list2 (b+a) 
        Sub -> push list2 (b-a)
        Div -> push list2 (b `div` a)
        Mul -> push list2 (b*a)
        Pow -> push list2 (b^a)
        _ -> st 
        where (a, list1) = pop st; (b, list2) = pop list1

-- по факту, бесполезная функция
parseString :: String -> [Instruction]
parseString string' = let string = split string' ' ' in reverse(  foldl (\acc x -> (foo x):acc) [] string  ) 
                                            where foo x | strIsNumber x = Push (strToInt x) 
                                                        | x == "+" = Add
                                                        | x == "-" = Sub
                                                        | x == "/" = Div
                                                        | x == "*" = Mul
                                                        | x == "^" = Pow

class Parsable a where
    parse :: a -> [Instruction]

instance Parsable String where
    parse :: String -> [Instruction]
    parse string' = let string = split string' ' ' in reverse(  foldl (\acc x -> (foo x):acc) [] string  ) 
                                            where foo x | strIsNumber x = Push (strToInt x) 
                                                        | x == "+" = Add
                                                        | x == "-" = Sub
                                                        | x == "/" = Div
                                                        | x == "*" = Mul
                                                        | x == "^" = Pow
instance Parsable [String] where
    parse :: [String] -> [Instruction]
    parse strings = reverse( foldl (\acc x -> (foo x):acc) [] strings ) 
                where foo x | strIsNumber x = Push (strToInt x) 
                            | x == "+" = Add
                            | x == "-" = Sub
                            | x == "/" = Div
                            | x == "*" = Mul
                            | x == "^" = Pow

instance Parsable [Instruction] where
    parse :: [Instruction] -> [Instruction]
    parse arr = arr


stackMachine :: (Parsable a) => a -> Int
stackMachine a' = let a = parse a' in computeInstructions a
