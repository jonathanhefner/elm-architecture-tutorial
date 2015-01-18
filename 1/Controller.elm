module Controller (new) where 

import Signal
import Html (..)


-- TODO factor this out into a separate package

{- TODO use parametric type aliases to clean things up:

type alias Action model = (model -> model)

type alias NestedAction child parent = (Action child -> Action parent)

type alias View model = (model -> Html)

type alias Send model = (Action model -> Signal.Message)

type alias Controller model = 
  { initial : model
  , model : Signal model
  , send : Send model
  , childSend : NestedAction child model -> Send child
  , render : View model -> Signal Html
  }
  
-}

  
ident : a -> a
ident x = x

apply : (a -> a) -> a -> a
apply f x = f x

-- does this have an official name?
swapApply : (a -> b -> c) -> b -> a -> c
swapApply f x y = f y x

childSend : Signal.Channel parentAction -> (childAction -> parentAction) -> childAction -> Signal.Message
childSend channel ca2pa ca = Signal.send channel (ca2pa ca)
  
new : m -> { initial : m
           , model : Signal m
           , send : (m -> m) -> Signal.Message
           , childSend : ((c -> c) -> m -> m) -> (c -> c) -> Signal.Message
           , render : (m -> Html) -> Signal Html
           }
new initial = 
  let actions = Signal.channel ident
      model = Signal.foldp apply initial (Signal.subscribe actions)
  in
      { initial = initial
      , model = model
      , send = Signal.send actions
      , childSend = childSend actions
      , render = swapApply Signal.map model
      }
