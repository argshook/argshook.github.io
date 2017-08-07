module Update exposing (..)

import Messages
import Model exposing (Model)
import MyNavigation exposing (toUrl)
import Navigation
import Pages.Blog.PostMsg
import Pages.Blog.PostModel
import Pages.Blog.PostsListMsg
import Pages.PagesMessages
import Pages.PagesUpdate
import States
import UrlParser
import Tuple


update : Messages.Msg -> Model -> ( Model, Cmd Messages.Msg )
update msg model =
    case msg of
        Messages.PagesMessages pagesMsg ->
            let
                ( model_, cmd ) =
                    Pages.PagesUpdate.update pagesMsg model.pagesModel
            in
                ( { model | pagesModel = model_ }, Cmd.map Messages.PagesMessages cmd )

        Messages.ChangeState newState ->
            { model | state = newState } ! [ Navigation.newUrl (toUrl newState) ]

        Messages.UrlChange location ->
            let
                newState =
                    UrlParser.parseHash MyNavigation.pageParser location
                        |> Maybe.withDefault States.Home

                openPostMsg : String -> List Pages.Blog.PostModel.PostMeta -> Pages.PagesMessages.Msg
                openPostMsg slug postsList =
                    let
                        postMeta =
                            List.filter (\meta -> meta.slug == slug) postsList
                                |> List.head
                                |> Maybe.withDefault Pages.Blog.PostModel.initialPostMeta
                    in
                        Pages.PagesMessages.PostMsg (Pages.Blog.PostMsg.LoadPost slug postMeta)

                ( pagesModel, pagesCmd ) =
                    case newState of
                        States.Blog slug ->
                            Pages.PagesUpdate.update (openPostMsg slug model.pagesModel.postsListModel.posts) model.pagesModel

                        _ ->
                            ( model.pagesModel, Cmd.none )
            in
                { model
                    | history = location :: model.history
                    , pagesModel = pagesModel
                    , state = newState
                }
                    ! [ Cmd.map Messages.PagesMessages pagesCmd ]

        Messages.Initialize location flags ->
            { model
                | pagesModel =
                    Pages.PagesUpdate.update
                        (Pages.PagesMessages.PostsListMsg (Pages.Blog.PostsListMsg.LoadPosts flags.posts))
                        model.pagesModel
                        |> Tuple.first
            }
                |> update (Messages.UrlChange location)
