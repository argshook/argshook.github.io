module Pages.Blog.PostModel exposing (..)

type alias PostId = String

type alias Model =
  { postId : PostId
  , postContent : String
  , postMeta : Post
  , isPostLoading : Bool
  }


initialModel : Model
initialModel =
  { postId = ""
  , postContent = ""
  , postMeta = initialPostMeta
  , isPostLoading = True
  }


type alias Post =
  { title : String
  , author : String
  , id : String
  , slug : String
  , path : String
  , dateCreated : Maybe Int
  , dateModified : Maybe Int
  }

initialPostMeta : Post
initialPostMeta =
  { title = ""
  , author = ""
  , id = ""
  , slug = ""
  , path = ""
  , dateCreated = Just 0
  , dateModified = Just 0
  }

