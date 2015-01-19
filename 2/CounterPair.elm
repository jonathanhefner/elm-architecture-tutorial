module CounterPair where

import Counter
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Signal
import Controller
import Controller (..)

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

reset : Action Model
reset model = init 0 0

updateTop : Action Counter.Model -> Action Model
updateTop counterAction model = 
  { model | topCounter <- (counterAction model.topCounter) }

updateBottom : Action Counter.Model -> Action Model
updateBottom counterAction model = 
  { model | bottomCounter <- (counterAction model.bottomCounter) }


-- VIEW

view : View Model
view model =
  div []
    [ Counter.view (controller.childEnact updateTop) model.topCounter
    , Counter.view (controller.childEnact updateBottom) model.bottomCounter
    , button [ onClick (controller.enact reset) ] [ text "RESET" ]
    ]


-- SIGNALS

main : Signal Html
main = controller.render view
