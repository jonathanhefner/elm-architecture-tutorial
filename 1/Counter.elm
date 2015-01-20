module Counter where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Signal
import Controller (..)


-- MODEL

type alias Model = Int


-- UPDATE

increment : Action Model
increment model = model + 1

decrement : Action Model
decrement model = model - 1


-- VIEW

view : View Model
view enact model =
  div []
    [ button [ onClick (enact decrement) ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick (enact increment) ] [ text "+" ]
    ]


countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]


-- SIGNALS

main : Signal Html
main = render view 0
