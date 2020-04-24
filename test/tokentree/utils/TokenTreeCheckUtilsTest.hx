package tokentree.utils;

import tokentree.utils.TokenTreeCheckUtils.POpenType;
import tokentree.utils.TokenTreeCheckUtils.ColonType;
import tokentree.utils.TokenTreeCheckUtils.BrOpenType;
import tokentree.utils.TokenTreeCheckUtils.ArrowType;
import tokentree.TokenTreeBuilderParsingTest.TokenTreeBuilderParsingTests;
import haxe.PosInfos;
import massive.munit.Assert;

class TokenTreeCheckUtilsTest {
	@Test
	public function testBrOpenTypedef() {
		var root:TokenTree = assertCodeParses(TokenTreeBuilderParsingTests.STRUCTURE_EXTENSION);
		Assert.isFalse(root.inserted);

		var allBr:Array<TokenTree> = root.filter([BrOpen], ALL);
		Assert.areEqual(3, allBr.length);
		for (br in allBr) {
			Assert.areEqual(BrOpenType.TYPEDEFDECL, TokenTreeCheckUtils.getBrOpenType(br));
		}
	}

	@Test
	public function testMixedBrOpenTypes() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.MIXED_BR_OPEN_TYPES);
		Assert.isFalse(root.inserted);

		var allBr:Array<TokenTree> = root.filter([BrOpen], ALL);
		Assert.areEqual(43, allBr.length);
		var index:Int = 0;
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));

		// function foo<T:{bar:T}>() {}
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));

		// abstracts
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));

		// {foo: bar}
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		// {foo: bar};
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		// {foo: bar, bar: foo}
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		// {foo: bar, bar: foo};
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));

		// {}
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		// {};
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		// { /*comment*/ }
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		// { /*comment*/ };
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));

		// final obj:{f: Int} = {f: 1};
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		// final obj:{f: {f: Int}} = {f: {f: 1}};
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
	}

	@Test
	public function testEnumAbstract() {
		var root:TokenTree = assertCodeParses(TokenTreeBuilderParsingTests.ENUM_ABSTRACT);
		Assert.isFalse(root.inserted);

		var allAbstracts:Array<TokenTree> = root.filter([Kwd(KwdAbstract)], ALL);
		for (ab in allAbstracts) {
			Assert.isTrue(TokenTreeCheckUtils.isTypeEnumAbstract(ab));
		}

		root = assertCodeParses(TokenTreeBuilderParsingTests.CONST_TYPE_PARAMETER);
		Assert.isFalse(root.inserted);

		allAbstracts = root.filter([Kwd(KwdAbstract)], ALL);
		for (ab in allAbstracts) {
			Assert.isFalse(TokenTreeCheckUtils.isTypeEnumAbstract(ab));
		}

		root = assertCodeParses(TokenTreeCheckUtilsTests.ENUM_ABSTRACTS);
		allAbstracts = root.filter([Kwd(KwdAbstract)], ALL);
		Assert.isFalse(root.inserted);

		for (ab in allAbstracts) {
			Assert.isTrue(TokenTreeCheckUtils.isTypeEnumAbstract(ab));
		}
	}

	@Test
	public function testArrowFunctions() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.ARROW_FUNCTIONS);
		Assert.isFalse(root.inserted);

		var allArrows:Array<TokenTree> = root.filter([Arrow], ALL);
		Assert.areEqual(10, allArrows.length);
		for (ar in allArrows) {
			Assert.areEqual(ArrowType.ARROW_FUNCTION, TokenTreeCheckUtils.getArrowType(ar));
		}
	}

	@Test
	public function testFunctionTypeHaxe3() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.FUNCTION_TYPE_HAXE_3);
		Assert.isFalse(root.inserted);

		var allArrows:Array<TokenTree> = root.filter([Arrow], ALL);
		Assert.areEqual(26, allArrows.length);
		for (ar in allArrows) {
			Assert.areEqual(ArrowType.FUNCTION_TYPE_HAXE3, TokenTreeCheckUtils.getArrowType(ar));
		}
	}

	@Test
	public function testFunctionTypeHaxe4() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.FUNCTION_TYPE_HAXE_4);
		Assert.isFalse(root.inserted);

		var allArrows:Array<TokenTree> = root.filter([Arrow], ALL);
		Assert.areEqual(7, allArrows.length);
		for (ar in allArrows) {
			Assert.areEqual(ArrowType.FUNCTION_TYPE_HAXE4, TokenTreeCheckUtils.getArrowType(ar));
		}
	}

	@Test
	public function testIsTernary() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.TERNARY);
		Assert.isFalse(root.inserted);

		var allQuestion:Array<TokenTree> = root.filter([Question], ALL);
		Assert.areEqual(13, allQuestion.length);
		for (quest in allQuestion) {
			Assert.isTrue(TokenTreeCheckUtils.isTernary(quest));
		}
	}

	@Test
	public function testNotIsTernary() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.NOT_TERNARY);
		Assert.isFalse(root.inserted);

		var allQuestion:Array<TokenTree> = root.filter([Question], ALL);
		Assert.areEqual(4, allQuestion.length);
		for (quest in allQuestion) {
			Assert.isFalse(TokenTreeCheckUtils.isTernary(quest));
		}
	}

	@Test
	public function testMixedColonTypes() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.MIXED_COLON_TYPES);
		Assert.isFalse(root.inserted);

		var allBr:Array<TokenTree> = root.filter([DblDot], ALL);
		Assert.areEqual(64, allBr.length);
		var index:Int = 0;
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_CHECK, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_CHECK, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TERNARY, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// var f:Void->Void;
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		Assert.areEqual(ColonType.AT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// case 0:
		Assert.areEqual(ColonType.SWITCH_CASE, TokenTreeCheckUtils.getColonType(allBr[index++]));
		// return {i: val.i + 1, s:val.s};
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));
		// case 1:
		Assert.areEqual(ColonType.SWITCH_CASE, TokenTreeCheckUtils.getColonType(allBr[index++]));
		// default:
		Assert.areEqual(ColonType.SWITCH_CASE, TokenTreeCheckUtils.getColonType(allBr[index++]));
		// return {i: 0, s:''};
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// var a = (10 : A);
		Assert.areEqual(ColonType.TYPE_CHECK, TokenTreeCheckUtils.getColonType(allBr[index++]));
		// var a = (10.0 : A);
		Assert.areEqual(ColonType.TYPE_CHECK, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// return switch ((this : DiagnosticsKind<T>)) {}
		Assert.areEqual(ColonType.TYPE_CHECK, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// function new(anchor:Position, active:Position):Void;
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// var tokens(default, null):Array<IToken>;
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// @:overload(function<T>(key:String, defaultValue:T):T {})
		Assert.areEqual(ColonType.AT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		// @:overload(function<T>(key:String):T {})
		Assert.areEqual(ColonType.AT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		// function get<T>(key:String):Null<T>;
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// [for (i in 0...1) ("" : String).length];
		Assert.areEqual(ColonType.TYPE_CHECK, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// static function foo(#if openfl ?vector:openfl.Vector<Int> #end) {}
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// if (Type.get((cast null : T)) == Type.get(0))
		// (bytes : Bytes).sortI32(0, length, cast f);
		Assert.areEqual(ColonType.TYPE_CHECK, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_CHECK, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// final obj:{f: Int} = {f: 1};
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// final obj:{f: {f: Int}} = {f: {f: 1}};
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.OBJECT_LITERAL, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// typedef Middleware = {
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// 	Loading(progress:Float);
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));

		// 	@:overload(function(element:js.html.Element):AngularElement {})
		Assert.areEqual(ColonType.AT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		// 	public static function element(name:String):AngularElement;
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
		Assert.areEqual(ColonType.TYPE_HINT, TokenTreeCheckUtils.getColonType(allBr[index++]));
	}

	@Test
	public function testMixedPOpenTypes() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.MIXED_POPEN_TYPES);
		Assert.isFalse(root.inserted);

		var allBr:Array<TokenTree> = root.filter([POpen], ALL);
		Assert.areEqual(28, allBr.length);
		var index:Int = 0;

		Assert.areEqual(POpenType.EXPRESSION, TokenTreeCheckUtils.getPOpenType(null));

		// @:deprecated('UnlessshuffleArray(), you should use shuffle() quality.')
		Assert.areEqual(POpenType.AT, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// function main() {
		Assert.areEqual(POpenType.PARAMETER, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		// var output = (result.stderr : Buffer).toString().trim();
		Assert.areEqual(POpenType.EXPRESSION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		// var output = (result.stderr : Buffer).toString().trim();
		Assert.areEqual(POpenType.EXPRESSION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// if (output == null) for (i in items) {}
		Assert.areEqual(POpenType.IF_CONDITION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.FORLOOP, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// return e2 == null ? {t: HDyn} : bar(e2);
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// static function main(?value:Int) {}
		Assert.areEqual(POpenType.PARAMETER, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// var f = (a:Int, b:Int) -> 0;
		Assert.areEqual(POpenType.PARAMETER, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		// foo((a : Int, b : Int) -> 0);
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.PARAMETER, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// add(#if (php || as3) (v ? 'true' : 'false') #else v #end);
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.SHARP_CONDITION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.EXPRESSION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// if (Type.get((cast null : T)) == Type.get(0))
		// (bytes : Bytes).sortI32(0, length, cast f);
		Assert.areEqual(POpenType.IF_CONDITION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.EXPRESSION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.EXPRESSION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// while (true) {
		Assert.areEqual(POpenType.WHILE_CONDITION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		// 	doSomething();
		Assert.areEqual(POpenType.CALL, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		// switch (condition) {
		Assert.areEqual(POpenType.SWITCH_CONDITION, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		// } catch (e)
		Assert.areEqual(POpenType.CATCH, TokenTreeCheckUtils.getPOpenType(allBr[index++]));

		// @:default(false) @:optional var disableFormatting:Bool;
		Assert.areEqual(POpenType.AT, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
		// @:default(auto) @:optional var emptyLines:EmptyLinesConfig;
		Assert.areEqual(POpenType.AT, TokenTreeCheckUtils.getPOpenType(allBr[index++]));
	}

	@Test
	public function testMixedTypeParameter() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.MIXED_TYPE_PARAMETER);
		Assert.isFalse(root.inserted);

		var allBr:Array<TokenTree> = root.filter([Binop(OpLt)], ALL);
		Assert.areEqual(1, allBr.length);
		var index:Int = 0;
		// abstract SymbolStack(Array<{level:SymbolLevel, symbol:DocumentSymbol}>) {}
		Assert.isTrue(TokenTreeCheckUtils.isTypeParameter(allBr[index++]));
	}

	@Test
	public function testFilterOpSub() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.MIXED_OP_SUB);
		Assert.isFalse(root.inserted);

		var allSubs:Array<TokenTree> = root.filter([Binop(OpSub)], ALL);
		Assert.areEqual(44, allSubs.length);
		var index:Int = 0;

		// true ? 0 : 1 - a;
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// true ? 0 : - a;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// (true) ? 1 - a : 1;
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// (true) ? -a : 1;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// doSomething(true) ? -a - 7 : -b - 2;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// setNext(transform != null ? transform.alphaMultiplier : -a);
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// angle = ((y < 0) ? -angle : angle) * FlxAngle.TO_DEG;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// var guarded = !AnyTypes.toBool(guard) ? function(t0, t1) return t0 == -t1 : guard;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// return -a;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// return -(a - b);
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// return -(a - b) - -(c - d);
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// directionIndex += if (instruction.turn == Left) -1 else 1;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// return if (difference > 0) 1 else if (difference < 0) -1 else 0;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));

		// return if (difference > 0) -a else -b;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// call(-a, -b, -c);
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));

		// call(-a) - b;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// [for (i in 1...10) -a];
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// [for (i in -a...-b) -c];
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// do -a - b while (-b - d > -c - e);
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));

		// this[15] - this[14];
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// this[15] - a;
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// this[15] - -a;
		Assert.isFalse(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));

		// function negative(a) -a;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
		// var negative = (a) -> -a;
		Assert.isTrue(TokenTreeCheckUtils.filterOpSub(allSubs[index++]));
	}

	@Test
	public function testIsMetadata() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.MIXED_METADATA);
		Assert.isFalse(root.inserted);

		Assert.isFalse(TokenTreeCheckUtils.isMetadata(null));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(root));

		var tokens:Array<TokenTree> = root.filterCallback(function(token:TokenTree, index:Int) {
			switch (token.tok) {
				case Kwd(_):
					return FOUND_GO_DEEPER;
				case Const(CIdent(_)):
					return FOUND_GO_DEEPER;
				default:
					return GO_DEEPER;
			}
		});

		Assert.areEqual(23, tokens.length);
		var index:Int = 0;

		// package foo;
		// import pack;
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));

		// class Foo {}
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		// @:using(Tools)
		Assert.isTrue(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isTrue(TokenTreeCheckUtils.isMetadata(tokens[index++]));

		// class Foo {}
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		// @:using
		Assert.isTrue(TokenTreeCheckUtils.isMetadata(tokens[index++]));

		// class Foo {}
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		// @:package
		Assert.isTrue(TokenTreeCheckUtils.isMetadata(tokens[index++]));

		// class Foo {}
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		// @:import
		Assert.isTrue(TokenTreeCheckUtils.isMetadata(tokens[index++]));

		// class Foo {}
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		// @import
		Assert.isTrue(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		// var foo:Int;
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
		Assert.isFalse(TokenTreeCheckUtils.isMetadata(tokens[index++]));
	}

	public function assertCodeParses(code:String, ?pos:PosInfos):TokenTree {
		var builder:Null<TestTokenTreeBuilder> = null;
		try {
			builder = TestTokenTreeBuilder.parseCode(code);
			Assert.isTrue(builder.isStreamEmpty(), pos);
			return builder.root;
		}
		catch (e:Any) {
			Assert.fail("code should not throw execption " + e, pos);
		}
		return new TokenTree(null, "", null, 0, true);
	}
}

@:enum
abstract TokenTreeCheckUtilsTests(String) to String {
	var MIXED_BR_OPEN_TYPES = "
	class Main {
		function foo(s:{i:Int}):{i:Int} {
			call({s: {i: 5}});
			var foo = {
				var bar = 'foo ';
				bar;
			}
			var foo = {
				call.back();
			}
			var foo = switch (None) {
				case Some(v): {i: 0}
				default: {i: 1}
			}
			var struct = {
				field: '' // some comment
			};
			if (haxeVersion >= {major: 4, minor: 0, patch: 0}) trace('');
			return e2 == null ? {t: HDyn} : bar(e2);
			var fixes = [
				for (key in map.keys())
					if (key.code == DKUnusedImport)
						{range: patchRange(doc, key.range), newText: ''}
			];
			if (is('')) {}
			if (is('')) {
				// do nothing
			}
			token.setCallback(function() sendNotification(CANCEL_METHOD, {id: id}));
			token.setCallback(function(foo, {id: id}) {});

			{
				'outer ': {
					foo: function() {
						trace('bar ');
					}
				}
			}
		}
		function foo<T:{bar:T}>() {}
	}
	abstract Foo(Bar) from {a:String} {}
	abstract Foo({i:Int}) {}

	{foo: bar}
	{foo: bar};

	{foo: bar, bar: foo}
	{foo: bar, bar: foo};
	{}
	{};
	{ /*comment*/ }
	{ /*comment*/ };

	final obj:{f: Int} = {f: 1};
	final obj:{f: {f: Int}} = {f: {f: 1}};
	";

	var ENUM_ABSTRACTS = "
	enum abstract Main(String) {
		var Test = 'xxx';
	}
	@:enum abstract Main(String) {
		var Test = 'xxx';
	}
	enum Main {
		Test;
	}
	";

	var ARROW_FUNCTIONS = "
	class Main {
		static public function main() {
			// arrow functions
			var f = () ->trace('');
			var f = () -> {};
			var f = arg-> {};
			var f = (arg) -> {};
			var f = (arg1:Int, arg2:String) -> {};
			fields.map(field -> field.type);
			protocol.logError = message -> protocol.sendNotification(Methods.LogMessage, {type: Warning, message: message});
			protocol.logError = message -> protocol.sendNotification();
			var f = a -> a;
			return {
				x: a -> a;
			}
		}
	}
	";

	var FUNCTION_TYPE_HAXE_3 = "
	class Main {
		static public function main() {
			// old function type syntax
			var f:Void->Void;
			var f:Int->String->Void;
			var f:(Int->Int) ->Int->Int;
			var f:Int->?Int->Void;
			var copy:Uri->Uri->{overwrite:Bool}->EitherType<Void, Thenable<Void>>;
		}
	}
	typedef ValueXYListenerCallback = {x:Float, y:Float}->Void;
	typedef ExtendedFieldsCB = Array<ObjectDeclField>->String->Position->DynamicAccess<Expr>->Void;
	typedef RequestHandler<P, R, E> = P->CancellationToken->(R->Void)->(ResponseError<E>->Void)->Void;

	abstract PromiseHandler<T, TOut>(T->Dynamic) // T->Dynamic, so the compiler always knows the type of the argument and can infer it for then/catch callbacks
		from T->TOut // order is important, because Promise<TOut> return must have priority
		from T->Thenable<TOut> // although the checking order seems to be reversed at the moment, see https://github.com/HaxeFoundation/haxe/issues/7656
		from T->Promise<TOut> // support Promise explicitly as it doesn't work transitively through Thenable at the moment
	{}
	";

	var FUNCTION_TYPE_HAXE_4 = "
	class Main {
		static public function main() {
			// new function type syntax
			var f:() ->Void;
			var f:(Int) ->Int;
			var f:(name:String) ->Void;
			var f:(Int, String) ->Bool;
			var f:(resolve:(value:Dynamic) ->Void, reject:(reason:Dynamic) ->Void) ->Void;
		}
	}
	";

	var TERNARY = "
	class Main {
        static function main(value:Int) {
                true ? 0 : 1;
                (true) ? 0 : 1;
                doSomething(true) ? 0 : 1;
                setNext(transform != null ? transform.alphaMultiplier : 1.0);
                angle = ((y < 0) ? -angle : angle) * FlxAngle.TO_DEG;
				_url = (l_loaderInfo != null) ? untyped l_loaderInfo.parameters.gameUrl : _GAME_URL;
				var guarded = !AnyTypes.toBool(guard) ? function(t0, t1) return t0 == t1 : guard;
				var angle = UI.get().isShiftDown ? 1. : 5.;
				fragmentShader = tinted ?
					'tex ft1,  v1, fs0 <???> \n' + // sample texture 0
					'mul  oc, ft1,  v0       \n'   // multiply color with texel color
					:
					'tex  oc,  v1, fs0 <???> \n';  // sample texture 0
				mMultiSelect[s] = toggle ? !mMultiSelect[s] : true;
				mMultiSelect[s] = toggle ? ~1 : true;
				macro {
					if (id < (isRPC ? $v{firstRPCID} : $v{firstFID})) {}
				}
				return e2 == null ? { t : HDyn } : bar(e2);
        }
	}
	";

	var NOT_TERNARY = "
	class Main {
        static function main(?value:Int) {}
		public function recycle(?ObjectClass:Class<T>, ?ObjectFactory:Void->T, Force : Bool = false, Revive : Bool = true) : T {}
	}

	enum Item {
		Staff(block:Float, ?magic:Int);
	}
	";

	var MIXED_COLON_TYPES = "
	class Main {
		function main () {
			var item = ({title: 'Edit settings '} : vscode.MessageItem);
			var output = (result.stderr:Buffer).toString().trim();
			return e2 == null ? {t: HDyn} : bar(e2);
		}
		var f:Void->Void;

        static function main(?value:Int) {}

		public function recycle(?ObjectClass:Class<T>, ?ObjectFactory:Void->T, Force : Bool = false, Revive : Bool = true) : T {}

		@:allow(pack.Module)
		public function recycle(val:{i:Int, s:String}) : T {
			switch(val) {
				case 0:
					return {i: val.i + 1, s:val.s};
				case 1:
				default:
					return {i: 0, s:''};
			}
			var a = (10 : A);
			var a = (10.0 : A);
			return switch ((this:DiagnosticsKind<T>)) {}
		}
		function new(anchor:Position, active:Position):Void;
		var tokens(default, null):Array<IToken>;
		@:overload(function<T>(key:String, defaultValue:T):T {})
		@:overload(function<T>(key:String):T {})
		function get<T>(key:String):Null<T>;

		function test() {
			[for (i in 0...1) ('' : String).length];
		}

		static function foo(#if openfl ?vector:openfl.Vector<Int> #end) {
			if (Type.get((cast null : T)) == Type.get(0))
				(bytes : Bytes).sortI32(0, length, cast f);
		}
		final obj:{f: Int} = {f: 1};
		final obj:{f: {f: Int}} = {f: {f: 1}};
	}

	typedef Middleware = {
		?provideCompletionItem:(document:TextDocument, position:Position, context:CompletionContext, token:CancellationToken,
			next:ProvideCompletionItemsSignature) -> ProviderResult<EitherType<Array<CompletionItem>, CompletionList>>,
	}

	enum LoadState
	{
		NotLoaded;
		Loaded;
		Loading(progress:Float);
	}

	extern class Angular
	{
		@:overload(function(element:js.html.Element):AngularElement {})
		public static function element(name:String):AngularElement;
	}
	";

	var MIXED_POPEN_TYPES = "
	@:deprecated('UnlessshuffleArray(), you should use shuffle() quality.')
	class Main {
		function main () {
			var item = ({title: 'Edit settings '} : vscode.MessageItem);
			var output = (result.stderr:Buffer).toString().trim();
			if (output == null) for (i in items) {}
			return e2 == null ? {t: HDyn} : bar(e2);
		}

        static function main(?value:Int) {
			var f = (a:Int, b:Int) -> 0;
			foo((a : Int, b : Int) -> 0);
			add(#if (php || as3) (v ? 'true' : 'false') #else v #end);
			if (Type.get((cast null : T)) == Type.get(0))
				(bytes : Bytes).sortI32(0, length, cast f);
			try {
				while (true) {
					doSomething();
				}
				switch (condition) {
					case Value1:
					case Value2:
				}
			} catch (e)
		}
	}
	typedef FormatterConfig = {
		/**
			turns off formatting for all files in current folder and subfolders
			unless subfolder contains a `hxformat.json`
		**/
		@:default(false) @:optional var disableFormatting:Bool;
		@:default(auto) @:optional var emptyLines:EmptyLinesConfig;
	}
	";

	var MIXED_TYPE_PARAMETER = "
	abstract SymbolStack(Array<{level:SymbolLevel, symbol:DocumentSymbol}>) {}
	";

	var MIXED_OP_SUB = "
	class Main {
        static function main(value:Int) {
			true ? 0 : 1 - a;
			true ? 0 : - a;
			(true) ? 1 - a : 1;
			(true) ? -a : 1;
			doSomething(true) ? -a - 7 : -b - 2;
			setNext(transform != null ? transform.alphaMultiplier : -a);
			angle = ((y < 0) ? -angle : angle) * FlxAngle.TO_DEG;
			var guarded = !AnyTypes.toBool(guard) ? function(t0, t1) return t0 == -t1 : guard;
			return -a;
			return -(a - b);
			return -(a - b) - -(c - d);
    		directionIndex += if (instruction.turn == Left) -a else 1;
			return if (difference > 0) 1 else if (difference < 0) -a else 0;

			return if (difference > 0) -a else -b;
			call(-a, -b, -c);
			call(-a) - b;
			[for (i in 1...10) -a];
			[for (i in -a...-b) -c];
			do -a - b while (-b - d > -c - e);
			this[15] - this[14];
			this[15] - a;
			this[15] - -a;
	    }
		function negative(a) -a;
		var negative = (a) -> -a;
	}
	";

	var MIXED_METADATA = "
	package foo;
	import pack;

	@:using(Tools)
	class Foo {}

	@:using
	class Foo {}

	@:package
	class Foo {}

	@:import
	class Foo {}

	@import
	class Foo {
		var foo:Int;
	}
	";
}