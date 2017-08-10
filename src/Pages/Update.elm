module Pages.Update exposing (update)

import Pages.Blog.Post as Post
import Pages.Blog.PostsList as PostsList
import Pages.Msg as Msg exposing (Msg)
import Pages.Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.PostsListMsg listMsg ->
            let
                ( postsListModel, postsListCmd, mainCmd ) =
                    PostsList.update listMsg model.postsListModel
            in
                { model | postsListModel = postsListModel }
                    ! [ Cmd.map Msg.PostsListMsg postsListCmd
                      , mainCmd
                      ]

        Msg.PostMsg postMsg ->
            let
                ( postModel, postCmd ) =
                    Post.update postMsg model.postModel
            in
                ( { model | postModel = postModel }, Cmd.map Msg.PostMsg postCmd )
