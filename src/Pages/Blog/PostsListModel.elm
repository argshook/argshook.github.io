module Pages.Blog.PostsListModel exposing (..)

import Json.Decode as Json exposing ((:=))

import Pages.Blog.PostModel exposing (..)


type alias Model =
  { filter : String
  , posts : List PostMeta
  }


initialModel : Model
initialModel =
  { filter = ""
  , posts = []
  }


postsResponseDecoder : Json.Decoder (List PostMeta)
postsResponseDecoder =
  Json.at ["posts"]
    <| Json.list
    <| Json.object7 PostMeta
      ("title" := Json.string)
      ("author" := Json.string)
      ("id" := Json.string)
      ("slug" := Json.string)
      ("path" := Json.string)
      (Json.maybe ("dateCreated" := Json.int))
      (Json.maybe ("dateModified" := Json.int))

