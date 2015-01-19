-- TODO factor this out into a separate package
module Controller (Action, View, Enact, Controller, new) where 

import Signal
import Html (..)


type alias Action model = (model -> model)

type alias Enact model = (Action model -> Signal.Message)

type alias View model = (model -> Html)

type alias Controller model anyChild = 
  { initial : model
  , model : Signal model
  , enact : Enact model
  , childEnact : (Action anyChild -> Action model) -> Enact anyChild
  , render : View model -> Signal Html
  }

  
ident : a -> a
ident x = x

apply : (a -> a) -> a -> a
apply f x = f x

-- does this have an official name?
swapApply : (a -> b -> c) -> b -> a -> c
swapApply f x y = f y x

childSend : Signal.Channel (Action parent) -> 
            (Action child -> Action parent) -> 
            Enact child
childSend channel ca2pa ca = Signal.send channel (ca2pa ca)
  
new : model -> Controller model anyChild
new initial = 
  let actions = Signal.channel ident
      model = Signal.foldp apply initial (Signal.subscribe actions)
  in
      { initial = initial
      , model = model
      , enact = Signal.send actions
      , childEnact = childSend actions
      , render = swapApply Signal.map model
      }
