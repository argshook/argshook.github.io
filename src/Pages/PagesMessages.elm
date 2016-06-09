module Pages.PagesMessages exposing (..)


import Pages.Age as Age
import Pages.Forms as Forms
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz
import Pages.Blog.PostsList as PostsList
import Pages.Blog.Post as Post


type Msg
  = AgeMsg Age.Msg
  | FormsMsg Forms.Msg
  | BinaryTreeMsg BinaryTree.Msg
  | CategoryTreeMsg CategoryTree.Msg
  | FizzBuzzMsg FizzBuzz.Msg
  | PostsListMsg PostsList.Msg
  | PostMsg Post.Msg

