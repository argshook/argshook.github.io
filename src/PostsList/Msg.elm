module PostsList.Msg exposing (..)

import Post.Model exposing (PostMeta)


type Msg
    = Filter String
    | OpenPost PostMeta
    | LoadPosts (List PostMeta)
