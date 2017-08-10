module Post.Msg exposing (..)

import Post.Model exposing (PostId, PostMeta)
import Http


type Msg
    = PostFetch (Result Http.Error String)
    | LoadPost PostId PostMeta
    | PostLoaded
    | GoBack
    | SetPostMeta PostMeta
    | PostMetaFetch (Result Http.Error (List PostMeta))
    | ShowComments
