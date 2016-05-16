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
      filters : List (String, (Int -> Bool))
      filters =
        [ ("is divisible by 3", (\num -> num % 3 == 0 ))
        , ("is one", (\num -> num == 1 ))
        , ("is even", (\num -> num % 2 == 0 ))
        , ("is greater than 10 but less than 15", (\num -> num > 10 && num < 15 ))
        , ("is divisible by 5", (\num -> num % 5 == 0 ))
        , ("is divisible by 7", (\num -> num % 7 == 0 ))
        ]


      applyFilter : Int -> (String, (Int -> Bool)) -> Maybe String
      applyFilter num (filter, fn) =
        if fn num then
          Just filter
        else
          Nothing


      counter : Int -> String
      counter num =
        let
            item =
              List.foldr (\c a -> c ++ " " ++ a) "" (List.filterMap (applyFilter num) filters)
        in
            if String.length item /= 0
            then toString num ++ " " ++ item
            else toString num

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
