module Graphics
  ( graphics
  , animate
  , module Data.Monoid
  , module Graphics.Drawing
  ) where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe(..))
import Data.Monoid (class Monoid, mempty) as Data.Monoid
import Graphics.Canvas ( CANVAS, CanvasElement, getContext2D, clearRect
                       , getCanvasWidth, getCanvasHeight )
import Graphics.Drawing (Drawing, render)
import Graphics.Drawing as Graphics.Drawing

foreign import animateImpl
  :: forall eff
   . (Number -> Eff eff Unit)
   -> Eff eff Unit

foreign import createCanvas
  :: forall eff
   . Eff (canvas :: CANVAS | eff) CanvasElement

graphics :: forall eff. Drawing -> Eff (canvas :: CANVAS | eff) Unit
graphics scene = do
  canvas <- createCanvas
  context <- getContext2D canvas
  width <- getCanvasWidth canvas
  height <- getCanvasHeight canvas
  clearRect context { x: 0.0, y: 0.0, w: width, h: height }
  render context scene

animate :: forall eff. (Number -> Drawing) -> Eff (canvas :: CANVAS | eff) Unit
animate f = animateImpl (f >>> graphics)
