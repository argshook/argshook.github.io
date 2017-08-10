port module Pages.Blog.PostsListModel exposing (Model, initialModel, subscriptions)

import Pages.Blog.PostModel exposing (PostMeta)
import Pages.Blog.PostsListMsg as PostsListMsg


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
