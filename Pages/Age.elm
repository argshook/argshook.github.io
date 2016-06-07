module Pages.Age exposing (Model, Msg, initialModel, view, update)

import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String


type alias Model =
  { age : String }


initialModel : Model
initialModel =
  { age = "" }


type Msg
  = Input String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newage ->
      ({ model | age = newage }, Cmd.none)


view : Model -> Html Msg
view model =
  div
    []
    [ input
        [ onInput Input
        , value model.age
        ]
        []
      , ageValidator model
      ]


ageValidator : Model -> Html Msg
ageValidator model =
  case String.toInt model.age of
    Err msg ->
      if String.length msg > 0
      then span [] [ text "Type in a number please" ]
      else span [] []

    Ok age ->
      if age <= 0
      then span [] [ text "liar!" ]
      else if age > 140
      then span [] [ text "Unlikely..." ]
      else if age < 13
      then span [] [ text "Must be at least 13" ]
      else span [] []


main =
  Html.App.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
