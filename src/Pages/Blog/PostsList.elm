module Pages.Blog.PostsList exposing (..)

import Navigation
import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing ((=>), colors)

import String


type alias Model =
  { filter : String }


initialModel : Model
initialModel =
  { filter = "" }


posts : List String
posts =
  [ "hello-world", "hello-world2", "hello-world3" ]


type Msg
  = Filter String
  | OpenPost String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Filter newFilter ->
      ({ model | filter = newFilter }, Cmd.none)

    OpenPost post ->
      (model, Navigation.newUrl ("#blog/" ++ post))


filteredPosts : String -> List (Html Msg)
filteredPosts filter =
  List.map (\p -> postCard p )
    <| if String.length filter /= 0 then
         (List.filter (\p -> String.contains (String.toLower filter) (String.toLower p)) posts)
       else
         posts


view : Model -> Html Msg
view model =
  div
    [] <|
    [ input
      [ onInput Filter
      , placeholder "Filter posts"
      , value model.filter
      , style [ "margin-bottom" => "30px" ]
      ]
      []
    ] ++ (filteredPosts model.filter)


postCard : String -> Html Msg
postCard post =
  a
    [ style [ "background" => colors.light, "margin" => "0 0 10px", "display" => "block" ]
    , onClick (OpenPost post)
    ]
    [ text post ]

