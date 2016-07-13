module Pages.Blog.PostsList exposing (..)

import Navigation
import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String

import Pages.Blog.Post as Post
import Common exposing ((=>), colors)


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

    OpenPost postId ->
      (model, Navigation.newUrl ("#blog/" ++ postId))


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
      [ class "flex" ]
      [ div [ class "col-8" ] (filteredPosts model.filter)
      , div
        [ class "col-4 px2" ]
        [ input
            [ onInput Filter
            , placeholder "Filter posts"
            , value model.filter
            , class "my2 input"
            ]
            []
        ]
      ]


postCard : String -> Html Msg
postCard post =
  a
    [ class "my2 p2 bg-teal border rounder block"
    , onClick (OpenPost post)
    ]
    [ text post ]

