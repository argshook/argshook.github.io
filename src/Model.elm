module Model exposing (Flags, Model, initialModel)

import Navigation exposing (Location)
import Pages.Model as PagesModel
import States exposing (State)
import Pages.Blog.PostModel exposing (PostMeta)


type alias Flags =
    List PostMeta


type alias Model =
    { pagesModel : PagesModel.Model
    , history : List Location
    , state : State
    }


initialModel : Model
initialModel =
    { pagesModel = PagesModel.initialModel
    , history = []
    , state = States.Home
    }
