module Pages.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Post.Main as Post
import PostsList.Main as PostsList
import Pages.Msg as PagesMsg
import Pages.Model exposing (Model)
import States exposing (State)


view : Model -> State -> Html PagesMsg.Msg
view model state =
    let
        component =
            case state of
                States.Home ->
                    Html.map PagesMsg.PostsListMsg (PostsList.view model.postsListModel)

                States.Blog _ ->
                    Html.map PagesMsg.PostMsg (Post.view model.postModel)
    in
        div
            [ class "page-content" ]
            [ component ]
