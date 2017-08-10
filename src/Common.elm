module Common exposing ((=>), colors, CSS)


(=>) : String -> String -> ( String, String )
(=>) k v =
    ( k, v )
infixr 9 =>


type alias CSS =
    List ( String, String )
