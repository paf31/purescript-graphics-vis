# psci-experiment

An experiment to evaluate PSCi expressions in the browser.

## Instructions

- Build the custom version of PSCi which includes browser support (on the `psci-browser` branch of the `purescript` repository)
- Start PSCi: `pulp psci`
- Open `http://localhost:9160/` (PSCi should say `Browser connected`)
- Evaluate expressions in PSCi:

```purescript
> import Graphics
> import Color
> animate \t -> filled (fillColor (hsl (t / 10.0) 0.75 0.5)) (circle 50.0 50.0 50.0)
```
