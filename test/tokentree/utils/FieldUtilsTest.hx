package tokentree.utils;

import tokentree.utils.FieldUtils.TokenFieldType;
import haxe.PosInfos;
import massive.munit.Assert;

class FieldUtilsTest {
	@Test
	public function testProperties() {
		var root:TokenTree = assertCodeParses(FieldUtilsTests.PROPERTIES);
		var allBr:Array<TokenTree> = root.filter([BrOpen], ALL);
		Assert.areEqual(1, allBr.length);
		Assert.areEqual(7 + 1, allBr[0].children.length);

		checkFieldType(VAR("_haxelibRepo", PRIVATE, true, false, false, false), FieldUtils.getFieldType(allBr[0].children[0], PRIVATE));
		checkFieldType(VAR("_haxelibRepo", PUBLIC, true, false, false, false), FieldUtils.getFieldType(allBr[0].children[0], PUBLIC));

		checkFieldType(PROP("haxelibRepo", PRIVATE, true, GET, NEVER), FieldUtils.getFieldType(allBr[0].children[1], PRIVATE));
		checkFieldType(PROP("haxelibRepo", PUBLIC, true, GET, NEVER), FieldUtils.getFieldType(allBr[0].children[1], PUBLIC));

		checkFieldType(VAR("_haxelibRepo", PUBLIC, false, false, false, false), FieldUtils.getFieldType(allBr[0].children[2], PRIVATE));
		checkFieldType(VAR("_haxelibRepo", PUBLIC, false, false, false, false), FieldUtils.getFieldType(allBr[0].children[2], PUBLIC));

		checkFieldType(PROP("haxelibRepo", PUBLIC, false, GET, NEVER), FieldUtils.getFieldType(allBr[0].children[3], PRIVATE));
		checkFieldType(PROP("haxelibRepo", PUBLIC, false, GET, NEVER), FieldUtils.getFieldType(allBr[0].children[3], PUBLIC));

		checkFieldType(VAR("_haxelibRepo", PUBLIC, true, true, false, false), FieldUtils.getFieldType(allBr[0].children[4], PRIVATE));
		checkFieldType(VAR("_haxelibRepo", PUBLIC, true, true, false, false), FieldUtils.getFieldType(allBr[0].children[4], PUBLIC));

		checkFieldType(FUNCTION("main", PUBLIC, true, false, false, false, false), FieldUtils.getFieldType(allBr[0].children[5], PRIVATE));
		checkFieldType(FUNCTION("main", PUBLIC, true, false, false, false, false), FieldUtils.getFieldType(allBr[0].children[5], PUBLIC));

		checkFieldType(FUNCTION("main", PRIVATE, false, false, true, false, false), FieldUtils.getFieldType(allBr[0].children[6], PRIVATE));
		checkFieldType(FUNCTION("main", PUBLIC, false, false, true, false, false), FieldUtils.getFieldType(allBr[0].children[6], PUBLIC));
	}

	function checkFieldType(expected:TokenFieldType, actual:TokenFieldType, ?pos:PosInfos) {
		Assert.isTrue(Type.enumEq(expected, actual), pos);
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
		public var _haxelibRepo:Null<String>;
		public var haxelibRepo(get, never):Null<String>;
		public static inline var _haxelibRepo:Null<String>;

		public static function main();
		override function main();
	}
	";
}