port module Main exposing (..)

import Messages
import Model
import Navigation
import Update exposing (update)
import View exposing (view)
import Pages.Blog.PostsListModel as PostsListModel
import Pages.PagesMessages as PagesMessages


init : Navigation.Location -> ( Model.Model, Cmd Messages.Msg )
init location =
    update (Messages.UrlChange location) Model.initialModel


main : Program Never Model.Model Messages.Msg
main =
    Navigation.program Messages.UrlChange
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
