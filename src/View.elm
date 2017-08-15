module View exposing (view)

import Header
import Html exposing (Html, div, button, text, h2, a, p)
import Html.Attributes exposing (class, target, href)
import Msg exposing (Msg)
import Model exposing (Model)
import Pages.View as PagesView


view : Model -> Html Msg
view model =
    div
        [ class "page-wrapper" ]
        [ Header.view model.state
        , Html.map Msg.PagesMsg (PagesView.view model.pagesModel model.state)
        , footer
        ]


footer : Html Msg
footer =
    div
        [ class "page-footer" ]
        [ text "This blog is written in Elm, check it out at "
        , a
            [ href "https://github.com/argshook/argshook.github.io"
            , target "_blank"
            ]
            [ text "github" ]
        ]
