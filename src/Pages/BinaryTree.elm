module Pages.BinaryTree exposing (..)

import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String


type Tree a =  Empty | Node a (Tree a) (Tree a)


type alias Model =
  { treeNodeInput : String
  , tree : Tree Int
  }


initialModel : Model
initialModel =
  { treeNodeInput = ""
  , tree = Empty
  }


treeNode : a -> Tree a
treeNode value =
  Node value Empty Empty


insertIntoTree : comparable -> Tree comparable -> Tree comparable
insertIntoTree newValue tree =
  case tree of
    Empty ->
      treeNode newValue

    Node value left right ->
      if newValue > value then
        Node value left (insertIntoTree newValue right)
      else if (newValue < value) then
        Node value (insertIntoTree newValue left) right
      else
        tree


type Msg
  = Input String
  | AddTreeNode


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newinput ->
      ({ model | treeNodeInput = newinput }, Cmd.none)

    AddTreeNode ->
      let
          treeValue =
            case String.toInt model.treeNodeInput of
              Ok n -> Just n
              Err error -> Nothing

          newTree =
            case treeValue of
              Just n -> insertIntoTree n model.tree
              Nothing -> model.tree

          newModel =
            { model
            | tree = newTree
            , treeNodeInput = ""
            }

      in
          (newModel, Cmd.none)


drawTree : Tree a -> Html Msg
drawTree tree =
  case tree of
    Empty ->
      div [] [ text "-" ]

    Node value left right ->
      div
        [ style [ ("display", "flex"), ("flex-wrap", "wrap"), ("text-align", "center")] ]
        [ div [ style [ ("flex", "1 0 100%") ] ] [ text (toString value) ]
        , div
            [ style [ ("flex", "0 1 50%") ] ]
            [ drawTree left ]
        , div
            [ style [ ("flex", "0 1 50%") ] ]
            [ drawTree right ]
        ]


sumTreeNodes : Tree Int -> Int
sumTreeNodes tree =
  let
      list = []

      listOfTreeValues : Tree Int -> List Int
      listOfTreeValues tree =
        case tree of
          Empty ->
            0 :: list

          Node value left right ->
            value :: (List.concat [ (listOfTreeValues left), (listOfTreeValues right) ])
  in
      List.foldl (\c a -> a + c) 0 (listOfTreeValues tree)


flattenTree : Tree Int -> List String
flattenTree tree =
  let
      list = []

      listOfTreeValues : Tree Int -> List String
      listOfTreeValues tree =
        case tree of
          Empty ->
            "" :: list

          Node value left right ->
            toString value :: (List.concat [ (listOfTreeValues left), (listOfTreeValues right) ])
  in
      listOfTreeValues tree


findInTree : a -> Tree a -> Bool
findInTree needle tree =
  case tree of
    Empty ->
      False

    Node value left right ->
      if value == needle
      then True
      else
        findInTree needle left || findInTree needle right


view : Model -> Html Msg
view model =
  let
      treeNodeAsInt =
        case String.toInt model.treeNodeInput of
          Ok n -> n
          Err error -> 0


      isDuplicate : Bool
      isDuplicate =
        findInTree treeNodeAsInt model.tree
  in
      div
        [ style [ ("margin", "30px auto"), ("width", "600px")] ]
        [ h3 [] [ text "Binary Tree" ]
        , p [] [ text "Type some numbers and grow binary tree! What could be more fun!" ]
        , input
            [ onInput Input
            , value model.treeNodeInput
            , style [ ("margin-bottom", "30px") ]
            ]
            []
          , button
              [ onClick AddTreeNode
              , disabled isDuplicate
              ]
              [ text "Add to tree" ]
          , div [] [ (drawTree model.tree) ]
          , div [] [ text <| "Sum of nodes: " ++ toString (sumTreeNodes model.tree) ]
          , div [] [ text <| "Flattenned tree: " ++ toString (flattenTree model.tree) ]
          ]


main =
  Html.App.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

