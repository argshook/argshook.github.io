module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import MyNavigation exposing (..)
import Navigation
import Pages.Blog.PostMsg
import Pages.Blog.PostsListMsg
import Pages.PagesMessages
import Pages.PagesUpdate
import States
import UrlParser


update : Messages.Msg -> Model -> ( Model, Cmd Messages.Msg )
update msg model =
    case msg of
        PagesMessages msg ->
            let
                ( model_, cmd ) =
                    Pages.PagesUpdate.update msg model.pagesModel
            in
            ( { model | pagesModel = model_ }, Cmd.map PagesMessages cmd )

        ChangeState newState ->
            { model | state = newState } ! [ Navigation.newUrl (toUrl newState) ]

        UrlChange location ->
            let
                stateCandidate =
                    UrlParser.parseHash MyNavigation.pageParser location
                        |> Maybe.withDefault States.Home

                updatePostsListMsg =
                    Pages.PagesMessages.PostsListMsg Pages.Blog.PostsListMsg.InitializeLoadPosts

                openPostMsg slug =
                    Pages.PagesMessages.PostMsg (Pages.Blog.PostMsg.LoadPost slug)

                pagesUpdateMsg : Pages.PagesMessages.Msg
                pagesUpdateMsg =
                    case stateCandidate of
                        States.Blog slug ->
                            let
                                _ =
                                    Debug.log "slug" slug
                            in
                            openPostMsg slug

                        States.Home ->
                            updatePostsListMsg

                ( pagesModel, pagesCmd ) =
                    Pages.PagesUpdate.update pagesUpdateMsg model.pagesModel
            in
            { model
                | history = location :: model.history
                , pagesModel = pagesModel
                , state = stateCandidate
            }
                ! [ Cmd.map PagesMessages pagesCmd ]
