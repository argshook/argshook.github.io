module PostsList.Msg exposing (Msg(Filter, OpenPost, LoadPosts))

import Post.Model exposing (PostMeta)


type Msg
    = Filter String
    | OpenPost PostMeta
    | LoadPosts (List PostMeta)
