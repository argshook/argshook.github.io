port module Pages.Blog.Post exposing (..)


import Navigation
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Task
import Http
import Date
import String
import Markdown

import Pages.Blog.PostModel exposing (..)
import Pages.Blog.PostMsg exposing (..)
import Pages.Blog.PostsListModel exposing (postsResponseDecoder)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadPost postId ->
      { initialModel
      | postId = postId
      } !
      [ getPost postId
      , getPostMeta
      ]

    PostLoaded ->
      model
      !
      [ highlight "" ]

    ShowComments ->
      { model | isCommentsShown = True }
      !
      [ blogPostCommentsEnabled model.postMeta.id ]

    PostFetchSuccess data ->
      let
          model' =
            { model
            | postContent = data
            , isPostLoading = False
            }

      in
         update PostLoaded model'

    PostFetchFail error ->
      let
          _ = Debug.log "fetch fail" error
      in
          { model
          | postContent = "Failed to fetch :("
          , isPostLoading = False
          } ! []

    PostMetaFetchSuccess postsMeta ->
      let
          postMeta =
            List.filter (\p -> p.slug == model.postId) postsMeta
              |> List.head
              |> Maybe.withDefault initialPostMeta
      in
          { model | postMeta = postMeta } ! []

    PostMetaFetchFail err ->
      model ! []

    GoBack ->
      model ! [ Navigation.back 1 ]

    SetPostMeta postMeta ->
      { model | postMeta = postMeta } ! []


getPost : PostId -> Cmd Msg
getPost postId =
  let
      url =
        "Posts/" ++ postId ++ ".md"
  in
      Task.perform PostFetchFail PostFetchSuccess (Http.getString url)


getPostMeta : Cmd Msg
getPostMeta =
  Http.get postsResponseDecoder "db.json"
    |> Task.perform PostMetaFetchFail PostMetaFetchSuccess



view : Model -> Html Msg
view model =
  if model.isPostLoading then
    div [ class "blog-post blog-post--loading" ] [ text "Loading..." ]
  else
    div [ class "blog-post" ] <|
      [ a
        [ class "blog-post__back-btn btn"
        , href "#"
        ]
        [ text "Back" ]
      , postMeta model.postMeta "blog-post-meta"
      , Markdown.toHtml [ class "blog-post-content" ] model.postContent
      , hr [] []
      ] ++ [ (showCommentsBlock model.isCommentsShown) ]


showCommentsBlock : Bool -> Html Msg
showCommentsBlock isShown =
  if isShown then
    div [ id "disqus_thread" ] []
  else
    button
      [ onClick ShowComments
      , class "card card--small"
      ]
      [ text "Show Comments" ]


postMeta : PostMeta -> String -> Html msg
postMeta postMeta className =
  let
      date =
        Maybe.withDefault 0 postMeta.dateCreated
          |> toFloat
          |> Date.fromTime

      days =
        [ toString <| Date.year date
        , toString <| Date.month date
        , toString <| Date.day date
        ]
          |> String.join " "

      hours =
        [ pad <| Date.hour date
        , pad <| Date.minute date
        ]
          |> String.join ":"

      pad n =
        if n < 10 then "0" ++ (toString n) else toString n

  in
      div
        [ class className ]
        [ span [ class <| className ++ "__date" ] [ text days ]
        , span [ class <| className ++ "__time" ] [ text hours ]
        ]


port highlight : String -> Cmd msg
port blogPostCommentsEnabled : String -> Cmd msg

