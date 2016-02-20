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
  | generateBadge is the callback method for the event listener of the button.
  | It will generate a random name to show on our badge.
-}
generateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
generateBadge event = setBadgeName "Anne Bonney"

{-|
  | main is the entry point of this program. Its sole purpose is to add event
  | listeners to the button and the input field.
-}
main :: forall eff. Eff (dom :: DOM | eff) Unit
main = do
    querySelector "#inputName" >>= unsafeAddEventListener "input" updateBadge
    querySelector "#generateButton" >>= unsafeAddEventListener "click" generateBadge

{-|
  | querySelector is a shorthand function to select an element from the global
  | document using a query.
-}
querySelector :: forall eff. String -> Eff (dom :: DOM | eff) HTMLElement
querySelector query = unsafeDocument globalWindow >>= unsafeQuerySelector query

{-|
  | setBadgeName sets the name of the Badge and calls 'disableIfEmpty'
  | afterwards.
-}
setBadgeName :: forall eff. String -> Eff (dom :: DOM | eff) Unit
setBadgeName name = do
    badge <- querySelector "#badgeName"
    button <- querySelector "#generateButton"
    unsafeSetTextContent name badge
    unsafeTextContent badge >>= disableIfEmpty button

{-|
  | updateBadge is the callback method for the event listener of the input
  | field. It will display the value of the input field on the badge.
-}
updateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
updateBadge event = unsafeEventTarget event >>= unsafeValue >>= setBadgeName

{-|
  | disableIfEmpty disables a provided HTMLElement if the *content* string is
  | empty.
-}
disableIfEmpty :: forall eff. HTMLElement -> String -> Eff (dom :: DOM | eff) Unit
disableIfEmpty button content = if eq content "" then do
        unsafeSetTextContent "Aye! Gimme a name!" button
        unsafeRemoveAttribute "disabled" button
    else do
        unsafeSetTextContent "Arrr! Write yer name!" button
        unsafeSetAttribute "disabled" "true" button

