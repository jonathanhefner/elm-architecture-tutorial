module Counter (Model, init, Action, view) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Signal


-- MODEL

type alias Model = Int


init : Int -> Model
init count = count


-- UPDATE

type alias Action = Model -> Model

increment : Action
increment model = model + 1

decrement : Action
decrement model = model - 1


-- VIEW

view : (Action -> Signal.Message) -> Model -> Html
view send model =
  div []
    [ button [ onClick (send decrement) ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick (send increment) ] [ text "+" ]
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
