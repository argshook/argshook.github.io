module Pages.Minesweeper exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common exposing ((=>), colors)


type alias Model =
  { board : Board
  , gameState : GameState
  }


initialModel : Model
initialModel =
  { board = initialBoard
  , gameState = Playing
  }


type alias Board = List (List (Int, Cell))

type GameState = Playing | Lost | Won

type Cell = Marked | Closed CellContent | Revealed CellContent
type CellContent = Empty | Counter Int | Mine MineState
type MineState = Blown | NotBlown


initialBoard : Board
initialBoard =
  [ [ (0, Closed (Mine NotBlown)), (1, Closed (Counter 1)), (2, Closed (Mine Blown)) ]
  , [ (3, Closed (Mine NotBlown)), (4, Closed Empty), (5, Closed Empty) ]
  , [ (6, Closed Empty), (7, Closed Empty), (8, Closed (Counter 2)) ]
  ]


type Msg
  = RevealCell (Int ,Cell)
  | RestartGame


view : Model -> Html Msg
view model =
  let
      mine : MineState -> String
      mine m =
        case m of
          Blown -> "boom"
          NotBlown -> "not boom"


      revealed : CellContent -> String
      revealed c =
        case c of
          Empty -> " "
          Counter n -> toString n
          Mine state -> mine state


      cell : (Int, Cell) -> Html Msg
      cell (id, c) =
        let
            text' =
              case c of
                Marked -> "?"
                Closed c -> "x"
                Revealed c -> revealed c

            background =
              case c of
                Closed c -> colors.dark
                Revealed content ->
                  case content of
                    Mine state ->
                      case state of
                        Blown -> "#f00"
                        NotBlown -> "#CCC"
                    _ -> colors.light
                _ -> colors.light
        in
            td
              [ style <|
                  [ "width" => "64px"
                  , "height" => "64px"
                  , "text-align" => "center"
                  , "vertical-align" => "middle"
                  , "cursor" => "pointer"
                  ] ++ [ "background" => background ]
              , onClick <| RevealCell (id, c)
              ]
              [ a [] [ text text' ] ]


      row : List (Int, Cell) -> (Html Msg)
      row cells =
        tr
          []
          (List.map cell cells)

      minesweeper =
        table
          [ style [ "margin" => "0 auto" ] ]
          (List.map row model.board)

      restartBtn =
        button
          [ style [ "margin" => "30px auto", "display" => "block" ]
          , onClick RestartGame
          ]
          [ text "Restart" ]

  in
      div
        []
        [ minesweeper, restartBtn ]


newBoard : Board -> (Int, Cell) -> Board
newBoard oldBoard (revealedId, revealedCell) =
  let
      rows : List (Int, Cell) -> List (Int, Cell)
      rows row =
        List.map cell row


      cell : (Int, Cell) -> (Int, Cell)
      cell (id, c) =
        if revealedId == id then
          case c of
            Revealed content -> (id, c)
            Closed content ->
              case content of
                Empty -> (id, Revealed Empty)
                Counter n -> (id, Revealed (Counter n))
                Mine _ -> (id, Revealed (Mine Blown))
            _ -> (id, c)
        else
          (id, c)

  in
      List.map rows oldBoard


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RevealCell (id, cell) ->
      case model.gameState of
        _ ->
          { model | board = newBoard model.board (id, cell) } ! [ Cmd.none ]

    RestartGame ->
      { model | board = initialBoard } ! [ Cmd.none ]

