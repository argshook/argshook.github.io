module MyNavigation exposing (..)

import Regex
import States exposing (..)
import String
import UrlParser exposing ((</>), Parser, int, map, oneOf, s, string)


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
        [ map Home (s "")
        , map Binary (s "binary")
        , map Minesweeper (s "minesweeper")
        , map Category (s "category")
        , map FizzBuzz (s "fizz-buzz")
        , map Blog (s "blog" </> string)
        ]


toUrl : State -> String
toUrl state =
    case state of
        Home ->
            "#"

        Binary ->
            "#binary"

        Minesweeper ->
            "#minesweeper"

        Category ->
            "#category"

        FizzBuzz ->
            "#fizz-buzz"

        Blog q ->
            "#blog/" ++ q
