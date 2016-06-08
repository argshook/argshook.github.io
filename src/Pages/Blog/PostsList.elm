module Pages.Blog.PostsList exposing (..)

import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String


type alias Model =
  { input : String }


initialModel : Model
initialModel =
  { input = "" }


posts : List String
posts =
  [ "First", "Second", "Third" ]


type Msg
  = Input String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newinput ->
        ({ model | input = newinput }, Cmd.none)



view : Model -> Html Msg
view model =
  div
    []
    <| [ input
      [ onInput Input
      , value model.input
      ]
      []
    , div [] [ text (model.input) ]
    ] ++ (List.map (\p -> div [] [ text p ] ) <| if String.length model.input /= 0 then (List.filter (\p ->
      String.contains (String.toLower model.input) (String.toLower p)) posts) else posts)

