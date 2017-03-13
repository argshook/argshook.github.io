module Pages.Blog.PostMsg exposing (..)

import Pages.Blog.PostModel exposing (..)

import Http


type Msg
  = PostFetch (Result Http.Error String)
  | LoadPost PostId
  | PostLoaded
  | GoBack
  | SetPostMeta PostMeta
  | PostMetaFetch (Result Http.Error (List PostMeta))
  | ShowComments

