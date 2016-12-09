module Graphics.Vis.Example
  ( scene
  , module Graphics.Vis
  ) where

import Prelude

import Color (Color, hsl)
import Color.Scheme.Harmonic (triad)
import Data.Foldable (fold)
import Data.Monoid (mempty) as Data.Monoid
import Graphics.Vis (FFT, animate, graphics, bass, mids, treble)
import Graphics.Drawing (Drawing, Shape, circle, filled, lineWidth, outlineColor, outlined, translate)
import Graphics.Drawing as Graphics.Drawing
import Math (cos, sin)

-- | Test this in PSCi by importing this module and
-- | evaluating `animate scene`.
scene :: Number -> FFT -> Drawing
scene t fft =
    case triad hue of
      [c1, c2, c3] ->
        fold
          [ translate
              (sin (t / 250.0) * 40.0 + 400.0)
              (cos (t / 200.0) * 40.0 + 400.0)
              (scale' (bass fft + 0.5)
                      (outlined (outlineColor c1 <> lineWidth (bass fft)) shape))
          , translate
              (sin (t / 350.0) * 40.0 + 400.0)
              (cos (t / 300.0) * 40.0 + 400.0)
              (scale' (mids fft + 0.5)
                      (outlined (outlineColor c2 <> lineWidth (mids fft)) shape))
          , translate
              (sin (t / 450.0) * 40.0 + 400.0)
              (cos (t / 400.0) * 40.0 + 400.0)
              (scale' (treble fft + 0.5)
                      (outlined (outlineColor c3 <> lineWidth (treble fft)) shape))
          , satellite 400.0
          , satellite 450.0
          , satellite 500.0
          ]
      _ -> Data.Monoid.mempty
  where
    shape :: Shape
    shape = circle 0.0 0.0 50.0

    scale' :: Number -> Drawing -> Drawing
    scale' s = Graphics.Drawing.scale s s

    hue :: Color
    hue = hsl (bass fft * 128.0) (0.5) (0.5)

    satellite :: Number -> Drawing
    satellite offset =
      translate
        (sin (t / offset) * 200.0 + 400.0)
        (cos (t / (offset + 50.0)) * 200.0 + 400.0)
        (scale' (mids fft / 10.0 + 0.05)
                (filled Data.Monoid.mempty shape))
