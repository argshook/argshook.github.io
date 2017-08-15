module Header exposing (view)

import Msg exposing (Msg)
import Html exposing (Html, div, button, text, p, h2, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import States exposing (State)
import Common exposing (classNames)


view : State -> Html Msg
view state =
    div
        [ class "page-head" ]
        [ pageTitle
        , navMenu state
        ]


navItems : List ( String, State )
navItems =
    [ ( "Posts", States.Home )
    , ( "About", States.Blog "about" )
    , ( "Projects", States.Blog "projects" )
    ]


navMenu : State -> Html Msg
navMenu state =
    let
        navButton ( name, navState ) =
            button
                [ onClick (Msg.ChangeState navState)
                , class <|
                    classNames
                        [ Common.ClassName "page-nav__btn"
                        , Common.ClassName "btn"
                        , Common.ClassNameWithCondition "btn--active" (navState == state)
                        ]
                ]
                [ text name ]
    in
        div
            [ class "page-nav" ]
            (List.map navButton navItems)


pageTitle : Html Msg
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
