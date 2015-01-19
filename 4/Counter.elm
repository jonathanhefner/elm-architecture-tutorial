module Counter (Model, init, view, viewWithRemoveButton, Context) where

import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Signal
import Controller (..)


-- MODEL

type alias Model = Int


init : Int -> Model
init count = count

-- UPDATE

increment : Action Model
increment model = model + 1

decrement : Action Model
decrement model = model - 1


-- VIEW

view : Enact Model -> View Model
view enact model =
  div []
    [ button [ onClick (enact decrement) ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick (enact increment) ] [ text "+" ]
    ]


type alias Context =
    { enact : Enact Model
    , removeIt : Signal.Message
    }


viewWithRemoveButton : Context -> Model -> Html
viewWithRemoveButton context model =
  div []
    [ button [ onClick (context.enact decrement) ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick (context.enact increment) ] [ text "+" ]
    , div [ countStyle ] []
    , button [ onClick context.removeIt ] [ text "X" ]
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
