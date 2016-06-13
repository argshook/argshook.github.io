module Pages.PagesMessages exposing (..)


import Pages.Age as Age
import Pages.Minesweeper as Minesweeper
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz
import Pages.Blog.PostsList as PostsList
import Pages.Blog.Post as Post


type Msg
  = AgeMsg Age.Msg
  | MinesweeperMsg Minesweeper.Msg
  | BinaryTreeMsg BinaryTree.Msg
  | CategoryTreeMsg CategoryTree.Msg
  | FizzBuzzMsg FizzBuzz.Msg
  | PostsListMsg PostsList.Msg
  | PostMsg Post.Msg

