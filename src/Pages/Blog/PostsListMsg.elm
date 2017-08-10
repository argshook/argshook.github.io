module Pages.Blog.PostsListMsg exposing (..)

import Pages.Blog.PostModel exposing (PostMeta)


type Msg
    = Filter String
    | OpenPost PostMeta
    | LoadPosts (List PostMeta)
