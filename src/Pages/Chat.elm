module Pages.Chat exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import WebSocket


main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


type alias Model =
  { input : String
  , messages : List String
  }


init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)


type Msg
  = Input String
  | Send
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newInput ->
      (Model newInput model.messages, Cmd.none)

    Send ->
      (Model "" model.messages, WebSocket.send "ws://echo.websocket.org" model.input)

    NewMessage str ->
      (Model "" (str :: model.messages), Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://echo.websocket.org" NewMessage


view : Model -> Html Msg
view model =
  div
    []
    [ div [] (List.map viewMessage model.messages)
    , input [ onInput Input, value model.input ] []
    , button [ onClick Send ] [ text "Send" ]
    ]


viewMessage : String -> Html Msg
viewMessage msg =
  div [] [ text msg ]

