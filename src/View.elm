module View exposing (view)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing ((=>), colors)

import Pages.Age as Age
import Pages.Forms as Forms
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz
import Pages.Blog.Main as Blog
import Pages.Blog.PostsList as PostsList

import Models exposing (..)
import Messages exposing (..)


view : Model -> Html Msg
view model =
  div
    [ style
      [ "width" => "700px"
      , "margin" => "0 auto"
      , "min-height" => "100vh"
      ]
    ]
    [ div
        [ style [ "padding" => "30px", "background" => colors.light ] ]
        [ h2
          []
          [ text "Elm experiments" ]
        , p
          []
          [ text "merely a sandbox to play with elm" ]
        ]
    , stateMenu model
    , displayComponent model
    ]


stateMenu : Model -> Html Msg
stateMenu model =
  let
      states =
        [ ("Home", Home)
        , ("Forms", Forms)
        , ("Binary", Binary)
        , ("Category", Category)
        , ("FizzBuzz", FizzBuzz)
        ]

      buttonStyle =
        [ "border" => ("1px solid " ++ colors.medium)
        , "border-radius" => "5px / 10px"
        , "padding" => "10px 25px"
        , "color" => colors.dark
        , "background" => "transparent"
        , "cursor" => "pointer"
        , "font-weight" => "bold"
        ]

      activeStyle state =
        if state == model.state then
          buttonStyle ++ [ "background" => colors.dark, "color" => colors.light ]
        else
          buttonStyle

      menuItem (name, state) =
        button
          [ onClick (ChangeState state)
          , style <| activeStyle state
          ]
          [ text name ]

      menuStyles =
        [ "display" => "flex"
        , "justify-content" => "space-around"
        , "padding" => "30px"
        , "background" => colors.light
        ]

  in
    div
      [ style menuStyles ]
      (List.map menuItem states)


displayComponent : Model -> Html Msg
displayComponent model =
  let
      component =
        case model.state of
          Home ->
            Html.App.map PostsListMsg (PostsList.view model.postsListModel)

          Forms ->
            div
              []
              [ Html.App.map FormsMsg (Forms.view model.formsModel)
              , Html.App.map AgeMsg (Age.view model.ageModel)
              ]

          Binary -> Html.App.map BinaryTreeMsg (BinaryTree.view model.binaryTreeModel)
          Category -> Html.App.map CategoryTreeMsg (CategoryTree.view model.categoryTreeModel)
          FizzBuzz -> Html.App.map FizzBuzzMsg (FizzBuzz.view model.fizzBuzzModel)
          Blog n -> Blog.view model
  in
    div
      [ style [ "padding" => "30px 0 0" ] ]
      [ component ]

