module Main exposing (..)

import Navigation

import View exposing (view)
import Update exposing (update)
import MyNavigation exposing (init)
import Messages

main =
  Navigation.program Messages.UrlChange
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

