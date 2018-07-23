## dev branch / next version (1.x.x)

- Added `TokenTreeCheckUtils.isTypeStructure()` [#36](https://github.com/HaxeCheckstyle/tokentree/issues/36) + [#50](https://github.com/HaxeCheckstyle/tokentree/issues/50)
- Added `TokenTreeCheckUtils.getName()` [#39](https://github.com/HaxeCheckstyle/tokentree/issues/39) + [#43](https://github.com/HaxeCheckstyle/tokentree/issues/43) + [#48](https://github.com/HaxeCheckstyle/tokentree/issues/48)
- Added `TokenTreeCheckUtils.isTypeEnum()` [#40](https://github.com/HaxeCheckstyle/tokentree/issues/40)
- Added `TokenTreeCheckUtils.isMacroClass()` [#42](https://github.com/HaxeCheckstyle/tokentree/issues/42)
- Added `TokenTreeCheckUtils.isOperatorFunction` [#44](https://github.com/HaxeCheckstyle/tokentree/issues/44)
- Added `TokenTreeCheckUtils.getMetadata()` and `isModifier()` [#44](https://github.com/HaxeCheckstyle/tokentree/issues/44)
- Added `TokenTreeCheckUtils.getBrOpenType()` and `getPOpenType()` [#51](https://github.com/HaxeCheckstyle/tokentree/issues/51)
- Added support for structural extension [#49](https://github.com/HaxeCheckstyle/tokentree/issues/49)
- Added support for `final` [#55](https://github.com/HaxeCheckstyle/tokentree/issues/55) + [#56](https://github.com/HaxeCheckstyle/tokentree/issues/56) + [#61](https://github.com/HaxeCheckstyle/tokentree/issues/61)
- Fixed running out of tokens during package and imports [#28](https://github.com/HaxeCheckstyle/tokentree/issues/28)
- Fixed `function` in typedef body [#30](https://github.com/HaxeCheckstyle/tokentree/issues/30)
- Fixed handling of `switch this {` [#34](https://github.com/HaxeCheckstyle/tokentree/issues/34)
- Fixed handling of `macro class` [#37](https://github.com/HaxeCheckstyle/tokentree/issues/37)
- Fixed `isTernary` [#38](https://github.com/HaxeCheckstyle/tokentree/issues/38)
- Fixed handling `return if (cond) -1 else 0` [#46](https://github.com/HaxeCheckstyle/tokentree/issues/46)
- Fixed `Comma` in object declarations [#52](https://github.com/HaxeCheckstyle/tokentree/issues/52)
- Fixed `@:final` handling in Haxe 4 [#53](https://github.com/HaxeCheckstyle/tokentree/issues/53)
- Fixed `Binop(OpSub)` detection  [#54](https://github.com/HaxeCheckstyle/tokentree/issues/54)
- Fixed `final` handling in `FieldUtils` when compiling with Haxe 3 [#56](https://github.com/HaxeCheckstyle/tokentree/issues/56)
- Fixed handling of const type parameters [#57](https://github.com/HaxeCheckstyle/tokentree/issues/57)
- Fixed `case var` handling [#58](https://github.com/HaxeCheckstyle/tokentree/issues/58)
- Fixed `case Pattern(var foo, var bar)` handling [#59](https://github.com/HaxeCheckstyle/tokentree/issues/59)
- Fixed comments in if…else [#60](https://github.com/HaxeCheckstyle/tokentree/issues/60)
- Fixed comments in typedefs [#62](https://github.com/HaxeCheckstyle/tokentree/issues/62)
- Fixed handling of array items [#62](https://github.com/HaxeCheckstyle/tokentree/issues/62)
- Fixed handling of `null`, `true` and `false` as body of if [#63](https://github.com/HaxeCheckstyle/tokentree/issues/63)
- Changed `getPos` to calculate full position of all childs [#29](https://github.com/HaxeCheckstyle/tokentree/issues/29)
- Changed position of `enum` in `enum abstract`
- Refactored `tempStore` handling and moved it to `TokenStream` childs [#28](https://github.com/HaxeCheckstyle/tokentree/issues/28) + [#30](https://github.com/HaxeCheckstyle/tokentree/issues/30)
- Refactored `TokenTreeAccessHelper` and made it an abstract [#31](https://github.com/HaxeCheckstyle/tokentree/issues/31) + [#32](https://github.com/HaxeCheckstyle/tokentree/issues/32) + [#41](https://github.com/HaxeCheckstyle/tokentree/issues/41)
- Refactored `isTypeEnumAbstract` [#33](https://github.com/HaxeCheckstyle/tokentree/issues/33)
- Refactored to apply formatting [#63](https://github.com/HaxeCheckstyle/tokentree/issues/63)

## version 1.0.6 (2018-07-16)

- Added `TokenTreeCheckUtils.isTypeEnumAbstract` [#16](https://github.com/HaxeCheckstyle/tokentree/issues/16)
- Added FieldUtils [#17](https://github.com/HaxeCheckstyle/tokentree/issues/17)
- Added `isComment` and `isCIdent` to `TokentTreeAccessHelper` [#23](https://github.com/HaxeCheckstyle/tokentree/issues/23)
- Added `TokenTreeCheckUtils.isOpGtTypedefExtension` [#24](https://github.com/HaxeCheckstyle/tokentree/issues/24)
- Added `TokenTreeCheckUtils.isBrOpenAnonTypeOrTypedef` [#26](https://github.com/HaxeCheckstyle/tokentree/issues/26)
- Added `tempStore` to `TokenStream` [#27](https://github.com/HaxeCheckstyle/tokentree/issues/27)
- Fixed `@:default` [#18](https://github.com/HaxeCheckstyle/tokentree/issues/18)
- Fixed position of `cast` children [#19](https://github.com/HaxeCheckstyle/tokentree/issues/19)
- Fixed position of comments in `case`/`default` [#20](https://github.com/HaxeCheckstyle/tokentree/issues/20)
- Fixed error handling to work with `--no-inline` [#21](https://github.com/HaxeCheckstyle/tokentree/issues/21)
- Fixed position of BinOp() in anon objects [#22](https://github.com/HaxeCheckstyle/tokentree/issues/22)
- Fixed ternary handling [#25](https://github.com/HaxeCheckstyle/tokentree/issues/25)
- Fixed missing modifiers in conditionals [#27](https://github.com/HaxeCheckstyle/tokentree/issues/27)
- Changed `isImport` to also incluide `using` [#20](https://github.com/HaxeCheckstyle/tokentree/issues/20)

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