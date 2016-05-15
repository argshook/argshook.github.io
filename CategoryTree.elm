module CategoryTree exposing (..)

import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String


type CategoryList a = Category String | CategoryList String (List (CategoryList a))


type alias Model =
  { categoryInput : String
  , selectedCategory : String
  , categories : List (CategoryList String)
  }


initialModel : Model
initialModel =
  { categoryInput = ""
  , selectedCategory = ""
  , categories =
    [ Category "root"
    , CategoryList "sibling "[ Category "Child" ]
    , CategoryList "sibling 2 " [ CategoryList "Child 2" [ Category "child 3" ] ]
    , Category "Another sibling"
    , CategoryList "sibling 4 "
        [ CategoryList "Child 4" [ Category "child 4a" ]
        , CategoryList "Child 9" [ Category "child 123" ]
        , CategoryList "Child 1" [ Category "child 2" ]
        ]
    ]
  }


type Msg
  = Input String
  | AddCategory
  | SelectCategory String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newCategoryInput ->
      ({ model | categoryInput = newCategoryInput }, Cmd.none)

    AddCategory ->
      let
          insertCategory category =
            case category of
              Category name ->
                if name == model.selectedCategory
                then CategoryList model.selectedCategory [ Category model.categoryInput ]
                else Category name

              CategoryList name list ->
                if name == model.selectedCategory
                then CategoryList name (Category model.categoryInput :: list)
                else CategoryList name (List.foldl (\c a -> (insertCategory c) :: a) [] list)

          newCategories =
            if model.categoryInput /= "" && model.selectedCategory /= ""
            then List.map insertCategory model.categories
            else model.categories

          newModel =
            { model
            | categories = newCategories
            , categoryInput = ""
            }

      in
          (newModel, Cmd.none)

    SelectCategory selectedCategory ->
      ({ model | selectedCategory = selectedCategory }, Cmd.none)


view : Model -> Html Msg
view model =
  let
      categoryInput : Html Msg
      categoryInput =
        input
          [ onInput Input
          , value model.categoryInput
          , style [ ("margin-bottom", "20px") ]
          ]
          []

      categoryRow : CategoryList String -> Html Msg
      categoryRow row =
        case row of
          Category name ->
            li [] [ text name ]

          CategoryList name list ->
            li
              []
              [ text name
              , ul [] (List.map categoryRow list)
              ]


      categoryAddButton : Html Msg
      categoryAddButton =
        button [ onClick AddCategory ] [ text "Add" ]

      categoriesDropdown : Html Msg
      categoriesDropdown =
        let
            dropdownRow : Int -> CategoryList a -> List (Html Msg)
            dropdownRow depth row =
              case row of
                Category name ->
                  [ option [ value name ] [ text (dropdownRowName depth ++ " " ++ name) ] ]

                CategoryList name list ->
                  List.foldl (\c a -> a ++ (dropdownRow (depth + 1) c) ) [ option [value name] [text (dropdownRowName depth ++ " " ++ name)] ] list

            dropdownRowName : Int -> String
            dropdownRowName depth =
              String.repeat depth "--"

        in
            select
              [ onInput SelectCategory ]
              (List.concat (List.map (dropdownRow 0) model.categories))
  in
      div
        [ style [ ("margin", "30px auto"), ("width", "400px") ] ]
        [ categoryInput
        , categoriesDropdown
        , categoryAddButton
        , div [] [ text ("Selected category: " ++ model.selectedCategory) ]
        , div [] [ text "Categories go below" ]
        , ul [] (List.map categoryRow model.categories)
        ]

main =
  Html.App.program
    { init = (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
