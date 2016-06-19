# psci-experiment

An experiment to evaluate PSCi expressions in the browser.

## Instructions

- Build and bundle the code: `pulp build -O --to js/bundle.js`
- Build the custom version of PSCi which includes browser support (on the `psci-browser` branch of the `purescript` repository)
- Start PSCi: `pulp psci`
- Start a static webserver to serve resources: `python -m SimpleHTTPServer`
- Open `http://localhost:8000/` (PSCi should say `Browser connected`)
- Evaluate expressions in PSCi:

```purescript
> import Prelude
> import Graphics
> import Math
> animate \t -> translate 100.0 100.0 $ scale (sin t) (sin t) $ filled mempty $ rectangle (-50.0) (-50.0) 100.0 100.0
```
