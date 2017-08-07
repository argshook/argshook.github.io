module View exposing (view)

import Html exposing (Html, div, button, text, h2, a, p)
import Html.Attributes exposing (class, target, href)
import Html.Events exposing (onClick)
import Msg exposing (Msg)
import Model exposing (Model)
import Pages.View as PagesView
import States


view : Model -> Html Msg
view model =
    let
        pageTitle =
            div
                [ class "page-title" ]
                [ a
                    [ href "https://arijus.net" ]
                    [ h2 [] [ text "arijus.net" ] ]
                , p
                    []
                    [ text "personal blog" ]
                ]
    in
        div
            [ class "page-wrapper" ]
            [ div
                [ class "page-head" ]
                [ pageTitle
                , stateMenu model
                ]
            , Html.map Msg.PagesMsg (PagesView.view model.pagesModel model.state)
            , footer
            ]


footer : Html Msg
footer =
    let
        githubLink =
            a
                [ href "https://github.com/argshook/argshook.github.io"
                , target "_blank"
                ]
                [ text "github" ]
    in
        div
            [ class "page-footer" ]
            [ text "This blog is written in Elm, check it out at "
            , githubLink
            ]


stateMenu : Model -> Html Msg
stateMenu model =
    let
        states =
            [ ( "Posts", States.Home )
            , ( "About", States.Blog "about" )
            , ( "Projects", States.Blog "projects" )
            ]

        activeClass : States.State -> String
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
                    States.Home ->
                        activeButtonClass (state == States.Home)

                    States.Blog _ ->
                        activeButtonClass (state == model.state)

        menuItem ( name, state ) =
            button
                [ onClick (Msg.ChangeState state)
                , class <| "page-nav__btn btn " ++ activeClass state
                ]
                [ text name ]
    in
        div
            [ class "page-nav" ]
            (List.map menuItem states)
