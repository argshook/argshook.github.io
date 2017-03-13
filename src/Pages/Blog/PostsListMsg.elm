module Pages.Blog.PostsListMsg exposing (..)


import Http

import Pages.Blog.PostModel exposing (..)


type Msg
  = Filter String
  | OpenPost PostMeta
  | InitializeLoadPosts
  | LoadPosts (Result Http.Error (List PostMeta))

