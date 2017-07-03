module Pages.HttpEffect exposing (..)

import Html
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Task
import Http
import Json.Decode as Json


type alias Model =
  { topic : String
  , gifUrl : String
  , errorMessage : String
  }


initialModel : (Model, Cmd Msg)
initialModel =
  (Model "Tits" "waiting.gif" "", Cmd.none)


type Msg
  = MorePlease
  | FetchSuccess String
  | FetchFail Http.Error
  | Topic String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSuccess newUrl ->
      (Model model.topic newUrl "", Cmd.none)

    FetchFail error ->
      let
          errorMessage =
            case error of
              Http.UnexpectedPayload message -> message
              Http.BadResponse code message -> message
              Http.NetworkError -> "Network Error"
              _ -> ""
      in
        ({ model | errorMessage = errorMessage }, Cmd.none)

    Topic topic ->
      ({ model | topic = topic }, Cmd.none)


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
      url =
        "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
      Task.perform FetchFail FetchSuccess (Http.get decodeGifUrl url)


decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["main"] Json.string


view : Model -> Html Msg
view model =
  div
    []
    [ h2 [] [ text model.topic ]
    , img [ src model.gifUrl ] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , text
        ( if model.errorMessage /= "" then model.errorMessage else "" )
    , input [ onInput Topic, value model.topic ] []
    , select
        [ onInput Topic ]
        [ option [ value "fun" ] [ text "fun" ]
        , option [ value "wtf" ] [ text "wtf" ]
        ]
    ]


main =
  Html.program
    { init = initialModel
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

