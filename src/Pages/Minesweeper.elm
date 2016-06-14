module Pages.Minesweeper exposing (..)

import Array exposing (Array, fromList)
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
  [ [ (0, Closed (Mine NotBlown)), (1, Closed (Counter 2)), (2, Closed (Counter 1)), (3, Closed (Counter 1)), (4, Closed
  (Counter 1))  ]
  , [ (6, Closed (Mine NotBlown)), (7, Closed (Counter 3)), (8, Closed (Counter 3)), (9, Closed (Mine NotBlown)), (10,
  Closed (Counter 1)) ]
  , [ (11, Closed (Counter 1)), (12, Closed (Counter 1)), (13, Closed (Mine NotBlown)), (14, Closed (Mine NotBlown)), (15, Closed (Counter 1)) ]
  , [ (16, Closed (Counter 1)), (17, Closed (Counter 2)), (18, Closed (Counter 1)), (19, Closed (Counter 1)), (20, Closed
  (Counter 1)) ]
  , [ (21, Closed (Mine NotBlown)), (22, Closed (Counter 1)), (23, Closed Empty), (24, Closed Empty), (25, Closed Empty) ]
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
              ]
              [ button
                [ onClick <| RevealCell (id, c) ]
                [ text text' ]
              ]


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
      newRows : List (Int, Cell) -> List (Int, Cell)
      newRows row =
        List.map newCell row


      newCell : (Int, Cell) -> (Int, Cell)
      newCell (id, c) =
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

      (x, y) =
        (revealedId % boardWidth oldBoard, revealedId // boardWidth oldBoard)

      filledBoard =
        let
            targetCell =
               getCellInBoard (x, y) oldBoard
        in
            floodFill (x, y) targetCell (revealedId, revealedCell) oldBoard
  in
      List.map newRows filledBoard


floodFill : (Int, Int) -> Maybe (Int, Cell) -> (Int, Cell) -> Board -> Board
floodFill (x, y) targetCell replacementCell board =
  case getCellInBoard (x, y) board of
    Just (id, cell) ->
      case cell of
        Closed content ->
          case content of
            Mine _ -> board
            _ ->
              if (id, cell) /= replacementCell then
                let
                    board' = setCellInBoard (x, y) replacementCell board
                    boardN = floodFill (x, y - 1) targetCell replacementCell board'
                    boardNE = floodFill (x + 1, y - 1) targetCell replacementCell boardN

                    boardE = floodFill (x + 1, y) targetCell replacementCell boardNE
                    boardSE = floodFill (x + 1, y + 1) targetCell replacementCell boardE

                    boardS = floodFill (x, y + 1) targetCell replacementCell boardSE
                    boardSW = floodFill (x - 1, y + 1) targetCell replacementCell boardS

                    boardW = floodFill (x - 1, y) targetCell replacementCell boardSW
                    boardNW = floodFill (x - 1, y + 1) targetCell replacementCell boardW
                in
                    boardNW
              else
                board
        _ -> board

    Nothing ->
      board


boardAsArray : Board -> Array (Array (Int, Cell))
boardAsArray board =
  board
    |> List.map (\i -> Array.fromList i)
    |> Array.fromList


boardWidth : Board -> Int
boardWidth board =
  List.length <| List.concat (List.take 1 board)


getCellInBoard : (Int, Int) -> Board -> Maybe (Int, Cell)
getCellInBoard (x, y) board =
  let
      boardLength =
        List.length board
  in
      case (x >= 0, x <= boardWidth board, y >= 0, y <= boardLength) of
        (True, True, True, True) ->
          List.drop (y * boardLength + x) (List.concat board)
            |> List.head
        _ -> Nothing


setCellInBoard : (Int, Int) -> (Int, Cell) -> Board -> Board
setCellInBoard (x, y) targetCell board =
  let
      row r =
        List.map setCell r

      setCell (id, cell) =
        if (fst targetCell) == id then
          case cell of
            Closed content ->
              case content of
                Empty ->
                  (id, Revealed Empty)
                Counter n ->
                  (id, Revealed (Counter n))
                _ ->
                  (id, cell)

            _ -> (id, cell)
        else
          (id, cell)

  in
      List.map row board


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RevealCell (id, cell) ->
      case model.gameState of
        _ ->
          { model | board = newBoard model.board (id, cell) } ! [ Cmd.none ]

    RestartGame ->
      { model | board = initialBoard } ! [ Cmd.none ]

