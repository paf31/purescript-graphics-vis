module Graphics (graphics, animate, module M) where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe(..))
import Data.Monoid (class Monoid, mempty) as M
import Graphics.Canvas (CANVAS, getContext2D, getCanvasElementById, clearRect)
import Graphics.Drawing (Drawing, render)
import Graphics.Drawing (Color, Drawing, FillStyle, Font, OutlineStyle, Point, Shadow, Shape, ColorSpace(HSL, LCh, Lab, RGB), black, brightness, circle, clipped, closed, complementary, contrast, cssStringHSLA, cssStringRGBA, darken, desaturate, distance, everywhere, fillColor, filled, fontString, fromHexString, fromInt, graytone, hsl, hsla, isLight, isReadable, lab, lch, lighten, lineWidth, luminance, mix, outlineColor, outlined, path, rectangle, render, rgb, rgb', rgba, rgba', rotate, rotateHue, saturate, scale, shadow, shadowBlur, shadowColor, shadowOffset, text, textColor, toGray, toHSLA, toHexString, toLCh, toLab, toRGBA, toRGBA', toXYZ, translate, white, xyz) as M
import Partial.Unsafe (unsafePartial)

foreign import animateImpl
  :: forall eff
   . (Number -> Eff eff Unit)
   -> Eff eff Unit

graphics :: forall eff. Drawing -> Eff (canvas :: CANVAS | eff) Unit
graphics scene = unsafePartial do
  Just canvas <- getCanvasElementById "canvas"
  context <- getContext2D canvas
  clearRect context { x: 0.0, y: 0.0, w: 600.0, h: 600.0 }
  render context scene

animate :: forall eff. (Number -> Drawing) -> Eff (canvas :: CANVAS | eff) Unit
animate f = animateImpl (f >>> graphics)
