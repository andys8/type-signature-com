# PureScript

- Generate with `spago docs -f markdown`
- Delete lines with `sed '/ :: /!d' prelude_source.md > prelude.txt`
- Delete `instance`
- Delete spaces
- Delete explicit forall: `s/forall .*\. //g`
- Sort
