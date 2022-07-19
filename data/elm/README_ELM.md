# Elm

## Instructions

Download <https://package.elm-lang.org/packages/elm/core/1.0.5/docs.json> to `core_source.json`

```shell
jq -r 'map(.values,.binops)[] | .[]|[.name,.type]|join(" :: ")' core_source.json > core.txt
sort -o core.txt core.txt
```

### Vim

- `%s/[A-Z][a-z]*\.//`
- `%s/( /(/g`
- `%s/ )/)/g`
