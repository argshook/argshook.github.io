module Pages.PagesView exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Pages.Blog.Post as Post
import Pages.Blog.PostsList as PostsList
import Pages.PagesMessages as PagesMessages
import Pages.PagesModel exposing (Model)
import States exposing (State)


view : Model -> State -> Html PagesMessages.Msg
view model state =
    let
        component =
            case state of
                States.Home ->
                    Html.map PagesMessages.PostsListMsg (PostsList.view model.postsListModel)

                States.Blog _ ->
                    Html.map PagesMessages.PostMsg (Post.view model.postModel)
    in
        div
            [ class "page-content" ]
            [ component ]
