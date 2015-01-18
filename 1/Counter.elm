module Counter where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Signal
import Controller


controller = Controller.new 0


-- MODEL

type alias Model = Int


-- UPDATE

increment : Model -> Model
increment model = model + 1

decrement : Model -> Model
decrement model = model - 1


-- VIEW

view : Model -> Html
view model =
  div []
    [ button [ onClick (controller.send decrement) ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick (controller.send increment) ] [ text "+" ]
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
main = controller.render view
