module Pages.Blog.PostsList exposing (..)

import Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Http
import Json.Decode as Json exposing ((:=))
import String


type alias Model =
  { filter : String
  , posts : List Post
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


initialModel : Model
initialModel =
  { filter = ""
  , posts = []
  }


type Msg
  = Filter String
  | OpenPost String
  | LoadPosts
  | LoadPostsSuccess (List Post)
  | LoadPostFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Filter newFilter ->
      ({ model | filter = newFilter }, Cmd.none)

    OpenPost postId ->
      (model, Navigation.newUrl ("#blog/" ++ postId))

    LoadPosts ->
      model ! [ loadPosts ]

    LoadPostsSuccess posts ->
      { model | posts = posts } ! []

    LoadPostFail err ->
      let
          _ = Debug.log "failed to fetch all posts" err
      in model ! []


loadPosts : Cmd Msg
loadPosts =
  let
      url =
        "db.json"

      responseDecoder : Json.Decoder (List Post)
      responseDecoder =
        Json.at ["posts"]
          <| Json.list
          <| Json.object7 Post
            ("title" := Json.string)
            ("author" := Json.string)
            ("id" := Json.string)
            ("slug" := Json.string)
            ("path" := Json.string)
            (Json.maybe ("dateCreated" := Json.int))
            (Json.maybe ("dateModified" := Json.int))
  in
      Task.perform LoadPostFail LoadPostsSuccess (Http.get responseDecoder url)

filteredPosts : Model-> List (Html Msg)
filteredPosts model =
  List.map (\p -> postCard p )
    <| if String.length model.filter /= 0 then
        List.filter
          (\p -> String.contains (String.toLower model.filter) (String.toLower p.title))
          model.posts
       else
         model.posts


view : Model -> Html Msg
view model =
    div
      [ class "blog" ]
      [ div
        [ class "blog-posts-filter" ]
        [ text "Filter posts "
        , input
            [ onInput Filter
            , placeholder "Filter posts"
            , value model.filter
            , class "input"
            ]
            []
        ]
      , div [ class "blog-posts-list" ] (filteredPosts model)
      ]


postCard : Post -> Html Msg
postCard post =
  a
    [ class "blog-post-card"
    , onClick (OpenPost post.slug)
    , href ("#blog/" ++ post.slug)
    ]
    [ text post.title ]

