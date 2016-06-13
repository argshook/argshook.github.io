module Pages.Minesweeper exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


type alias Model = Int


initialModel : Model
initialModel = 0


type Msg
  = NoOp


view : Model -> Html Msg
view model =
  text "hai"


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)

