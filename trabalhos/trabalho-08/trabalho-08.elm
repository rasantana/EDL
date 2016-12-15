import Html exposing (text)

type alias Env = (String -> Int)
zero : Env
zero = \ask -> 0

type Exp = Soma Exp Exp
          | Sub Exp Exp
          | Mult Exp Exp
          | Div Exp Exp
          | Num Int
          | Var String

type Prog = Attr String Exp
          | Seq Prog Prog
          | If Exp Prog Prog
          | While Exp Prog

e1 : Exp
e1 = Soma (Num 9) (Num 1)

evalExp : Exp -> Env -> Int
evalExp exp env =
    case exp of
        Soma exp1 exp2 -> (evalExp exp1 env) + (evalExp exp2 env)
        Sub exp1 exp2  -> (evalExp exp1 env) - (evalExp exp2 env)
        Mult exp1 exp2 -> (evalExp exp1 env) * (evalExp exp2 env)
        Div exp1 exp2  -> (evalExp exp1 env) // (evalExp exp2 env)
        Num v          -> v
        Var var        -> (env var)

evalProg : Prog -> Env -> Env
evalProg s env =
    case s of
        Seq s1 s2 ->
            (evalProg s2 (evalProg s1 env))
        Attr var exp ->
            let
                val = (evalExp exp env)
            in
                \ask -> if ask==var then val else (env ask)       
        If exp s1 s2 -> if (evalExp exp env) /= 0 then
                          (evalProg s1 env)
                        else
                          (evalProg s2 env)
        While exp s1 -> if (evalExp exp env) /= 0 then
                          (evalProg (While exp s1) (evalProg s1 env))
                        else
                          env                          
                    

lang : Prog -> Int
lang p = ((evalProg p zero) "ret")

prog: Prog
prog = Seq
        (Seq
          (Seq
            (Seq
              (Attr "pot" (Num 64))
              (Attr "x" (Var "pot")))
            (Attr "i" (Num 6)))
          (While (Var "i")
            (Seq
              (Attr "x" (Div (Var "x") (Num 2)))
              (Attr "i" (Sub (Var "i") (Num 1))))))
       (Attr "ret" (Var "x"))
main = text (toString (lang prog))
