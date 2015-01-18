module CounterPair where

import Counter
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Signal
import Controller

controller = Controller.new (init 0 0)

-- MODEL

type alias Model =
    { topCounter : Counter.Model
    , bottomCounter : Counter.Model
    }


init : Int -> Int -> Model
init top bottom =
    { topCounter = Counter.init top
    , bottomCounter = Counter.init bottom
    }


-- UPDATE

type alias Action = Model -> Model

reset : Action
reset model = init 0 0

updateTop : Counter.Action -> Action
updateTop counterAction model = 
  { model | topCounter <- (counterAction model.topCounter) }

updateBottom : Counter.Action -> Action
updateBottom counterAction model = 
  { model | bottomCounter <- (counterAction model.bottomCounter) }


-- VIEW

view : Model -> Html
view model =
  div []
    [ Counter.view (controller.childSend updateTop) model.topCounter
    , Counter.view (controller.childSend updateBottom) model.bottomCounter
    , button [ onClick (controller.send reset) ] [ text "RESET" ]
    ]


-- SIGNALS

main : Signal Html
main = controller.render view
