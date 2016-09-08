module View exposing (view)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Model exposing (..)
import Messages exposing (..)
import Pages.PagesView as PagesView
import States exposing (..)

view : Model -> Html Msg
view model =
  div
    [ class "page-wrapper" ]
    [ div
        [ class "page-head" ]
        [ a
          [ href "https://arijus.net" ]
          [ h1 [] [ text "@argshook" ] ]
        , p
          []
          [ text "probably frontend mostly"
          ]
        ]
    , stateMenu model
    , Html.App.map PagesMessages (PagesView.view model.pagesModel model.state)
    , footer model
    ]

footer : model -> Html Msg
footer model =
  let
      githubLink =
        a
          [ href "https://github.com/argshook/elm-experiments"
          , target "_blank"
          ]
          [ text "github" ]
  in
      div
        [ class "page-footer" ]
        [
          text "This blog is written in Elm, check it out at "
        , githubLink
        ]


stateMenu : Model -> Html Msg
stateMenu model =
  let
      states =
        [ ("Home", Home)
        , ("About", Blog "about")
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
              Home ->
                activeButtonClass (state == Home)

              Blog postSlug ->
                let
                    postsInMenu =
                      [ "about", "hello-world" ]
                in
                    activeButtonClass (state == model.state)

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

