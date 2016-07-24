module Pages.PagesMessages exposing (..)


import Pages.Age as Age
import Pages.Minesweeper as Minesweeper
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz
import Pages.Blog.PostsListMsg as PostsListMsg
import Pages.Blog.PostMsg as PostMsg


type Msg
  = AgeMsg Age.Msg
  | MinesweeperMsg Minesweeper.Msg
  | BinaryTreeMsg BinaryTree.Msg
  | CategoryTreeMsg CategoryTree.Msg
  | FizzBuzzMsg FizzBuzz.Msg
  | PostsListMsg PostsListMsg.Msg
  | PostMsg PostMsg.Msg

