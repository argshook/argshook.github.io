module Forms exposing (Model, initialModel, Msg, view, update)

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App exposing (..)

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , submitted : Bool
  , rememberMe : Bool
  }


initialModel : Model
initialModel =
  { name = ""
  , password = ""
  , passwordAgain = ""
  , submitted = False
  , rememberMe = False
  }


type Msg
  = Name String
  | Password String
  | PasswordAgain String
  | RememberMe Bool
  | Submit
  | Clear


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password  ->
      { model | password = password }

    PasswordAgain passwordAgain  ->
      { model | passwordAgain = passwordAgain }

    Clear ->
      let
          _ = Debug.log "clear" model
      in
          initialModel

    Submit ->
      { initialModel | submitted = True }

    RememberMe value ->
      { model | rememberMe = value }


view : Model -> Html Msg
view model =
  let
      isSubmitDisabled =
        model.name == ""
          || model.password == ""
          || model.password /= model.passwordAgain
          || model.submitted
  in
      div
        []
        [ div [] [ text "Enter name:" ]
        , input [ onInput Name, value model.name ] []
        , div [] [ text "Enter password:" ]
        , input [ type' "password", onInput Password, value model.password ] []
        , div [] [ text "Repeat password:" ]
        , input [ type' "password", onInput PasswordAgain, value model.passwordAgain ] []
        , validationView model
        , div
            []
            [ text "Remember Me:"
            , input
                [ type' "checkbox", onCheck RememberMe, checked model.rememberMe ]
                []
            ]
        , button [ onClick Submit, disabled isSubmitDisabled ] [ text "Submit" ]
        , button [ onClick Clear ] [ text "Clear" ]
        ]


validationView : Model -> Html Msg
validationView model =
  let
      shouldShowPassword : Bool
      shouldShowPassword =
        model.password /= ""
          && model.passwordAgain /= ""
          && model.password /= model.passwordAgain
          && (String.length model.password) <= (String.length model.passwordAgain)
  in
    div
      []
      [ div [] [ text (if model.name /= "" && not model.submitted then "Name typed" else "") ]
      , div [] [ text (if shouldShowPassword then "Passwords don't match!" else "") ]
    ]

main =
  Html.App.beginnerProgram { model = initialModel, view = view, update = update }

