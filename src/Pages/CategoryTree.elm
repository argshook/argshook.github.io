module Pages.CategoryTree exposing (..)

import Html.App exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import String


type CategoryList a = Category CategoryNode | CategoryList CategoryNode (List (CategoryList a))

type alias CategoryNode = (Int, String)

type alias Model =
  { categoryInput : String
  , selectedCategory : Int
  , nextCategoryId : Int
  , categories : List (CategoryList String)
  }


initialModel : Model
initialModel =
  { categoryInput = ""
  , selectedCategory = 0
  , nextCategoryId = 1
  , categories = [ Category (0, "Root") ]
  }


type Msg
  = Input String
  | AddCategory
  | SelectCategory String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input newCategoryName ->
      ({ model | categoryInput = newCategoryName }, Cmd.none)

    AddCategory ->
      let
          insertCategory category =
            case category of
              Category (id, name) ->
                if id == model.selectedCategory then
                  CategoryList (id, name) [ Category (model.nextCategoryId, model.categoryInput) ]
                else
                  Category (id, name)

              CategoryList (id, name) list ->
                if id == model.selectedCategory then
                  CategoryList (id, name) (Category (model.nextCategoryId, model.categoryInput) :: list)
                else
                  CategoryList (id, name) (List.foldl (\c a -> (insertCategory c) :: a) [] list)

          newCategories =
            if model.categoryInput /= "" then
              List.map insertCategory model.categories
            else
              model.categories

          newModel =
            { model
            | categories = newCategories
            , categoryInput = ""
            , nextCategoryId = model.nextCategoryId + 1
            }

      in
          (newModel, Cmd.none)

    SelectCategory selectedCategory ->
      let
          selectedCategoryAsInt =
            case String.toInt selectedCategory of
              Ok n -> n
              Err error -> 0
      in
          ({ model | selectedCategory = selectedCategoryAsInt }, Cmd.none)


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


      categoryLabel : CategoryNode -> String
      categoryLabel (id, name) =
        toString id ++ ": " ++ name


      categoryRow : CategoryList String -> Html Msg
      categoryRow row =
        case row of
          Category categoryNode ->
            li [] [ text <| categoryLabel categoryNode ]

          CategoryList categoryNode list ->
            li
              []
              [ text <| categoryLabel categoryNode
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
                Category (id, name) ->
                  [ option [ value (toString id) ] [ text (dropdownRowName depth ++ " " ++ name ++ " id: " ++ (toString id)) ] ]

                CategoryList (id, name) list ->
                  List.foldl (\c a -> a ++ (dropdownRow (depth + 1) c) ) [ option [value (toString id)] [text (dropdownRowName
                  depth ++ " " ++ name ++ " id: " ++ (toString id))] ] list

            dropdownRowName : Int -> String
            dropdownRowName depth =
              String.repeat depth "--"

        in
            select
              [ onInput SelectCategory ]
              (List.concat (List.map (dropdownRow 0) model.categories))
  in
      div
        []
        [ categoryInput
        , categoriesDropdown
        , categoryAddButton
        , div [] [ text ("Selected category: " ++ (toString model.selectedCategory)) ]
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
