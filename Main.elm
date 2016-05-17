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


type State = Home | Binary | Forms | Category


type alias Model =
  { ageModel : Age.Model
  , formsModel : Forms.Model
  , binaryTreeModel : BinaryTree.Model
  , categoryTreeModel : CategoryTree.Model
  , activeState : State
  }


initialModel : Model
initialModel =
  { ageModel = Age.initialModel
  , formsModel = Forms.initialModel
  , binaryTreeModel = BinaryTree.initialModel
  , categoryTreeModel = CategoryTree.initialModel
  , activeState = Home
  }


type Msg
  = AgeMsg Age.Msg
  | FormsMsg Forms.Msg
  | BinaryTreeMsg BinaryTree.Msg
  | CategoryTreeMsg CategoryTree.Msg
  | ChangeState State


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AgeMsg msg ->
      let
          (model', cmd) = Age.update msg model.ageModel
      in
          ({ model | ageModel = model' }, Cmd.map AgeMsg cmd)

    FormsMsg msg ->
      let
          formsModel = Forms.update msg model.formsModel
      in
          ({ model | formsModel = formsModel }, Cmd.none)

    BinaryTreeMsg msg ->
      let
          (binaryTreeModel, binaryTreeCmd) = BinaryTree.update msg model.binaryTreeModel
      in
          ({ model | binaryTreeModel = binaryTreeModel }, Cmd.map BinaryTreeMsg binaryTreeCmd)

    CategoryTreeMsg msg ->
      let
          (categoryTreeModel, categoryTreeCmd) = CategoryTree.update msg model.categoryTreeModel
      in
          ({ model | categoryTreeModel = categoryTreeModel }, Cmd.map CategoryTreeMsg categoryTreeCmd)

    ChangeState state ->
      ({ model | activeState = state }, Cmd.none)


displayComponent : Model -> Html Msg
displayComponent model =
  let
      component =
        case model.activeState of
          Home -> text "Hello"

          Forms ->
            div
              []
              [ Html.App.map FormsMsg (Forms.view model.formsModel)
              , Html.App.map AgeMsg (Age.view model.ageModel)
              ]

          Binary -> Html.App.map BinaryTreeMsg (BinaryTree.view model.binaryTreeModel)
          Category -> Html.App.map CategoryTreeMsg (CategoryTree.view model.categoryTreeModel)
  in
    div
      []
      [ component ]


stateMenu : Model -> Html Msg
stateMenu model =
  let
      states =
        [("Home", Home), ("Forms", Forms), ("Binary", Binary), ("Category", Category)]

      activeStyle state =
        if state == model.activeState then
          [ ("font-weight", "bold") ]
        else
          []

      menuItem (name, state) =
        button
          [ onClick (ChangeState state)
          , style <| activeStyle state
          ]
          [ text name ]
  in
    div [] (List.map menuItem states)


view : Model -> Html Msg
view model =
  div
    [ style [ ("width", "600px"), ("margin", "30px auto") ] ]
    [ h2 [] [ text "Elm experiments" ]
    , p [] [ text "merely a sandbox to play with elm" ]
    , stateMenu model
    , displayComponent model
    ]


main =
  Html.App.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

