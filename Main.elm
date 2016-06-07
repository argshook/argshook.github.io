module Main exposing (..)

import Navigation
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)
import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String
import Pages.Age as Age
import Pages.Forms as Forms
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz


main =
  Navigation.program urlParser
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    , urlUpdate = urlUpdate
    }


init : Result String State -> ( Model, Cmd Msg )
init result =
  urlUpdate result initialModel


urlParser : Navigation.Parser (Result String State)
urlParser =
  Navigation.makeParser (fromUrl << .hash)


fromUrl : String -> Result String State
fromUrl hash =
  UrlParser.parse identity pageParser (String.dropLeft 1 hash)


pageParser : Parser (State -> a) a
pageParser =
  oneOf
  [ format Home (UrlParser.s "")
  , format Binary (UrlParser.s "binary")
  , format Forms (UrlParser.s "forms")
  , format Category (UrlParser.s "category")
  , format FizzBuzz (UrlParser.s "fizz-buzz")
  ]


toUrl : State -> String
toUrl state =
  case state of
    Home -> "#"
    Binary -> "#binary"
    Forms -> "#forms"
    Category -> "#category"
    FizzBuzz -> "#fizz-buzz"


urlUpdate : Result String State -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case result of
    Ok newState ->
      case newState of
        _ ->
          let
              model' =
                { model | state = newState }
          in
              (model', Cmd.none)

    Err _ ->
      (model, Navigation.modifyUrl (toUrl model.state))


type State = Home | Binary | Forms | Category | FizzBuzz


type alias Model =
  { ageModel : Age.Model
  , formsModel : Forms.Model
  , binaryTreeModel : BinaryTree.Model
  , categoryTreeModel : CategoryTree.Model
  , fizzBuzzModel : FizzBuzz.Model
  , state : State
  }


initialModel : Model
initialModel =
  { ageModel = Age.initialModel
  , formsModel = Forms.initialModel
  , binaryTreeModel = BinaryTree.initialModel
  , categoryTreeModel = CategoryTree.initialModel
  , fizzBuzzModel = FizzBuzz.initialModel
  , state = Home
  }


type Msg
  = AgeMsg Age.Msg
  | FormsMsg Forms.Msg
  | BinaryTreeMsg BinaryTree.Msg
  | CategoryTreeMsg CategoryTree.Msg
  | FizzBuzzMsg FizzBuzz.Msg
  | ChangeState State


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AgeMsg msg ->
      let
          (model', cmd) = Age.update msg model.ageModel
      in
          ({ model | ageModel = model' }, Cmd.map AgeMsg cmd)

    FormsMsg msg ->
      let
          formsModel = Forms.update msg model.formsModel
      in
          ({ model | formsModel = formsModel }, Cmd.none)

    BinaryTreeMsg msg ->
      let
          (binaryTreeModel, binaryTreeCmd) = BinaryTree.update msg model.binaryTreeModel
      in
          ({ model | binaryTreeModel = binaryTreeModel }, Cmd.map BinaryTreeMsg binaryTreeCmd)

    CategoryTreeMsg msg ->
      let
          (categoryTreeModel, categoryTreeCmd) = CategoryTree.update msg model.categoryTreeModel
      in
          ({ model | categoryTreeModel = categoryTreeModel }, Cmd.map CategoryTreeMsg categoryTreeCmd)

    FizzBuzzMsg msg ->
      let
          (fizzBuzzModel, fizzBuzzCmd) = FizzBuzz.update msg model.fizzBuzzModel
      in
          ({ model | fizzBuzzModel = fizzBuzzModel }, Cmd.map FizzBuzzMsg fizzBuzzCmd)

    ChangeState newState ->
      ({ model | state = newState }, Navigation.newUrl (toUrl newState))


displayComponent : Model -> Html Msg
displayComponent model =
  let
      component =
        case model.state of
          Home -> text "Hello"

          Forms ->
            div
              []
              [ Html.App.map FormsMsg (Forms.view model.formsModel)
              , Html.App.map AgeMsg (Age.view model.ageModel)
              ]

          Binary -> Html.App.map BinaryTreeMsg (BinaryTree.view model.binaryTreeModel)
          Category -> Html.App.map CategoryTreeMsg (CategoryTree.view model.categoryTreeModel)
          FizzBuzz -> Html.App.map FizzBuzzMsg (FizzBuzz.view model.fizzBuzzModel)
  in
    div
      []
      [ component ]


stateMenu : Model -> Html Msg
stateMenu model =
  let
      states =
        [("Home", Home), ("Forms", Forms), ("Binary", Binary), ("Category", Category), ("FizzBuzz", FizzBuzz)]

      activeStyle state =
        if state == model.state then
          [ ("font-weight", "bold") ]
        else
          []

      menuItem (name, state) =
        button
          [ onClick (ChangeState state)
          , style <| activeStyle state
          ]
          [ text name ]
  in
    div [] (List.map menuItem states)


view : Model -> Html Msg
view model =
  div
    [ style [ ("width", "600px"), ("margin", "30px auto") ] ]
    [ h2 [] [ text "Elm experiments" ]
    , p [] [ text "merely a sandbox to play with elm" ]
    , stateMenu model
    , displayComponent model
    ]


