module Messages exposing (..)

import Pages.PagesMessages exposing (..)
import States exposing (..)

type Msg
  = PagesMessages Pages.PagesMessages.Msg
  | ChangeState State

