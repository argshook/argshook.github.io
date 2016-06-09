module Pages.Blog.Post exposing (..)


import Html exposing (..)


type alias Model =
  { postId : String }

type Msg
  = NoOp


initialModel : Model
initialModel =
  { postId = "" }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = (model, Cmd.none)


view : Model -> Html Msg
view model =
  div []
    [ text <| "blog post " ++ model.postId ]

