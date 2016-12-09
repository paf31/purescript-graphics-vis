module Graphics.Vis
  ( FFT
  , graphics
  , animate
  , bass
  , mids
  , treble
  , module Color
  , module Data.Monoid
  , module Graphics.Drawing
  , module Math
  , module Prelude
  ) where

import Prelude
import Graphics.Drawing as Graphics.Drawing
import Color (Color, hsl)
import Control.Monad.Eff (Eff)
import Data.Array (drop, length, take)
import Data.Foldable (sum)
import Data.Int (toNumber)
import Data.Monoid (class Monoid, mempty) as Data.Monoid
import Graphics.Canvas (CANVAS, CanvasElement, getContext2D, getCanvasWidth, getCanvasHeight, setFillStyle, save, restore, fillRect)
import Graphics.Drawing (Drawing, Shape, render, circle, translate, outlined, outlineColor, lineWidth, filled)
import Math (Radians, abs, acos, asin, atan, atan2, ceil, cos, e, exp, floor, ln10, ln2, log, log10e, log2e, pi, pow, remainder, round, sin, sqrt, sqrt1_2, sqrt2, tan, trunc, (%))

-- | A frequency spectrum from the WebAudio API.
type FFT = Array Number

foreign import animateImpl
  :: forall eff
   . (Number -> FFT -> Eff eff Unit)
   -> Eff eff Unit

foreign import createCanvas
  :: forall eff
   . Eff (canvas :: CANVAS | eff) CanvasElement

-- | Render a drawing to the browser canvas, replacing any
-- | existing drawing.
graphics :: forall eff. Drawing -> Eff (canvas :: CANVAS | eff) Unit
graphics scene' = do
  canvas <- createCanvas
  context <- getContext2D canvas
  width <- getCanvasWidth canvas
  height <- getCanvasHeight canvas
  save context
  setFillStyle "rgba(255,255,255,0.1)" context
  fillRect context { x: 0.0, y: 0.0, w: width, h: height }
  restore context
  render context scene'

-- | Render an animation which depends on the current time
-- | and audio input.
animate :: forall eff. (Number -> FFT -> Drawing) -> Eff (canvas :: CANVAS | eff) Unit
animate f = animateImpl (\t fft -> graphics (f t fft))

average :: FFT -> Number
average xs = sum xs / toNumber (length xs)

-- | Get a value which represents the bass level in the input audio.
bass :: FFT -> Number
bass fft = average (take 8 fft) / 48.0

-- | Get a value which represents the mids level in the input audio.
mids :: FFT -> Number
mids fft = average (take 8 (drop 4 fft)) / 48.0

-- | Get a value which represents the treble level in the input audio.
treble :: FFT -> Number
treble fft = average (take 8 (drop 8 fft)) / 12.0
