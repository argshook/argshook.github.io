port module PostsList.Model exposing (Model, initialModel, subscriptions)

import Post.Model exposing (PostMeta)
import PostsList.Msg as PostsListMsg


type alias Model =
    { filter : String
    , posts : List PostMeta
    }


initialModel : Model
initialModel =
    { filter = ""
    , posts = []
    }


port posts : (List PostMeta -> msg) -> Sub msg


subscriptions : Model -> Sub PostsListMsg.Msg
subscriptions _ =
    posts PostsListMsg.LoadPosts
