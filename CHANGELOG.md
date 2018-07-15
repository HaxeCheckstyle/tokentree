## dev branch / next version (1.x.x)

- Added `TokenTreeCheckUtils.isTypeEnumAbstract` [#16](https://github.com/HaxeCheckstyle/tokentree/issues/16)
- Added FieldUtils [#17](https://github.com/HaxeCheckstyle/tokentree/issues/17)
- Added `isComment` and `isCIdent` to `TokentTreeAccessHelper` [#23](https://github.com/HaxeCheckstyle/tokentree/issues/23)
- Added `TokenTreeCheckUtils.isOpGtTypedefExtension` [#24](https://github.com/HaxeCheckstyle/tokentree/issues/24)
- Added `TokenTreeCheckUtils.isBrOpenAnonTypeOrTypedef` [#26](https://github.com/HaxeCheckstyle/tokentree/issues/26)
- Fixed `@:default` [#18](https://github.com/HaxeCheckstyle/tokentree/issues/18)
- Fixed position of `cast` children [#19](https://github.com/HaxeCheckstyle/tokentree/issues/19)
- Fixed position of comments in `case`/`default` [#20](https://github.com/HaxeCheckstyle/tokentree/issues/20)
- Fixed error handling to work with `--no-inline` [#21](https://github.com/HaxeCheckstyle/tokentree/issues/21)
- Fixed position of BinOp() in anon objects [#22](https://github.com/HaxeCheckstyle/tokentree/issues/22)
- Fixed ternary handling [#25](https://github.com/HaxeCheckstyle/tokentree/issues/25)
- Changed isImport to also incluide `using` [#20](https://github.com/HaxeCheckstyle/tokentree/issues/20)

## version 1.0.5 (2018-07-08)

- Added support for `enum abstract` [#14](https://github.com/HaxeCheckstyle/tokentree/issues/14)
- Added support for `@:a.b.c` [#14](https://github.com/HaxeCheckstyle/tokentree/issues/14)
- Added support for `var ?x:Int` [#14](https://github.com/HaxeCheckstyle/tokentree/issues/14)
- Added support for `extern` fields [#14](https://github.com/HaxeCheckstyle/tokentree/issues/14)
- Changed position of Dot in method chains [#15](https://github.com/HaxeCheckstyle/tokentree/issues/15)

## version 1.0.4 (2018-06-30)

- Added parent and sibling access methods to TokenTreeAccessHelper [#10](https://github.com/HaxeCheckstyle/tokentree/issues/10)
- Added support for haxeparser's whitespace (`-D keep_whitespace`) [#12](https://github.com/HaxeCheckstyle/tokentree/issues/12)
- Fixed handling of `if`, `while` and `do`…`while` conditions [#11](https://github.com/HaxeCheckstyle/tokentree/issues/11)
- Fixed handling of ternary expressions [#11](https://github.com/HaxeCheckstyle/tokentree/issues/11)
- Fixed tree position of `Comma` [#13](https://github.com/HaxeCheckstyle/tokentree/issues/13)

## version 1.0.3 (2018-06-24)

- Fixed position of comments in abstracts and interfaces [#7](https://github.com/HaxeCheckstyle/tokentree/issues/7)
- Fixed unittest and coverage reporting for Haxe 4 [#8](https://github.com/HaxeCheckstyle/tokentree/issues/8)

## version 1.0.2 (2018-06-22)

- Fixed thread safety of SharpIf handling [#4](https://github.com/HaxeCheckstyle/tokentree/issues/4)
- Fixed handling of Semicolon in typedefs [#4](https://github.com/HaxeCheckstyle/tokentree/issues/4)
- Fixed WalkComment at end of stream [#4](https://github.com/HaxeCheckstyle/tokentree/issues/4)
- Fixed handling of switch in object declaration [#5](https://github.com/HaxeCheckstyle/tokentree/issues/5)
- Changed position of top level comments [#4](https://github.com/HaxeCheckstyle/tokentree/issues/4)

## version 1.0.1 (2018-06-14)

- Added `RELAX` mode to make parser more fault tolerant [#2](https://github.com/HaxeCheckstyle/tokentree/issues/2)
- Fixed handling of `cast -1` [#1](https://github.com/HaxeCheckstyle/tokentree/issues/1)

## version 1.0.0 (2018-06-09)

- initial move to separate repository