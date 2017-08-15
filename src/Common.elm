module Common exposing ((=>), ClassNameEntry(ClassName, ClassNameWithCondition), classNames)


(=>) : String -> String -> ( String, String )
(=>) k v =
    ( k, v )
infixr 9 =>


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
