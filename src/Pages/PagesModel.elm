module Pages.PagesModel exposing (..)

import Pages.Age as Age
import Pages.Minesweeper as Minesweeper
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz
import Pages.Blog.PostsList as PostsList
import Pages.Blog.Post as Post


type alias Model =
  { ageModel : Age.Model
  , minesweeperModel : Minesweeper.Model
  , binaryTreeModel : BinaryTree.Model
  , categoryTreeModel : CategoryTree.Model
  , fizzBuzzModel : FizzBuzz.Model
  , postsListModel : PostsList.Model
  , postModel : Post.Model
  }


initialModel : Model
initialModel =
  { ageModel = Age.initialModel
  , minesweeperModel = Minesweeper.initialModel
  , binaryTreeModel = BinaryTree.initialModel
  , categoryTreeModel = CategoryTree.initialModel
  , fizzBuzzModel = FizzBuzz.initialModel
  , postsListModel = PostsList.initialModel
  , postModel = Post.initialModel
  }


