module Update exposing (..)


import Navigation
import Messages exposing (..)
import Model exposing (..)
import MyNavigation exposing (..)
import States exposing (..)

import Pages.PagesUpdate exposing (..)
import Pages.PagesMessages exposing (..)


update : Messages.Msg -> Model -> (Model, Cmd Messages.Msg)
update msg model =
  case msg of
    PagesMessages msg ->
      let
          (model', cmd) = Pages.PagesUpdate.update msg model.pagesModel
      in
          ({ model | pagesModel = model' }, Cmd.map PagesMessages cmd)

    ChangeState newState ->
      { model | state = newState } ! [ Navigation.newUrl (toUrl newState) ]

