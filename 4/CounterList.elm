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
view enact model =
  let insertBtn = button [ onClick (enact insert) ] [ text "Add" ]
  in
      div [] (insertBtn :: List.map (viewCounter enact) model.counters)


viewCounter : Enact Model -> (ID, Counter.Model) -> Html
viewCounter enact (id, model) =
  let context = Counter.Context (enact (remove id))
      lensedEnact = lensEnact (modify id) enact
  in
      Counter.viewWithRemoveButton context lensedEnact model


-- SIGNALS

main : Signal Html
main = render view init
