module Main exposing (..)

import Navigation

import View exposing (view)
import Messages exposing (Msg)
import Update exposing (update)
import MyNavigation exposing (init)


main =
  Navigation.program MyNavigation.urlParser
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    , urlUpdate = MyNavigation.urlUpdate
    }

