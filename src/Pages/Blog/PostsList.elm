module Pages.Blog.PostsList exposing (..)

import Navigation
import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String

import Common exposing ((=>), colors)
import Pages.Blog.Post as Post exposing (..)

type alias Model =
  { filter : String
  , postModel : Post.Model
  }


initialModel : Model
initialModel =
  { filter = ""
  , postModel = Post.initialModel
  }


posts : List String
posts =
  [ "hello-world", "hello-world2", "hello-world3" ]


type Msg
  = Filter String
  | PostMsg Post.Msg
  | OpenPost String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Filter newFilter ->
      ({ model | filter = newFilter }, Cmd.none)

    OpenPost postId ->
      let
          (postModel, postCmd) =
            Post.update (Post.LoadPost postId) model.postModel

          navCmd =
            Navigation.newUrl ("#blog/" ++ postId)

          cmd =
            Cmd.batch [ postCmd, navCmd ]
      in
          ({ model | postModel = postModel }, Cmd.map PostMsg cmd)

    PostMsg msg ->
      let
          (postModel, postCmd) = Post.update msg model.postModel
      in
          ({ model | postModel = postModel }, Cmd.none)


filteredPosts : String -> List (Html Msg)
filteredPosts filter =
  List.map (\p -> postCard p )
    <| if String.length filter /= 0 then
         (List.filter (\p -> String.contains (String.toLower filter) (String.toLower p)) posts)
       else
         posts


view : Model -> Html Msg
view model =
  let
      postView =
        Post.view model.postModel
  in
      div
        [] <|
        [ input
          [ onInput Filter
          , placeholder "Filter posts"
          , value model.filter
          , style [ "margin-bottom" => "30px" ]
          ]
          []
        ] ++ ((filteredPosts model.filter) ++ [ Html.App.map PostMsg postView ])


postCard : String -> Html Msg
postCard post =
  a
    [ style [ "background" => colors.light, "margin" => "0 0 10px", "display" => "block" ]
    , onClick (OpenPost post)
    ]
    [ text post ]

