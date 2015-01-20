module CounterList where

import Counter
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import List
import Signal
import Controller
import Controller (..)


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
  let newCounter = ( model.nextID, Counter.init 0 )
      newCounters = model.counters ++ [ newCounter ]
  in
      { model | counters <- newCounters, nextID <- model.nextID + 1 }

remove : Action Model
remove model = { model | counters <- List.drop 1 model.counters }

modify : ID -> Action Counter.Model -> Action Model
modify id counterAction model = 
  let updateCounter (counterID, counterModel) =
        if counterID == id
            then (counterID, counterAction counterModel)
            else (counterID, counterModel)
  in
      { model | counters <- List.map updateCounter model.counters }


-- VIEW

view : View Model
view enact model =
  let counters = List.map (viewCounter enact) model.counters
      removeBtn = button [ onClick (enact remove) ] [ text "Remove" ]
      insertBtn = button [ onClick (enact insert) ] [ text "Add" ]
  in
      div [] ([removeBtn, insertBtn] ++ counters)


viewCounter : Enact Model -> (ID, Counter.Model) -> Html
viewCounter enact (id, model) =
  Counter.view (lensEnact (modify id) enact) model


-- SIGNALS

main : Signal Html
main = render view init
