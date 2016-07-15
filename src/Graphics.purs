module Graphics
  ( graphics
  , animate
  , average
  , bass
  , mids
  , treble
  , hue
  , sc
  , shape
  , scene
  , module Color
  , module Data.Monoid
  , module Graphics.Drawing
  , module Math
  , module Prelude
  ) where

import Prelude

import Color (Color, hsl)
import Color.Scheme.Harmonic (triad)
import Control.Monad.Eff (Eff)
import Data.Array (drop, length, take)
import Data.Foldable (fold, sum)
import Data.Int (toNumber)
import Data.Monoid (class Monoid, mempty) as Data.Monoid
import Graphics.Canvas ( CANVAS, CanvasElement, getContext2D
                       , getCanvasWidth, getCanvasHeight, setFillStyle
                       , save, restore, fillRect)
import Graphics.Drawing (Drawing, Shape, render, circle, translate, outlined, outlineColor, lineWidth, filled)
import Graphics.Drawing as Graphics.Drawing
import Math (Radians, abs, acos, asin, atan, atan2, ceil, cos, e, exp, floor, ln10, ln2, log, log10e, log2e, pi, pow, remainder, round, sin, sqrt, sqrt1_2, sqrt2, tan, trunc, (%))

type FFT = Array Number

foreign import animateImpl
  :: forall eff
   . (Number -> FFT -> Eff eff Unit)
   -> Eff eff Unit

foreign import createCanvas
  :: forall eff
   . Eff (canvas :: CANVAS | eff) CanvasElement

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

animate :: forall eff. (Number -> FFT -> Drawing) -> Eff (canvas :: CANVAS | eff) Unit
animate f = animateImpl (\t fft -> graphics (f t fft))

average :: FFT -> Number
average xs = sum xs / toNumber (length xs)

bass :: FFT -> Number
bass fft = average (take 8 fft) / 48.0

mids :: FFT -> Number
mids fft = average (take 8 (drop 4 fft)) / 48.0

treble :: FFT -> Number
treble fft = average (take 8 (drop 8 fft)) / 12.0

hue :: FFT -> Color
hue fft = hsl (bass fft * 128.0) (0.5) (0.5)

sc :: Number -> Drawing -> Drawing
sc t = Graphics.Drawing.scale t t

shape :: Shape
shape = circle 0.0 0.0 50.0


scene :: Number -> FFT -> Drawing
scene t fft =
    case triad (hue fft) of
      [c1, c2, c3] ->
        fold
          [ translate
              (sin (t / 250.0) * 40.0 + 400.0)
              (cos (t / 200.0) * 40.0 + 400.0)
              (sc (bass fft + 0.5)
                  (outlined (outlineColor c1 <> lineWidth (bass fft)) shape))
          , translate
              (sin (t / 350.0) * 40.0 + 400.0)
              (cos (t / 300.0) * 40.0 + 400.0)
              (sc (mids fft + 0.5)
                  (outlined (outlineColor c2 <> lineWidth (mids fft)) shape))
          , translate
              (sin (t / 450.0) * 40.0 + 400.0)
              (cos (t / 400.0) * 40.0 + 400.0)
              (sc (treble fft + 0.5)
                  (outlined (outlineColor c3 <> lineWidth (treble fft)) shape))
          , satellite 400.0
          , satellite 450.0
          , satellite 500.0
          ]
      _ -> Data.Monoid.mempty
  where
    satellite :: Number -> Drawing
    satellite offset =
      translate
        (sin (t / offset) * 200.0 + 400.0)
        (cos (t / (offset + 50.0)) * 200.0 + 400.0)
        (sc (mids fft / 10.0 + 0.05)
            (filled Data.Monoid.mempty shape))
