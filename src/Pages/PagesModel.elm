module Pages.PagesModel exposing (..)

import Pages.Age as Age
import Pages.Minesweeper as Minesweeper
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz
import Pages.Blog.PostsListModel as PostsListModel
import Pages.Blog.PostModel as PostModel


type alias Model =
  { ageModel : Age.Model
  , minesweeperModel : Minesweeper.Model
  , binaryTreeModel : BinaryTree.Model
  , categoryTreeModel : CategoryTree.Model
  , fizzBuzzModel : FizzBuzz.Model
  , postsListModel : PostsListModel.Model
  , postModel : PostModel.Model
  }


initialModel : Model
initialModel =
  { ageModel = Age.initialModel
  , minesweeperModel = Minesweeper.initialModel
  , binaryTreeModel = BinaryTree.initialModel
  , categoryTreeModel = CategoryTree.initialModel
  , fizzBuzzModel = FizzBuzz.initialModel
  , postsListModel = PostsListModel.initialModel
  , postModel = PostModel.initialModel
  }


