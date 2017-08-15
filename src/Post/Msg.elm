module Post.Msg exposing (Msg(PostFetch, LoadPost, PostLoaded, GoBack, SetPostMeta, PostMetaFetch, ShowComments))

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
