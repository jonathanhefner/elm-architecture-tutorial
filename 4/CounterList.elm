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
  { model | 
      counters <- ( model.nextID, Counter.init 0 ) :: model.counters,
      nextID <- model.nextID + 1 
  }

remove : ID -> Action
remove id model = 
  { model |
      counters <- List.filter (\(counterID, _) -> counterID /= id) model.counters
  }

modify : ID -> Counter.Action -> Action
modify id childAction model = 
  let updateCounter (counterID, counterModel) =
        if counterID == id
            then (counterID, childAction counterModel)
            else (counterID, counterModel)
  in
      { model | counters <- List.map updateCounter model.counters }


-- VIEW

view : Model -> Html
view model =
  let insertBtn = button [ onClick (controller.send insert) ] [ text "Add" ]
  in
      div [] (insertBtn :: List.map viewCounter model.counters)


viewCounter : (ID, Counter.Model) -> Html
viewCounter (id, model) =
  let context =
        Counter.Context
          (controller.childSend (modify id))
          (controller.send (remove id))
  in
      Counter.viewWithRemoveButton context model


-- SIGNALS

main : Signal Html
main = controller.render view
