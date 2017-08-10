port module Post.Main exposing (update, view)

import Html exposing (Html, text, div, button, span)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Http
import Markdown
import Navigation
import Post.Date exposing (postDate)
import Post.Model exposing (Model, PostMeta, PostId, initialModel, initialPostMeta)
import Post.Msg as Msg exposing (Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msg.LoadPost postId postMeta ->
            { initialModel
                | postId = postId
                , postMeta = postMeta
            }
                ! [ getPost postId ]

        Msg.PostLoaded ->
            model
                ! [ highlight "" ]

        Msg.ShowComments ->
            { model | isCommentsShown = True }
                ! [ blogPostCommentsEnabled model.postMeta.id ]

        Msg.PostFetch data ->
            case data of
                Ok post ->
                    let
                        model_ =
                            { model
                                | postContent = post
                                , isPostLoading = False
                            }
                    in
                        update Msg.PostLoaded model_

                Err _ ->
                    { model
                        | postContent = "Failed to fetch :("
                        , isPostLoading = False
                    }
                        ! []

        Msg.PostMetaFetch postsMeta ->
            case postsMeta of
                Ok metas ->
                    let
                        postMeta =
                            List.filter (\p -> p.slug == model.postId) metas
                                |> List.head
                                |> Maybe.withDefault initialPostMeta
                    in
                        { model | postMeta = postMeta } ! []

                Err _ ->
                    model ! []

        Msg.GoBack ->
            model ! [ Navigation.back 1 ]

        Msg.SetPostMeta postMeta ->
            { model | postMeta = postMeta } ! []


getPost : PostId -> Cmd Msg
getPost postId =
    let
        url =
            "Posts/" ++ postId ++ ".md"
    in
        Http.send Msg.PostFetch
            (Http.getString url)


view : Model -> Html Msg
view model =
    if model.isPostLoading then
        div [ class "blog-post blog-post--loading" ] [ text "Loading..." ]
    else
        div [ class "blog-post" ] <|
            [ postHeader model.postMeta
            , Markdown.toHtml [ class "blog-post-content" ] model.postContent
            ]
                ++ showCommentsBlock model


showCommentsBlock : Model -> List (Html Msg)
showCommentsBlock model =
    let
        commentsBlock : Bool -> Html Msg
        commentsBlock isShown =
            if isShown then
                div [ id "disqus_thread" ] []
            else
                button
                    [ onClick Msg.ShowComments
                    , class "card card--small"
                    ]
                    [ text "Show Comments" ]

        conditions =
            [ model.postMeta /= initialPostMeta
            , List.all (\s -> model.postMeta.slug /= s) [ "about", "projects" ]
            ]
    in
        if List.all (\c -> c) conditions then
            [ div
                [ class "blog-post-comments" ]
                [ commentsBlock model.isCommentsShown ]
            ]
        else
            []


postHeader : PostMeta -> Html Msg
postHeader postMeta =
    let
        { date, time } =
            postDate postMeta.dateCreated
    in
        div
            [ class "blog-post-header" ]
            [ button
                [ class "btn btn--as-link"
                , onClick Msg.GoBack
                ]
                [ text "« Back" ]
            , div
                [ class "blog-post-header-meta" ]
                [ span [ class "blog-post-header-meta__date" ] [ text date ]
                , span [ class "blog-post-header-meta__time" ] [ text time ]
                ]
            ]


port highlight : String -> Cmd msg


port blogPostCommentsEnabled : String -> Cmd msg
