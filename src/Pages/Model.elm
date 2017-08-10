module Pages.Model exposing (Model, initialModel)

import Post.Model as PostModel
import PostsList.Model as PostsListModel


type alias Model =
    { postsListModel : PostsListModel.Model
    , postModel : PostModel.Model
    }


initialModel : Model
initialModel =
    { postsListModel = PostsListModel.initialModel
    , postModel = PostModel.initialModel
    }
