module Pages.Blog.PostsList exposing (..)

import Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Http
import String

import Pages.PagesMessages as PagesMessages
import Pages.Blog.PostsListMsg exposing (..)
import Pages.Blog.PostsListModel exposing (..)
import Pages.Blog.PostModel exposing (PostMeta, initialPostMeta)
import Pages.Blog.PostMsg as PostMsg
import Pages.Blog.Post as Post exposing (postMeta)


update : Msg -> Model -> (Model, Cmd Msg, Cmd PagesMessages.Msg)
update msg model =
  case msg of
    Filter newFilter ->
      ({ model | filter = newFilter }, Cmd.none, Cmd.none)

    OpenPost post ->
      ( model
      , Navigation.newUrl ("#blog/" ++ post.slug) -- TOOD: dont directly change url here
      , Task.perform PagesMessages.PostMsg
          (Task.succeed (PostMsg.SetPostMeta post))
      )

    InitializeLoadPosts ->
      ( model
      , loadPosts
      , Cmd.none
      )

    LoadPosts result ->
      case result of
        Ok posts ->
          ( { model | posts = posts }
          , Cmd.none
          , Cmd.none
          )
        Err error ->
          let
              _ = Debug.log "failed to fetch all posts" error
          in
              (model, Cmd.none, Cmd.none)


loadPosts : Cmd Msg
loadPosts =
  Http.send LoadPosts
    (Http.get "db.json" postsResponseDecoder)

filteredPosts : Model-> List (Html Msg)
filteredPosts model =
  let
      preparePostCard post =
        if String.length model.filter == 0 then
          postCard True post
        else
          if (String.contains (String.toLower model.filter) (String.toLower post.title))
          then
            postCard True post
          else
            postCard False post

  in
      List.map (\p -> preparePostCard p ) model.posts


view : Model -> Html Msg
view model =
    div
      [ class "blog" ]
      [ div
        [ class "blog-posts-filter" ]
        [ text "List.filter (\\p -> String.contains \""
        , input
            [ onInput Filter
            , value model.filter
            , style [
              ( "width"
              , (toString ((String.length model.filter) * 10 + 40)) ++ "px"
              )
              ]
            ]
            []
        , text "\" p.title) posts"
        ]
      , div [ class "blog-posts-list" ] (List.reverse <| filteredPosts model)
      ]

classnames : List ( (String, Bool) ) -> String
classnames names =
  names
    |> List.filter (\(name, shouldAdd) -> shouldAdd)
    |> List.foldl (\(name, _) names -> names ++ " " ++ name) ""

postCard : Bool -> PostMeta -> Html Msg
postCard isVisible post =
  button
    [ class <| classnames [ ("card", True), ("card--hidden", not isVisible) ]
    , onClick (OpenPost post)
    ]
    [ div [ class "card__title" ] [ text post.title ]
    , postMeta post "card-meta"
    ]

