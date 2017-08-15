module MyNavigation exposing (pageParser, toUrl, fromUrl)

import Navigation
import States exposing (State)
import UrlParser exposing ((</>), Parser, map, oneOf, s, string)


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


fromUrl : Navigation.Location -> State
fromUrl location =
    Maybe.withDefault States.Home <|
        UrlParser.parseHash pageParser location
