module FizzBuzz exposing (..)

import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String


type alias Model =
  { count : String }


initialModel : Model
initialModel =
  { count = "15" }


type Msg
  = ChangeCount String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeCount newcount ->
      ({ model | count = newcount }, Cmd.none)


fizzBuzzList : Int -> List String
fizzBuzzList count =
  let
      counter : Int -> String
      counter num =
        case (num % 3, num % 5) of
          (0, 0) -> "FizzBuzz"
          (0, _) -> "Fizz"
          (_, 0) -> "Buzz"
          _ -> toString num

  in
      List.map counter [1..count]


view : Model -> Html Msg
view model =
  let
      count =
        case String.toInt model.count of
          Ok n -> n
          Err error -> 0

      printFizzBuzz : List String -> Html Msg
      printFizzBuzz list =
        div [] (List.map (\n -> text <| n ++ ", ") list)
  in
      div
        [ style [ ("margin", "30px auto"), ("width", "600px")] ]
        [ input
            [ onInput ChangeCount
            , value model.count
            ]
            []
          , printFizzBuzz (fizzBuzzList count)
          ]


main =
  Html.App.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
