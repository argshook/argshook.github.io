module Models exposing (..)

import Pages.Age as Age
import Pages.Forms as Forms
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz


type alias Model =
  { ageModel : Age.Model
  , formsModel : Forms.Model
  , binaryTreeModel : BinaryTree.Model
  , categoryTreeModel : CategoryTree.Model
  , fizzBuzzModel : FizzBuzz.Model
  , state : State
  }


type State = Home | Binary | Forms | Category | FizzBuzz


initialModel : Model
initialModel =
  { ageModel = Age.initialModel
  , formsModel = Forms.initialModel
  , binaryTreeModel = BinaryTree.initialModel
  , categoryTreeModel = CategoryTree.initialModel
  , fizzBuzzModel = FizzBuzz.initialModel
  , state = Home
  }

