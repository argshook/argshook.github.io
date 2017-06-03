module Model exposing (..)

import Navigation exposing (Location)
import Pages.PagesModel as PagesModel
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
