module Messages exposing (..)

import Navigation
import Model exposing (Flags)
import Pages.PagesMessages exposing (..)
import States exposing (..)


type Msg
    = PagesMessages Pages.PagesMessages.Msg
    | ChangeState State
    | UrlChange Navigation.Location
    | Initialize Navigation.Location Flags
