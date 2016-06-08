module Main exposing (..)

import Navigation

import View exposing (view)
import Messages exposing (Msg)
import Update exposing (update)
import MyNavigation


main =
  Navigation.program MyNavigation.urlParser
    { init = MyNavigation.init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    , urlUpdate = MyNavigation.urlUpdate
    }

