module Pages.Dice exposing (..)


import Html.App
import Html exposing(..)
import Html.Events exposing(..)
import Html.Attributes exposing(..)
import Random

type alias Dice =
  { dieFace : Int }

type alias Model =
  { dies: List (Int, Dice) }


initialModel : (Model, Cmd Msg)
initialModel =
  (
    { dies =
      [ (0, initialDiceModel)
      , (1, initialDiceModel)
      , (2, initialDiceModel)
      ]
    }
  , Cmd.none
  )


initialDiceModel : Dice
initialDiceModel =
  { dieFace = 1 }


type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.int 1 60000))

    NewFace newFace ->
      let
          updateDieModel (id, dieModel) =
             (id, { dieModel | dieFace = newFace })

          diesModel =
            List.map updateDieModel model.dies
      in
        ({ model | dies = diesModel }, Cmd.none)


view : Model -> Html Msg
view model =
  let
      img' dieFace =
        img [ src ("http://placehold.it/150/150?text=" ++ (toString dieFace)) ] []

      dies =
        List.map (\(id, dice) -> (img' dice.dieFace)) model.dies

  in
      div
        []
        ( dies ++ [ (button [ onClick Roll ] [ text "Roll" ]) ])
main =
  Html.App.program
    { init = initialModel
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none
    }

