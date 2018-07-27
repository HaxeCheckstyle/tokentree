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
		Assert.areEqual(7, allBr.length);
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[0]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[1]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[2]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[3]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[4]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[5]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[6]));
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

	public function assertCodeParses(code:String, ?pos:PosInfos):TokenTree {
		var builder:TestTokenTreeBuilder = null;
		try {
			builder = TestTokenTreeBuilder.parseCode(code);
			Assert.isTrue(builder.isStreamEmpty(), pos);
			return builder.root;
		}
		catch (e:Any) {
			Assert.fail("code should not throw execption", pos);
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
		}
	}
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
}