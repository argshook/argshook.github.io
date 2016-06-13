module Pages.Blog.Post exposing (..)


import Navigation
import Html exposing (..)
import Html.Events exposing (..)
import Task
import Http

type alias PostId = String

type alias Model =
  { postId : PostId
  , postContent : String
  }


initialModel : Model
initialModel =
  { postId = ""
  , postContent = ""
  }


type Msg
  = FetchSuccess String
  | FetchFail Http.Error
  | LoadPost PostId


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadPost postId ->
      ({ model | postId = postId }, getPost postId)

    FetchSuccess data ->
      ({ model | postContent = data }, Cmd.none)

    FetchFail error ->
      let
          _ = Debug.log "fetch fail" error
      in
          ({ model | postContent = "Failed to fetch :(" }, Cmd.none)


getPost : PostId -> Cmd Msg
getPost postId =
  let
      url =
        "Posts/" ++ postId ++ ".md"
  in
      Task.perform FetchFail FetchSuccess (Http.getString url)


view : Model -> Html Msg
view model =
  div []
    [ text model.postId
    , text model.postContent
    ]

