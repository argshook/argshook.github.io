module Pages.PagesUpdate exposing (update)

import Pages.Blog.Post as Post
import Pages.Blog.PostsList as PostsList
import Pages.PagesMessages exposing (..)
import Pages.PagesModel exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PostsListMsg listMsg ->
            let
                ( postsListModel, postsListCmd, mainCmd ) =
                    PostsList.update listMsg model.postsListModel
            in
                { model | postsListModel = postsListModel }
                    ! [ Cmd.map PostsListMsg postsListCmd
                      , mainCmd
                      ]

        PostMsg msg ->
            let
                ( postModel, postCmd ) =
                    Post.update msg model.postModel
            in
                ( { model | postModel = postModel }, Cmd.map PostMsg postCmd )
