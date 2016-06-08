module View exposing (view)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Pages.Age as Age
import Pages.Forms as Forms
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz

import Models exposing (..)
import Messages exposing (..)

view : Model -> Html Msg
view model =
  div
    [ style [ ("width", "600px"), ("margin", "30px auto") ] ]
    [ h2 [] [ text "Elm experiments" ]
    , p [] [ text "merely a sandbox to play with elm" ]
    , stateMenu model
    , displayComponent model
    ]


stateMenu : Model -> Html Msg
stateMenu model =
  let
      states =
        [("Home", Home), ("Forms", Forms), ("Binary", Binary), ("Category", Category), ("FizzBuzz", FizzBuzz)]

      activeStyle state =
        if state == model.state then
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


displayComponent : Model -> Html Msg
displayComponent model =
  let
      component =
        case model.state of
          Home -> text "Hello"

          Forms ->
            div
              []
              [ Html.App.map FormsMsg (Forms.view model.formsModel)
              , Html.App.map AgeMsg (Age.view model.ageModel)
              ]

          Binary -> Html.App.map BinaryTreeMsg (BinaryTree.view model.binaryTreeModel)
          Category -> Html.App.map CategoryTreeMsg (CategoryTree.view model.categoryTreeModel)
          FizzBuzz -> Html.App.map FizzBuzzMsg (FizzBuzz.view model.fizzBuzzModel)
  in
    div
      []
      [ component ]

