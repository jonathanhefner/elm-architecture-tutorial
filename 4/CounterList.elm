module CounterList where

import Counter
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import List
import Signal
import Controller
import Controller (..)

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

insert : Action Model
insert model = 
  { model | 
      counters <- ( model.nextID, Counter.init 0 ) :: model.counters,
      nextID <- model.nextID + 1 
  }

remove : ID -> Action Model
remove id model = 
  { model |
      counters <- List.filter (\(counterID, _) -> counterID /= id) model.counters
  }

modify : ID -> Action Counter.Model -> Action Model
modify id childAction model = 
  let updateCounter (counterID, counterModel) =
        if counterID == id
            then (counterID, childAction counterModel)
            else (counterID, counterModel)
  in
      { model | counters <- List.map updateCounter model.counters }


-- VIEW

view : View Model
view model =
  let insertBtn = button [ onClick (controller.enact insert) ] [ text "Add" ]
  in
      div [] (insertBtn :: List.map viewCounter model.counters)


viewCounter : View (ID, Counter.Model)
viewCounter (id, model) =
  let context =
        Counter.Context
          (controller.childEnact (modify id))
          (controller.enact (remove id))
  in
      Counter.viewWithRemoveButton context model


-- SIGNALS

main : Signal Html
main = controller.render view
