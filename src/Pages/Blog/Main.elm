module Pages.Blog.Main exposing (..)


import Html exposing (..)

view model =
  text <| "hello" ++ toString model.state
