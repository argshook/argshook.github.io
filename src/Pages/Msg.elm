module Pages.Msg exposing (Msg(PostsListMsg, PostMsg))

import Post.Msg as PostMsg
import PostsList.Msg as PostsListMsg


type Msg
    = PostsListMsg PostsListMsg.Msg
    | PostMsg PostMsg.Msg
