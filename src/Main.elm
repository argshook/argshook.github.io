module Main exposing (..)

import Messages
import Model exposing (Flags, Model)
import Navigation
import Update exposing (update)
import View exposing (view)
import Pages.Blog.PostsListModel as PostsListModel
import Pages.PagesMessages as PagesMessages


init : Flags -> Navigation.Location -> ( Model.Model, Cmd Messages.Msg )
init flags location =
    update (Messages.Initialize location flags) Model.initialModel


main : Program Flags Model Messages.Msg
main =
    Navigation.programWithFlags Messages.UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model.Model -> Sub Messages.Msg
subscriptions model =
    Sub.map Messages.PagesMessages <|
        Sub.map PagesMessages.PostsListMsg <|
            PostsListModel.subscriptions
                model.pagesModel.postsListModel
