module Pages.Msg exposing (..)

import Pages.Blog.PostMsg as PostMsg
import Pages.Blog.PostsListMsg as PostsListMsg


type Msg
    = PostsListMsg PostsListMsg.Msg
    | PostMsg PostMsg.Msg
