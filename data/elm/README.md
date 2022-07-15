# Elm

## Instructions

Download <https://package.elm-lang.org/packages/elm/core/1.0.5/docs.json> to `core.json`

```shell
jq -r 'map(.values)[] | .[]|[.name,.type]|join(" :: ")' core.json > core.txt
```
