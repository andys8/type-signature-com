# Elm

## Instructions

Download <https://package.elm-lang.org/packages/elm/core/1.0.5/docs.json> to `core_source.json`

```shell
jq -r 'map(.values)[] | .[]|[.name,.type]|join(" :: ")' core_source.json > core.txt
jq -r 'map(.binops)[] | .[]|[.name,.type]|join(" :: ")' core_source.json >> core.txt
# Manually append parens to opperators here
```

### Vim

- `%s/[A-Z][a-z]*\.//`
- `%s/( /(/g`
- `%s/ )/)/g`
- Sort
