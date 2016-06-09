module Model exposing (..)

import Pages.PagesModel as PagesModel
import States exposing (..)


type alias Model =
  { pagesModel : PagesModel.Model
  , state : State
  }


initialModel : Model
initialModel =
  { pagesModel = PagesModel.initialModel
  , state = Home
  }

