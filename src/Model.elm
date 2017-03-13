module Model exposing (..)

import Pages.PagesModel as PagesModel
import Navigation exposing (Location)
import States exposing (..)


type alias Model =
  { pagesModel : PagesModel.Model
  , history : List Location
  , state : State
  }


initialModel : Model
initialModel =
  { pagesModel = PagesModel.initialModel
  , history = []
  , state = Home
  }

