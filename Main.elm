module Main exposing (..)

import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String
import Age
import Forms
import BinaryTree
import CategoryTree


type alias Model =
  { ageModel : Age.Model
  , formsModel : Forms.Model
  , binaryTreeModel : BinaryTree.Model
  , categoryTreeModel : CategoryTree.Model
  }


initialModel : Model
initialModel =
  { ageModel = Age.initialModel
  , formsModel = Forms.initialModel
  , binaryTreeModel = BinaryTree.initialModel
  , categoryTreeModel = CategoryTree.initialModel
  }


type Msg
  = AgeMsg Age.Msg
  | FormsMsg Forms.Msg
  | BinaryTreeMsg BinaryTree.Msg
  | CategoryTreeMsg CategoryTree.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AgeMsg msg ->
      let
          (ageModel, ageCmd) = Age.update msg model.ageModel

          model' =
            { model | ageModel = ageModel }
      in
          (model', Cmd.none)

    FormsMsg msg ->
      let
          formsModel = Forms.update msg model.formsModel

          model' =
            { model | formsModel = formsModel }
      in
          (model', Cmd.none)

    BinaryTreeMsg msg ->
      let
          (binaryTreeModel, binaryTreeCmd) = BinaryTree.update msg model.binaryTreeModel

          model' =
            { model | binaryTreeModel = binaryTreeModel }
      in
          (model', Cmd.none)

    CategoryTreeMsg msg ->
      let
          (categoryTreeModel, categoryTreeCmd) = CategoryTree.update msg model.categoryTreeModel

          model' =
            { model | categoryTreeModel = categoryTreeModel }
      in
          (model', Cmd.none)


view : Model -> Html Msg
view model =
  div
    []
    [ text "hai"
    , Html.App.map AgeMsg (Age.view model.ageModel)
    , Html.App.map FormsMsg (Forms.view model.formsModel)
    , Html.App.map BinaryTreeMsg (BinaryTree.view model.binaryTreeModel)
    , Html.App.map CategoryTreeMsg (CategoryTree.view model.categoryTreeModel)
    ]


main =
  Html.App.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
