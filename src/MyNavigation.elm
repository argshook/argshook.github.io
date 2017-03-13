module MyNavigation exposing (..)

import String
import UrlParser exposing (Parser, (</>), map, int, oneOf, s, string)
import Navigation
import Regex
import Model exposing (Model, initialModel)
import States exposing (..)
import Messages exposing (..)

import Pages.PagesUpdate
import Pages.PagesMessages
import Pages.Blog.PostMsg as PostMsg
import Pages.Blog.PostsListMsg as PostsListMsg


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
  ({ initialModel | history = [ location ] }, Cmd.none)


fromUrl : String -> String
fromUrl hash =
  let
      withoutPrefix =
        String.dropLeft 2 hash
  in
      if String.contains "#" withoutPrefix then
        Regex.replace Regex.All (Regex.regex "#.*$") (\_ -> "") withoutPrefix
      else
        withoutPrefix


pageParser : Parser (State -> a) a
pageParser =
  oneOf
  [ map Home (s "")
  , map Binary (s "binary")
  , map Minesweeper (s "minesweeper")
  , map Category (s "category")
  , map FizzBuzz (s "fizz-buzz")
  , map Blog (s "blog" </> string)
  ]


toUrl : State -> String
toUrl state =
  case state of
    Home -> "#!"
    Binary -> "#!binary"
    Minesweeper -> "#!minesweeper"
    Category -> "#!category"
    FizzBuzz -> "#!fizz-buzz"
    Blog q -> "#!blog/" ++ q


--update : Msg -> Model -> (Model, Cmd Msg)
--update msg model =
  --case msg of
    --Ok newState ->
      --case newState of
        --States.Home ->
          --let
              --(pagesModel, pagesCmd) =
                --Pages.PagesUpdate.update
                  --(Pages.PagesMessages.PostsListMsg (PostsListMsg.InitializeLoadPosts))
                  --model.pagesModel
          --in
              --{ model
              --| state = newState
              --, pagesModel = pagesModel
              --} !
              --[ Cmd.map PagesMessages pagesCmd ]

        --States.Blog slug ->
          --let
              --(pagesPostModel, pagesPostCmd) =
                --Pages.PagesUpdate.update
                  --(Pages.PagesMessages.PostMsg (PostMsg.LoadPost slug))
                  --model.pagesModel
          --in
              --{ model
              --| state = newState
              --, pagesModel = pagesPostModel
              --} !
              --[ Cmd.map PagesMessages pagesPostCmd ]

        --_ ->
          --{ model | state = newState } ! []

    --Err _ ->
      --(model, Navigation.modifyUrl (toUrl model.state))

