module DateTest exposing (..)

import Expect
import Pages.Blog.Date exposing (..)
import Test exposing (..)


suite : Test
suite =
    test "pad" <|
        \_ ->
            pad 1
                |> Expect.equal "01"
