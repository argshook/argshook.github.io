module Pages.Blog.PostsListMsg exposing (..)


import Http

import Pages.Blog.PostModel exposing (..)


type Msg
  = Filter String
  | OpenPost PostMeta
  | LoadPosts
  | LoadPostsSuccess (List PostMeta)
  | LoadPostFail Http.Error

