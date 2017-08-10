module PostsList.Main exposing (update, view)

import Css
import Html exposing (Html, div, text, input, button)
import Html.Attributes exposing (class, style, value, classList)
import Html.Events exposing (onInput, onClick)
import Navigation
import Post.Date exposing (postDate)
import Post.Model exposing (PostMeta)
import Post.Msg as PostMsg
import PostsList.Model exposing (Model)
import PostsList.Msg as Msg exposing (Msg)
import Pages.Msg as PagesMsg
import String
import Task


emptyListStyles : Html.Attribute msg
emptyListStyles =
    [ Css.padding <| Css.rem 2
    , Css.textAlign Css.center
    ]
        |> Css.asPairs
        |> Html.Attributes.style


update : Msg -> Model -> ( Model, Cmd Msg, Cmd PagesMsg.Msg )
update msg model =
    case msg of
        Msg.Filter newFilter ->
            ( { model | filter = newFilter }, Cmd.none, Cmd.none )

        Msg.OpenPost post ->
            ( model
              -- TOOD: dont directly change url here
            , Navigation.newUrl ("#blog/" ++ post.slug)
            , Task.perform PagesMsg.PostMsg
                (Task.succeed (PostMsg.SetPostMeta post))
            )

        Msg.LoadPosts posts ->
            ( { model | posts = posts }
            , Cmd.none
            , Cmd.none
            )


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
                            [ class "blog-posts-empty-list", emptyListStyles ]
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
            [ onInput Msg.Filter
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
            , onClick (Msg.OpenPost post)
            ]
            [ div [ class "card__title" ] [ text post.title ]
            , div [ class "card__date" ] [ text (date ++ " " ++ time) ]
            ]
