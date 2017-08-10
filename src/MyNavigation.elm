module MyNavigation exposing (fromUrl, pageParser, toUrl)

import Regex
import States exposing (State)
import String
import UrlParser exposing ((</>), Parser, map, oneOf, s, string)


fromUrl : String -> String
fromUrl hash =
    let
        withoutPrefix =
            String.dropLeft 2 hash
    in
        if String.contains "#" withoutPrefix then
            Regex.replace Regex.All (Regex.regex "#.*$") (\_ -> "") withoutPrefix
        else
            withoutPrefix


pageParser : Parser (State -> a) a
pageParser =
    oneOf
        [ map States.Home (s "")
        , map States.Blog (s "blog" </> string)
        ]


toUrl : State -> String
toUrl state =
    case state of
        States.Home ->
            "#"

        States.Blog q ->
            "#blog/" ++ q
