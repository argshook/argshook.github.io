module Pages.Blog.PostsListMsg exposing (..)


import Http

import Pages.Blog.PostModel exposing (..)


type Msg
  = Filter String
  | OpenPost Post
  | LoadPosts
  | LoadPostsSuccess (List Post)
  | LoadPostFail Http.Error

