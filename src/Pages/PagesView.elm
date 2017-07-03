module Pages.PagesView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Blog.Post as Post
import Pages.Blog.PostsList as PostsList
import Pages.PagesMessages as PagesMessages exposing (..)
import Pages.PagesModel as PagesModel exposing (..)
import States exposing (..)


view : Model -> State -> Html Msg
view model state =
    let
        component =
            case state of
                Home ->
                    Html.map PostsListMsg (PostsList.view model.postsListModel)

                Blog _ ->
                    Html.map PostMsg (Post.view model.postModel)
    in
    div
        [ class "page-content" ]
        [ component ]
