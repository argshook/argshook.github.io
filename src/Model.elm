module Model exposing (..)

import Navigation exposing (Location)
import Pages.PagesModel as PagesModel
import States exposing (..)
import Pages.Blog.PostModel exposing (PostMeta)


type alias Flags =
    { posts : List PostMeta }


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
