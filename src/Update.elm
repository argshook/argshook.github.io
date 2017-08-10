module Update exposing (update)

import Msg exposing (Msg)
import Model exposing (Model)
import MyNavigation exposing (toUrl)
import Navigation
import Post.Msg
import Post.Model
import PostsList.Msg
import Pages.Msg
import Pages.Update
import States
import UrlParser
import Tuple


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.PagesMsg pagesMsg ->
            let
                ( model_, cmd ) =
                    Pages.Update.update pagesMsg model.pagesModel
            in
                ( { model | pagesModel = model_ }, Cmd.map Msg.PagesMsg cmd )

        Msg.ChangeState newState ->
            { model | state = newState } ! [ Navigation.newUrl (toUrl newState) ]

        Msg.UrlChange location ->
            let
                newState =
                    UrlParser.parseHash MyNavigation.pageParser location
                        |> Maybe.withDefault States.Home

                openPostMsg : String -> List Post.Model.PostMeta -> Pages.Msg.Msg
                openPostMsg slug postsList =
                    let
                        postMeta =
                            List.filter (\meta -> meta.slug == slug) postsList
                                |> List.head
                                |> Maybe.withDefault Post.Model.initialPostMeta
                    in
                        Pages.Msg.PostMsg (Post.Msg.LoadPost slug postMeta)

                ( pagesModel, pagesCmd ) =
                    case newState of
                        States.Blog slug ->
                            Pages.Update.update (openPostMsg slug model.pagesModel.postsListModel.posts) model.pagesModel

                        _ ->
                            ( model.pagesModel, Cmd.none )
            in
                { model
                    | history = location :: model.history
                    , pagesModel = pagesModel
                    , state = newState
                }
                    ! [ Cmd.map Msg.PagesMsg pagesCmd ]

        Msg.Initialize location posts ->
            { model
                | pagesModel =
                    Pages.Update.update
                        (Pages.Msg.PostsListMsg (PostsList.Msg.LoadPosts posts))
                        model.pagesModel
                        |> Tuple.first
            }
                |> update (Msg.UrlChange location)
