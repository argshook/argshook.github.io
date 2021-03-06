module Msg exposing (Msg(PagesMsg, ChangeState, UrlChange, Initialize))

import Navigation
import Model exposing (Flags)
import Pages.Msg
import States exposing (State)


type Msg
    = PagesMsg Pages.Msg.Msg
    | ChangeState State
    | UrlChange Navigation.Location
    | Initialize Navigation.Location Flags
