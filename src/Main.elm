module Main exposing (..)

import Messages
import Model
import Navigation
import Update exposing (update)
import View exposing (view)


init : Navigation.Location -> ( Model.Model, Cmd Messages.Msg )
init location =
    update (Messages.UrlChange location) Model.initialModel


main : Program Never Model.Model Messages.Msg
main =
    Navigation.program Messages.UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
