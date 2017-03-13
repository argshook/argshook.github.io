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
      , Navigation.newUrl ("#!blog/" ++ post.slug) -- TOOD: dont directly change url here
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
            , value model.filter
            , class "input"
            ]
            []
        ]
      , div [ class "blog-posts-list" ] (List.reverse <| filteredPosts model)
      ]


postCard : PostMeta -> Html Msg
postCard post =
  button
    [ class "card"
    , onClick (OpenPost post)
    ]
    [ div [ class "card__title" ] [ text post.title ]
    , postMeta post "card-meta"
    ]

