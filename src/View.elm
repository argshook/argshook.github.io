module View exposing (view)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Common exposing ((=>), colors, CSS)
import Model exposing (..)
import Messages exposing (..)
import Pages.PagesView as PagesView
import States exposing (..)

view : Model -> Html Msg
view model =
  let
      githubLink =
        a
          [ href "https://github.com/argshook/elm-experiments"
          , target "_blank" ]
          [ text "github" ]

  in
      div
        [ class "page-wrapper" ]
        [ div
            [ class "page-head" ]
            [ h1
              []
              [ text "Elm experiments" ]
            , p
              []
              [ text "merely a sandbox to play with elm. "
              , div [ class "page-head__github" ] [ githubLink ]
              ]
            ]
        , stateMenu model
        , Html.App.map PagesMessages (PagesView.view model.pagesModel model.state)
        ]


stateMenu : Model -> Html Msg
stateMenu model =
  let
      states =
        [ ("Home", Home)
        , ("Minesweeper", Minesweeper)
        , ("Binary", Binary)
        , ("Category", Category)
        , ("FizzBuzz", FizzBuzz)
        ]

      activeClass : State -> String
      activeClass state =
        let
            activeButtonClass : Bool -> String
            activeButtonClass condition =
              if condition then
                "btn--active"
              else
                ""
        in
            case model.state of
              Blog postId ->
                activeButtonClass (state == Home)

              _ ->
                activeButtonClass (model.state == state)

      menuItem (name, state) =
        button
          [ onClick (ChangeState state)
          , class <| "page-nav__btn btn btn--lg " ++ (activeClass state)
          ]
          [ text name ]

  in
    div
      [ class "page-nav" ]
      (List.map menuItem states)

