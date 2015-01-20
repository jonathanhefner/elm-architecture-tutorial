-- TODO factor this out into a separate package
module Controller (Action, Enact, lensEnact, View, render) where 

import Signal
import Html (..)


type alias Action model = (model -> model)

type alias Enact model = (Action model -> Signal.Message)

lensEnact : (Action b -> Action a) -> Enact a -> Enact b
lensEnact b2a enactA b = enactA (b2a b)

type alias View model = (Enact model -> model -> Html)

render : View model -> model -> Signal Html
render view initial = 
  let actions = Signal.channel ident
      model = Signal.foldp apply initial (Signal.subscribe actions)
      enact = Signal.send actions
  in
      Signal.map (view enact) model
  
ident : a -> a
ident x = x

apply : (a -> a) -> a -> a
apply f x = f x
