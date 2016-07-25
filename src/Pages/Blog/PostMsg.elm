module Pages.Blog.PostMsg exposing (..)

import Pages.Blog.PostModel exposing (..)

import Http


type Msg
  = PostFetchSuccess String
  | PostFetchFail Http.Error
  | LoadPost PostId
  | Highlight
  | GoBack
  | SetPostMeta PostMeta
  | PostMetaFetchSuccess (List PostMeta)
  | PostMetaFetchFail Http.Error

