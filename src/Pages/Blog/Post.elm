port module Pages.Blog.Post exposing (..)


import Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Task
import Http
import Markdown

import Pages.Blog.PostModel exposing (..)
import Pages.Blog.PostMsg exposing (..)
import Pages.Blog.PostsListModel exposing (postsResponseDecoder)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadPost postId ->
      { model
      | postId = postId
      , isPostLoading = True
      } !
      [ getPost postId
      , getPostMeta
      ]

    Highlight ->
      model ! [ highlight "" ]

    PostFetchSuccess data ->
      let
          model' =
            { model
            | postContent = data
            , isPostLoading = False
            }

      in
         update Highlight model'

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
    div [] [ text "Loading..." ]
  else
    div [ class "blog-post" ]
      [ a
        [ class "blog-post__back-btn btn"
        , href "#"
        ]
        [ text "Back" ]
      , div
          [ class "blog-post__author" ]
          [ text <| "Author: " ++ model.postMeta.author ]
      ,  Markdown.toHtml [] model.postContent
      ]


port highlight : String -> Cmd msg

