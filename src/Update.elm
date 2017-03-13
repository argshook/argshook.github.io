module Update exposing (..)


import Navigation
import Messages exposing (..)
import Model exposing (..)
import MyNavigation exposing (..)

import Pages.PagesUpdate exposing (..)


update : Messages.Msg -> Model -> (Model, Cmd Messages.Msg)
update msg model =
  case msg of
    PagesMessages msg ->
      let
          (model_, cmd) = Pages.PagesUpdate.update msg model.pagesModel
      in
          ({ model | pagesModel = model_ }, Cmd.map PagesMessages cmd)

    ChangeState newState ->
      { model | state = newState } ! [ Navigation.newUrl (toUrl newState) ]

    UrlChange location ->
      { model | history = location :: model.history } ! []

