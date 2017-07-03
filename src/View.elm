module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Pages.PagesView as PagesView
import States exposing (..)


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
        , Html.map PagesMessages (PagesView.view model.pagesModel model.state)
        , footer model
        ]


footer : model -> Html Msg
footer model =
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
            [ ( "Posts", Home )
            , ( "About", Blog "about" )
            , ( "Projects", Blog "projects" )
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

        menuItem ( name, state ) =
            button
                [ onClick (ChangeState state)
                , class <| "page-nav__btn btn " ++ activeClass state
                ]
                [ text name ]
    in
    div
        [ class "page-nav" ]
        (List.map menuItem states)
