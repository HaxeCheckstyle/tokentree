package tokentree.utils;

import tokentree.utils.TokenTreeCheckUtils.BrOpenType;
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
		Assert.areEqual(6, allBr.length);
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[0]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[1]));
		Assert.areEqual(BrOpenType.ANONTYPE, TokenTreeCheckUtils.getBrOpenType(allBr[2]));
		Assert.areEqual(BrOpenType.BLOCK, TokenTreeCheckUtils.getBrOpenType(allBr[3]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[4]));
		Assert.areEqual(BrOpenType.OBJECTDECL, TokenTreeCheckUtils.getBrOpenType(allBr[5]));
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
		}
	}
	";
}