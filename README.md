# psci-experiment

An experiment to evaluate PSCi expressions in the browser.

## Instructions

- Install the latest (>= 0.9.2) PSCi.
- Start PSCi with the `--port` option: `pulp psci --port 8080`
- Open `http://localhost:8080/`
- Evaluate expressions in PSCi:

```purescript
> import Graphics
> animate \t _ -> filled (fillColor (hsl (t / 10.0) 0.75 0.5)) (circle 50.0 50.0 50.0)
```
