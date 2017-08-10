module Post.Date exposing (DateInterface, postDate)

import Date


type alias DateInterface =
    { date : String
    , time : String
    }


pad : Int -> String
pad n =
    if n < 10 then
        "0" ++ toString n
    else
        toString n


postDate : Maybe Int -> DateInterface
postDate timestamp =
    let
        fromTime =
            Maybe.withDefault 0 timestamp
                |> toFloat
                |> Date.fromTime

        date =
            [ toString <| Date.year fromTime
            , toString <| Date.month fromTime
            , toString <| Date.day fromTime
            ]
                |> String.join " "

        time =
            [ pad <| Date.hour fromTime
            , pad <| Date.minute fromTime
            ]
                |> String.join ":"
    in
        DateInterface date time
