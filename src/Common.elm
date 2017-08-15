module Common exposing (..)


(=>) : String -> String -> ( String, String )
(=>) k v =
    ( k, v )
infixr 9 =>


type alias CSS =
    List ( String, String )


type ClassNameEntry
    = ClassName String
    | ClassNameWithCondition String Bool


classNames : List ClassNameEntry -> String
classNames =
    List.foldl
        (\classNameEntry className ->
            case classNameEntry of
                ClassName name ->
                    className ++ " " ++ name

                ClassNameWithCondition name condition ->
                    if condition then
                        className ++ " " ++ name
                    else
                        className
        )
        ""
