module Pages.Blog.PostMsg exposing (..)

import Pages.Blog.PostModel exposing (..)

import Http


type Msg
  = FetchSuccess String
  | FetchFail Http.Error
  | LoadPost PostId
  | Highlight
  | GoBack
  | SetPostMeta Post

