module Messages exposing (..)

import Navigation
import Pages.PagesMessages exposing (..)
import States exposing (..)


type Msg
    = PagesMessages Pages.PagesMessages.Msg
    | ChangeState State
    | UrlChange Navigation.Location
