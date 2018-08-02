package tokentree.utils;

import tokentree.utils.FieldUtils.TokenFieldType;
import tokentree.utils.FieldUtils.TokenFieldVisibility;
import tokentree.utils.FieldUtils.TokenPropertyAccess;
import haxe.PosInfos;
import massive.munit.Assert;

class FieldUtilsTest {
	@Test
	public function testProperties() {
		var root:TokenTree = assertCodeParses(FieldUtilsTests.PROPERTIES);
		var allBr:Array<TokenTree> = root.filter([BrOpen], ALL);
		Assert.areEqual(1, allBr.length);
		Assert.areEqual(3, allBr[0].children.length);
		checkFieldType(VAR("_haxelibRepo", PRIVATE, true, false, false, false), FieldUtils.getFieldType(allBr[0].children[0], PRIVATE));
		checkFieldType(PROP("haxelibRepo", PRIVATE, true, GET, NEVER), FieldUtils.getFieldType(allBr[0].children[1], PRIVATE));
	}

	function checkFieldType(expected:TokenFieldType, actual:TokenFieldType) {
		Assert.isTrue(Type.enumEq(expected, actual));
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
abstract FieldUtilsTests(String) to String {
	var PROPERTIES = "
	class Main {
		static var _haxelibRepo:Null<String>;
		static var haxelibRepo(get, never):Null<String>;
	}
	";
}