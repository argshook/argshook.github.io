module Pages.Blog.PostsList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Navigation
import Pages.Blog.Date exposing (postDate)
import Pages.Blog.PostModel exposing (PostMeta, initialPostMeta)
import Pages.Blog.PostMsg as PostMsg
import Pages.Blog.PostsListModel exposing (..)
import Pages.Blog.PostsListMsg exposing (..)
import Pages.PagesMessages as PagesMessages
import String
import Task


update : Msg -> Model -> ( Model, Cmd Msg, Cmd PagesMessages.Msg )
update msg model =
    case msg of
        Filter newFilter ->
            ( { model | filter = newFilter }, Cmd.none, Cmd.none )

        OpenPost post ->
            ( model
              -- TOOD: dont directly change url here
            , Navigation.newUrl ("#blog/" ++ post.slug)
            , Task.perform PagesMessages.PostMsg
                (Task.succeed (PostMsg.SetPostMeta post))
            )

        InitializeLoadPosts ->
            ( model
            , loadPosts
            , Cmd.none
            )

        LoadPosts result ->
            case result of
                Ok posts ->
                    ( { model | posts = posts }
                    , Cmd.none
                    , Cmd.none
                    )

                Err error ->
                    let
                        _ =
                            Debug.log "failed to fetch all posts" error
                    in
                    ( model, Cmd.none, Cmd.none )


loadPosts : Cmd Msg
loadPosts =
    Http.send LoadPosts
        (Http.get "db.json" postsResponseDecoder)


filteredPosts : Model -> List (Html Msg)
filteredPosts model =
    let
        preparePostCard post =
            if String.length model.filter == 0 then
                postCard True post
            else if String.contains (String.toLower model.filter) (String.toLower post.title) then
                postCard True post
            else
                postCard False post
    in
    List.reverse model.posts
        |> List.map (\p -> preparePostCard p)


view : Model -> Html Msg
view model =
    let
        posts : List (Html Msg)
        posts =
            filteredPosts model
    in
    div
        [ class "blog" ]
    <|
        [ filterBlock model.filter ]
            ++ (if List.length posts == 0 then
                    [ div
                        [ class "blog-posts-empty-list" ]
                        [ text "No posts found :(" ]
                    ]
                else
                    [ div [ class "blog-posts-list" ] posts ]
               )


filterBlock : String -> Html Msg
filterBlock query =
    div
        [ class "blog-posts-filter" ]
        [ text "List.filter (\\p -> String.contains \""
        , input
            [ onInput Filter
            , value query
            , style
                [ ( "width"
                  , toString (String.length query * 10 + 30) ++ "px"
                  )
                ]
            ]
            []
        , text "\" p.title) posts"
        ]


postCard : Bool -> PostMeta -> Html Msg
postCard isVisible post =
    let
        { date, time } =
            postDate post.dateCreated
    in
    button
        [ classList [ ( "card", True ), ( "card--hidden", not isVisible ) ]
        , onClick (OpenPost post)
        ]
        [ div [ class "card__title" ] [ text post.title ]
        , div [ class "card__date" ] [ text (date ++ " " ++ time) ]
        ]
