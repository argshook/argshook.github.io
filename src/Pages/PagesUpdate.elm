module Pages.PagesUpdate exposing (..)


import Pages.Age as Age
import Pages.Minesweeper as Minesweeper
import Pages.BinaryTree as BinaryTree
import Pages.CategoryTree as CategoryTree
import Pages.FizzBuzz as FizzBuzz
import Pages.Blog.PostsList as PostsList
import Pages.Blog.Post as Post
import Pages.PagesMessages as Msg exposing (..)
import Pages.PagesModel as Model exposing (..)


-- TODO: how could i dry this up?
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    AgeMsg msg ->
      let
          (model', cmd) = Age.update msg model.ageModel
      in
          ({ model | ageModel = model' }, Cmd.map AgeMsg cmd)

    MinesweeperMsg msg ->
      let
          (model', cmd) = Minesweeper.update msg model.minesweeperModel
      in
          ({ model | minesweeperModel = model' }, Cmd.map MinesweeperMsg cmd)

    BinaryTreeMsg msg ->
      let
          (binaryTreeModel, binaryTreeCmd) = BinaryTree.update msg model.binaryTreeModel
      in
          ({ model | binaryTreeModel = binaryTreeModel }, Cmd.map BinaryTreeMsg binaryTreeCmd)

    CategoryTreeMsg msg ->
      let
          (categoryTreeModel, categoryTreeCmd) = CategoryTree.update msg model.categoryTreeModel
      in
          ({ model | categoryTreeModel = categoryTreeModel }, Cmd.map CategoryTreeMsg categoryTreeCmd)

    FizzBuzzMsg msg ->
      let
          (fizzBuzzModel, fizzBuzzCmd) = FizzBuzz.update msg model.fizzBuzzModel
      in
          ({ model | fizzBuzzModel = fizzBuzzModel }, Cmd.map FizzBuzzMsg fizzBuzzCmd)

    PostsListMsg msg ->
      let
          (postsListModel, postsListCmd, mainCmd) = PostsList.update msg model.postsListModel
      in
          { model | postsListModel = postsListModel } !
          [ Cmd.map PostsListMsg postsListCmd
          , mainCmd
          ]

    PostMsg msg ->
      let
          (postModel, postCmd) = Post.update msg model.postModel
      in
          ({ model | postModel = postModel }, Cmd.map PostMsg postCmd)

