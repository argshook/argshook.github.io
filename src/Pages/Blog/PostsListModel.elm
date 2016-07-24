module Pages.Blog.PostsListModel exposing (..)


import Pages.Blog.PostModel exposing (..)


type alias Model =
  { filter : String
  , posts : List Post
  }


initialModel : Model
initialModel =
  { filter = ""
  , posts = []
  }


