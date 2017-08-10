module Pages.Blog.PostModel exposing (PostId, Model, initialModel, PostMeta, initialPostMeta)


type alias PostId =
    String


type alias Model =
    { postId : PostId
    , postContent : String
    , postMeta : PostMeta
    , isPostLoading : Bool
    , isCommentsShown : Bool
    }


initialModel : Model
initialModel =
    { postId = ""
    , postContent = ""
    , postMeta = initialPostMeta
    , isPostLoading = True
    , isCommentsShown = False
    }


type alias PostMeta =
    { title : String
    , author : String
    , id : String
    , slug : String
    , path : String
    , dateCreated : Maybe Int
    , dateModified : Maybe Int
    }


initialPostMeta : PostMeta
initialPostMeta =
    { title = ""
    , author = ""
    , id = ""
    , slug = ""
    , path = ""
    , dateCreated = Just 0
    , dateModified = Just 0
    }
