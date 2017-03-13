module Pages.PagesView exposing (..)


import Html
import Html exposing (..)
import Html.Attributes exposing (..)


import Pages.Minesweeper as Minesweeper
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz

import Pages.Blog.Post as Post
import Pages.Blog.PostsList as PostsList


import Pages.PagesModel as PagesModel exposing (..)
import Pages.PagesMessages as PagesMessages exposing (..)
import States exposing (..)


view : Model -> State -> Html Msg
view model state =
  let
      component =
        case state of
          Home ->
            Html.map PostsListMsg (PostsList.view model.postsListModel)

          Binary ->
            Html.map PagesMessages.BinaryTreeMsg (BinaryTree.view model.binaryTreeModel)

          Category ->
            Html.map PagesMessages.CategoryTreeMsg (CategoryTree.view model.categoryTreeModel)

          FizzBuzz ->
            Html.map PagesMessages.FizzBuzzMsg (FizzBuzz.view model.fizzBuzzModel)

          Blog _ ->
            Html.map PostMsg (Post.view model.postModel)

          Minesweeper ->
            Html.map PagesMessages.MinesweeperMsg (Minesweeper.view model.minesweeperModel)

  in
    div
      [ class "page-content" ]
      [ component ]

