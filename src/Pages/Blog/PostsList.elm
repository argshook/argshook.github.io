module Pages.Blog.PostsList exposing (..)

import Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Http
import Json.Decode as Json exposing ((:=))
import String

import Pages.PagesMessages as PagesMessages
import Pages.Blog.PostsListMsg exposing (..)
import Pages.Blog.PostsListModel exposing (..)
import Pages.Blog.PostModel exposing (PostMeta, initialPostMeta)
import Pages.Blog.PostMsg as PostMsg
import Pages.Blog.Post as Post exposing (timestampToString)


update : Msg -> Model -> (Model, Cmd Msg, Cmd PagesMessages.Msg)
update msg model =
  case msg of
    Filter newFilter ->
      ({ model | filter = newFilter }, Cmd.none, Cmd.none)

    OpenPost post ->
      ( model
      , Navigation.newUrl ("#blog/" ++ post.slug)
      , Task.succeed (PostMsg.SetPostMeta post) |>
          Task.perform PagesMessages.PostMsg PagesMessages.PostMsg
      )

    LoadPosts ->
      ( model
      , loadPosts
      , Cmd.none
      )

    LoadPostsSuccess posts ->
      ( { model | posts = posts }
      , Cmd.none
      , Cmd.none
      )

    LoadPostFail err ->
      let
          _ = Debug.log "failed to fetch all posts" err
      in
          (model, Cmd.none, Cmd.none)


loadPosts : Cmd Msg
loadPosts =
  Task.perform LoadPostFail LoadPostsSuccess (Http.get postsResponseDecoder "db.json")

filteredPosts : Model-> List (Html Msg)
filteredPosts model =
  List.map (\p -> postCard p )
    <| if String.length model.filter /= 0 then
        List.filter
          (\p -> String.contains (String.toLower model.filter) (String.toLower p.title))
          model.posts
       else
         model.posts


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
      , div [ class "blog-posts-list" ] (filteredPosts model)
      ]


postCard : PostMeta -> Html Msg
postCard post =
  a
    [ class "blog-post-card"
    , onClick (OpenPost post)
    ]
    [ div [ class "blog-post-card__title" ] [ text post.title ]
    , div [ class "blog-post-card__date" ] [ text <| timestampToString <| Maybe.withDefault 0 post.dateCreated ]
    ]

