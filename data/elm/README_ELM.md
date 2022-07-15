# Elm

## Instructions

Download <https://package.elm-lang.org/packages/elm/core/1.0.5/docs.json> to `core.json`

```shell
jq -r 'map(.values)[] | .[]|[.name,.type]|join(" :: ")' core.json > core.txt
sort -o core.txt core.txt
```

### Vim

- `:%s/Array\.//g`
- `:%s/Basics\.//g`
- `:%s/Char\.//g`
- `:%s/Dict\.//g`
- `:%s/Float\.//g`
- `:%s/List\.//g`
- `:%s/Maybe\.//g`
- `:%s/Result\.//g`
- `:%s/String\.//g`
- `:%s/Task\.//g`
- `:%s/Platform\.//g`
- `:%s/Program\.//g`
- `:%s/Set\.//g`
- `:%s/Sub\.//g`
- `:%s/Task\.//g`
- `:%s/Cmd\.//g`
- `%s/( /(/g`
- `%s/ )/)/g`
