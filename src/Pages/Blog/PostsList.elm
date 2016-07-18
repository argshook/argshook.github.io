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
      [ class "blog" ]
      [ div
        [ class "blog-posts-filter" ]
        [ text "Filter posts "
        , input
            [ onInput Filter
            , placeholder "Filter posts"
            , value model.filter
            , class "input"
            ]
            []
        ]
      , div [ class "blog-posts-list" ] (filteredPosts model.filter)
      ]


postCard : String -> Html Msg
postCard post =
  a
    [ class "blog-post-card"
    , onClick (OpenPost post)
    , href ("#blog/" ++ post)
    ]
    [ text post ]

