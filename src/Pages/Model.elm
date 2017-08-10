module Pages.Model exposing (Model, initialModel)

import Pages.Blog.PostModel as PostModel
import Pages.Blog.PostsListModel as PostsListModel


type alias Model =
    { postsListModel : PostsListModel.Model
    , postModel : PostModel.Model
    }


initialModel : Model
initialModel =
    { postsListModel = PostsListModel.initialModel
    , postModel = PostModel.initialModel
    }
