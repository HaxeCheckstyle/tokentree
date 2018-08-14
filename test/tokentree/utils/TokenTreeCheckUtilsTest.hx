package tokentree.utils;

import tokentree.utils.TokenTreeCheckUtils.BrOpenType;
import tokentree.utils.TokenTreeCheckUtils.ArrowType;
import tokentree.TokenTreeBuilderParsingTest.TokenTreeBuilderParsingTests;
import haxe.PosInfos;
import massive.munit.Assert;

class TokenTreeCheckUtilsTest {
	@Test
	public function testBrOpenTypedef() {
		var root:TokenTree = assertCodeParses(TokenTreeBuilderParsingTests.STRUCTURE_EXTENSION);
		var allBr:Array<TokenTree> = root.filter([BrOpen], ALL);
		Assert.areEqual(3, allBr.length);
		for (br in allBr) {
			Assert.areEqual(BrOpenType.TYPEDEFDECL, TokenTreeCheckUtils.getBrOpenType(br));
		}
	}

	@Test
	public function testMixedBrOpenTypes() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.MIXED_BR_OPEN_TYPES);
		var allBr:Array<TokenTree> = root.filter([BrOpen], ALL);
		Assert.areEqual(27, allBr.length);
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

		// abstracts
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[index++]));
	}

	@Test
	public function testEnumAbstract() {
		var root:TokenTree = assertCodeParses(TokenTreeBuilderParsingTests.ENUM_ABSTRACT);
		var allAbstracts:Array<TokenTree> = root.filter([Kwd(KwdAbstract)], ALL);
		for (ab in allAbstracts) {
			Assert.isTrue(TokenTreeCheckUtils.isTypeEnumAbstract(ab));
		}

		root = assertCodeParses(TokenTreeBuilderParsingTests.CONST_TYPE_PARAMETER);
		allAbstracts = root.filter([Kwd(KwdAbstract)], ALL);
		for (ab in allAbstracts) {
			Assert.isFalse(TokenTreeCheckUtils.isTypeEnumAbstract(ab));
		}

		root = assertCodeParses(TokenTreeCheckUtilsTests.ENUM_ABSTRACTS);
		allAbstracts = root.filter([Kwd(KwdAbstract)], ALL);
		for (ab in allAbstracts) {
			Assert.isTrue(TokenTreeCheckUtils.isTypeEnumAbstract(ab));
		}
	}

	@Test
	public function testArrowFunctions() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.ARROW_FUNCTIONS);

		var allArrows:Array<TokenTree> = root.filter([Arrow], ALL);
		for (ar in allArrows) {
			Assert.areEqual(ArrowType.ARROW_FUNCTION, TokenTreeCheckUtils.getArrowType(ar));
		}
	}

	@Test
	public function testFunctionTypeHaxe3() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.FUNCTION_TYPE_HAXE_3);

		var allArrows:Array<TokenTree> = root.filter([Arrow], ALL);
		for (ar in allArrows) {
			Assert.areEqual(ArrowType.FUNCTION_TYPE_HAXE3, TokenTreeCheckUtils.getArrowType(ar));
		}
	}

	@Test
	public function testFunctionTypeHaxe4() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.FUNCTION_TYPE_HAXE_4);

		var allArrows:Array<TokenTree> = root.filter([Arrow], ALL);
		for (ar in allArrows) {
			Assert.areEqual(ArrowType.FUNCTION_TYPE_HAXE4, TokenTreeCheckUtils.getArrowType(ar));
		}
	}

	@Test
	public function testIsTernary() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.TERNARY);
		var allQuestion:Array<TokenTree> = root.filter([Question], ALL);
		Assert.areEqual(6, allQuestion.length);
		for (quest in allQuestion) {
			Assert.isTrue(TokenTreeCheckUtils.isTernary(quest));
		}
	}

	@Test
	public function testNotIsTernary() {
		var root:TokenTree = assertCodeParses(TokenTreeCheckUtilsTests.NOT_TERNARY);
		var allQuestion:Array<TokenTree> = root.filter([Question], ALL);
		Assert.areEqual(4, allQuestion.length);
		for (quest in allQuestion) {
			Assert.isFalse(TokenTreeCheckUtils.isTernary(quest));
		}
	}

	public function assertCodeParses(code:String, ?pos:PosInfos):TokenTree {
		var builder:TestTokenTreeBuilder = null;
		try {
			builder = TestTokenTreeBuilder.parseCode(code);
			Assert.isTrue(builder.isStreamEmpty(), pos);
			return builder.root;
		}
		catch (e:Any) {
			Assert.fail("code should not throw execption " + e, pos);
		}
		return null;
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
	}
	abstract Foo(Bar) from {a:String} {}
	abstract Foo({i:Int}) {}
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
		}
	}
	typedef ExtendedFieldsCB = Array<ObjectDeclField>->String->Position->DynamicAccess<Expr>->Void;
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
}