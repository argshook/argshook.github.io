module Main exposing (main)

import Msg exposing (Msg)
import Model exposing (Flags, Model)
import Navigation
import Update exposing (update)
import View exposing (view)
import Pages.Blog.PostsListModel as PostsListModel
import Pages.Msg as PagesMsg


init : Flags -> Navigation.Location -> ( Model.Model, Cmd Msg )
init flags location =
    update (Msg.Initialize location flags) Model.initialModel


main : Program Flags Model Msg
main =
    Navigation.programWithFlags Msg.UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model.Model -> Sub Msg
subscriptions model =
    Sub.map Msg.PagesMsg <|
        Sub.map PagesMsg.PostsListMsg <|
            PostsListModel.subscriptions
                model.pagesModel.postsListModel
