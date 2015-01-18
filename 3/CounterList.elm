module CounterList where

import Counter
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import List
import Signal
import Controller

controller = Controller.new init

-- MODEL

type alias Model =
    { counters : List ( ID, Counter.Model )
    , nextID : ID
    }

type alias ID = Int


init : Model
init =
    { counters = []
    , nextID = 0
    }


-- UPDATE

type alias Action = Model -> Model

insert : Action
insert model = 
  let newCounter = ( model.nextID, Counter.init 0 )
      newCounters = model.counters ++ [ newCounter ]
  in
      { model | counters <- newCounters, nextID <- model.nextID + 1 }

remove : Action
remove model = { model | counters <- List.drop 1 model.counters }

modify : ID -> Counter.Action -> Action
modify id counterAction model = 
  let updateCounter (counterID, counterModel) =
        if counterID == id
            then (counterID, counterAction counterModel)
            else (counterID, counterModel)
  in
      { model | counters <- List.map updateCounter model.counters }


-- VIEW

view : Model -> Html
view model =
  let counters = List.map viewCounter model.counters
      removeBtn = button [ onClick (controller.send remove) ] [ text "Remove" ]
      insertBtn = button [ onClick (controller.send insert) ] [ text "Add" ]
  in
      div [] ([removeBtn, insertBtn] ++ counters)


viewCounter : (ID, Counter.Model) -> Html
viewCounter (id, model) =
  Counter.view (controller.childSend (modify id)) model


-- SIGNALS

main : Signal Html
main = controller.render view
