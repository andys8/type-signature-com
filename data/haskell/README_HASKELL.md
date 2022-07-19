# Haskell

## Instructions

- Download from <https://hackage.haskell.org/packages/hoogle.tar.gz>
- Or <https://hackage.haskell.org/package/base-4.16.2.0/docs/base.txt>
- Delete comments: `g/--/d`
- Delete empty lines: `g/^$/d`
- Delete lines with `module|type|instance|class|infix|newtype|data` in Vim `:g/^infix/d`
- Delete explicit forall: `%s/forall .*\. //g`
- Delete constructors: `g/^[A-Z]/d`
- Delete in brackets: `g/^\[/d`
- Make unique and sort `sort -u -o functions.txt functions.txt`
