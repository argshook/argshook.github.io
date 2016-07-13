port module Pages.Blog.Post exposing (..)


import Navigation
import Html exposing (..)
import Html.Events exposing (..)
import Task
import Http
import Markdown

type alias PostId = String

type alias Model =
  { postId : PostId
  , postContent : String
  , isPostLoading : Bool
  }


initialModel : Model
initialModel =
  { postId = ""
  , postContent = ""
  , isPostLoading = True
  }


type Msg
  = FetchSuccess String
  | FetchFail Http.Error
  | LoadPost PostId
  | Highlight


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoadPost postId ->
      { model
      | postId = postId
      , isPostLoading = True
      } ! [ getPost postId ]

    Highlight ->
      model ! [ highlight "" ]

    FetchSuccess data ->
      let
          model' =
            { model
            | postContent = data
            , isPostLoading = False
            }

      in
         update Highlight model'

    FetchFail error ->
      let
          _ = Debug.log "fetch fail" error
      in
          { model
          | postContent = "Failed to fetch :("
          , isPostLoading = False
          } ! []



getPost : PostId -> Cmd Msg
getPost postId =
  let
      url =
        "Posts/" ++ postId ++ ".md"
  in
      Task.perform FetchFail FetchSuccess (Http.getString url)


view : Model -> Html Msg
view model =
  if model.isPostLoading then
    div [] [ text "Loading..." ]
  else
    div []
      [ Markdown.toHtml [] model.postContent ]


port highlight : String -> Cmd msg

