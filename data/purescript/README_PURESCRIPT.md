# PureScript

- Generate with `spago docs --deps-only -f markdown`
- Select some files and copy in `source`
- `cat source/*.md > functions.txt`
- Delete lines with `sed -i '/ :: /!d' functions.txt`
- Delete all functions from instances `:g/^ /d` because missing constraint
- Delete instance: `g/^instance /d`
- Delete lines beginning with asterisk: `:g/^\*/d`
- Delete lines with multiple `::`: `:g/::.*::/d`
- Delete explicit forall: `:%s/forall .*\. //g`
- Delete derives: `g/^derive /d`
- Drop examples like splitAt that are failing tests
- Make unique and sort `sort -u -o prelude.txt prelude.txt`
