module Common exposing (..)


(=>) : String -> String -> ( String, String )
(=>) k v =
    ( k, v )
infixr 9 =>


colors =
    { dark = "#1f4504"
    , darker = "#001d06"
    , medium = "#5a7840"
    , light = "#e9f1f4"
    , complimentary = "#c0ad76"
    }


type alias CSS =
    List ( String, String )
