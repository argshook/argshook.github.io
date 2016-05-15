module Tree exposing (..)

import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes
import Html.Events

import Svg exposing (..)
import Svg.Attributes exposing (..)


type Tree a
  = Node a (Tree a) (Tree a)
  | Empty


type alias Vector =
  { x1 : Float
  , y1 : Float
  , x2 : Float
  , y2 : Float
  }


type alias Model =
  { tree : Tree Vector }


initialVector : Vector
initialVector =
  { x1 = 0
  , y1 = 0
  , x2 = 0
  , y2 = 0
  }


initialModel : Model
initialModel =
  { tree = singleton initialVector }


type Msg
  = NoOp


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)


rootNode : Vector
rootNode =
  { initialVector
  | x1 = 50
  , y1 = 0
  , x2 = 50
  , y2 = 20
  }


newNodeVector : Int -> Vector -> Vector
newNodeVector degree vector =
  { vector
  | x1 = vector.x1 / 2
  , y1 = vector.y2
  , x2 = vector.x2 / 2
  , y2 = vector.y2 + 20
  }


growTree : Tree Vector -> Tree Vector
growTree tree =
  case tree of
    Empty ->
      singleton initialVector

    Node vector left right ->
      singleton vector


singleton : Vector -> Tree Vector
singleton vector =
  Node vector Empty Empty


treeToLine : Tree Vector -> Html Msg
treeToLine tree =
  case tree of
    Empty ->
      let
          _ = Debug.log "tree" tree
      in
          line [] []

    Node vector left right ->
      let
          newVector =
            newNodeVector 0 vector
          _ = Debug.log "tree" vector
      in
        line
          [ x1 (toString newVector.x1)
          , y1 (toString newVector.y1)
          , x2 (toString newVector.x2)
          , y2 (toString newVector.y2)
          , stroke "#f00"
          ]
          []


treeBox : Model -> Html Msg
treeBox model =
  Svg.svg
    [ viewBox "0 0 100 100" ]
    --[ treeToLine (singleton rootNode)
    --, treeToLine <| growTree (singleton rootNode)
    --]
    (List.foldl (\node -> treeToLine <| growTree (singleton node)) [] (List.repeat 3 (singleton rootNode)))
        --[ line [ x1 "50", y1 "100", x2 "50", y2 "75", stroke "#f00" ] []

    --, line [ x1 "50", y1 "75", x2 "25", y2 "50", stroke "#f00" ] []
    --, line [ x1 "50", y1 "75", x2 "75", y2 "50", stroke "#f00" ] []

    --, line [ x1 "25", y1 "50", x2 "10", y2 "25", stroke "#3f0" ] []
    --, line [ x1 "25", y1 "50", x2 "37.5", y2 "25", stroke "#3fa" ] []
    --, line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#fff" ] []
    --]


view : Model -> Html Msg
view model =
  div
    [ Html.Attributes.style
        [ ("width", "300px")
        , ("height", "300px")
        , ("margin", "auto") ]
        ]
    [ treeBox model ]

main =
  Html.App.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
