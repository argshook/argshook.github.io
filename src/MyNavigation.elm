module MyNavigation exposing (..)

import String
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)
import Navigation
import Models exposing (..)
import Messages exposing (..)


init : Result String State -> ( Model, Cmd Msg )
init result =
  urlUpdate result initialModel


urlParser : Navigation.Parser (Result String State)
urlParser =
  Navigation.makeParser (fromUrl << .hash)


fromUrl : String -> Result String State
fromUrl hash =
  UrlParser.parse identity pageParser (String.dropLeft 1 hash)


pageParser : Parser (State -> a) a
pageParser =
  oneOf
  [ format Home (UrlParser.s "")
  , format Binary (UrlParser.s "binary")
  , format Forms (UrlParser.s "forms")
  , format Category (UrlParser.s "category")
  , format FizzBuzz (UrlParser.s "fizz-buzz")
  ]


toUrl : State -> String
toUrl state =
  case state of
    Home -> "#"
    Binary -> "#binary"
    Forms -> "#forms"
    Category -> "#category"
    FizzBuzz -> "#fizz-buzz"


urlUpdate : Result String State -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case result of
    Ok newState ->
      case newState of
        _ ->
          let
              model' =
                { model | state = newState }
          in
              (model', Cmd.none)

    Err _ ->
      (model, Navigation.modifyUrl (toUrl model.state))


