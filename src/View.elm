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
        [ style
          [ "width" => "700px"
          , "margin" => "0 auto"
          ]
        ]
        [ header
            [ class "blog-head" ]
            [ h1
              []
              [ text "Elm experiments" ]
            , p
              []
              [ text "merely a sandbox to play with elm. "
              , div [ class "blog-head__github" ] [ githubLink ]
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

      buttonStyle =
        [ "border" => ("1px solid " ++ colors.medium)
        , "border-radius" => "5px / 10px"
        , "padding" => "10px 25px"
        , "color" => colors.dark
        , "background" => "transparent"
        , "cursor" => "pointer"
        , "font-weight" => "bold"
        ]

      activeStyle : State -> CSS
      activeStyle state =
        let
            activeButtonStyle : Bool -> CSS
            activeButtonStyle condition =
              if condition then
                buttonStyle ++ [ "background" => colors.dark, "color" => colors.light ]
              else
                buttonStyle
        in
            case model.state of
              Blog postId ->
                activeButtonStyle (state == Home)

              _ ->
                activeButtonStyle (model.state == state)

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

