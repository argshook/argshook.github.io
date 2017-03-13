module Pages.Clock exposing (..)

import Html exposing (..)
import Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


type alias Model = Time

init : (Model, Cmd Msg)
init =
  (0, Cmd.none)


type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick


view : Model -> Html Msg
view model =
  let
      angle =
        turns (Time.inMinutes model)

      handX =
        toString (50 + 40 * cos angle)

      handY =
        toString (50 + 40 * sin angle)
  in
      Svg.svg
        [ viewBox "0 0 100 100" ]
        [ circle [ cx "50", cy "50", r "45" ] []
        , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#fff" ] []
        , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#fff" ] []
        ]

