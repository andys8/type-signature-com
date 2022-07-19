# Elm

## Instructions

Download <https://package.elm-lang.org/packages/elm/core/1.0.5/docs.json> to `core_source.json`

```shell
jq -r 'map(.values)[] | .[]|[.name,.type]|join(" :: ")' core_source.json > core.txt
jq -r 'map(.binops)[] | .[]|[.name,.type]|join(" :: ")' core_source.json >> core.txt
```

- Manually append parens to operators
- Vim remove prefix in types: `%s/[A-Z][a-z]*\.//`
- Vim remove parens `%s/( /(/g` and `%s/ )/)/g`
- Make unique and sort `sort -u -o prelude.txt prelude.txt`
