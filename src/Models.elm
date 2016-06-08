module Models exposing (..)

import Pages.Age as Age
import Pages.Forms as Forms
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz
import Pages.Blog.PostsList as PostsList


type alias Model =
  { ageModel : Age.Model
  , formsModel : Forms.Model
  , binaryTreeModel : BinaryTree.Model
  , categoryTreeModel : CategoryTree.Model
  , fizzBuzzModel : FizzBuzz.Model
  , postsListModel : PostsList.Model
  , state : State
  }


type State = Home | Binary | Forms | Category | FizzBuzz | Blog Int


initialModel : Model
initialModel =
  { ageModel = Age.initialModel
  , formsModel = Forms.initialModel
  , binaryTreeModel = BinaryTree.initialModel
  , categoryTreeModel = CategoryTree.initialModel
  , fizzBuzzModel = FizzBuzz.initialModel
  , postsListModel = PostsList.initialModel
  , state = Home
  }
