module Main where

import Control.Monad.Eff
import Data.DOM.Simple.Unsafe.Element
import Data.DOM.Simple.Unsafe.Events
import Data.DOM.Simple.Unsafe.Window
import Data.DOM.Simple.Types
import Data.DOM.Simple.Window
import DOM
import Prelude

{-|
    main is the entry point of this program. Its sole purpose is to add an event
    listener to the input field.
-}
main :: forall eff. Eff (dom :: DOM | eff) Unit
main = do
    element <- unsafeDocument globalWindow >>= unsafeQuerySelector "#inputName"
    unsafeAddEventListener "input" updateBadge element

{-|
    updateBadge is the callback method for the event listener of the input
    field. It will display the value of the input field on the badge.
-}
updateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
updateBadge event = do
    badge <- unsafeDocument globalWindow >>= unsafeQuerySelector "#badgeName"
    input <- unsafeEventTarget event >>= unsafeValue
    unsafeSetTextContent input badge
