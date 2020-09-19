package tokentree.utils;

import haxe.PosInfos;
import tokentree.TokenTree.FilterResult;
import tokentree.utils.FieldUtils.TokenFieldType;

class FieldUtilsTest implements ITest {
	public function new() {}

	@Test
	@:nullSafety(Off)
	public function testProperties() {
		var root:Null<TokenTree> = assertCodeParses(FieldUtilsTests.PROPERTIES);
		Assert.isFalse(root.inserted);

		var allBr:Array<TokenTree> = root.filterCallback(function(token:TokenTree, depth:Int):FilterResult {
			return switch (token.tok) {
				case BrOpen: FoundGoDeeper;
				default: GoDeeper;
			}
		});
		Assert.equals(1, allBr.length);
		Assert.equals(7 + 1, allBr[0].children.length);

		checkFieldType(Var("_haxelibRepo", Private, true, false, false, false), FieldUtils.getFieldType(allBr[0].children[0], Private));
		checkFieldType(Var("_haxelibRepo", Public, true, false, false, false), FieldUtils.getFieldType(allBr[0].children[0], Public));

		checkFieldType(Prop("haxelibRepo", Private, true, Get, Never), FieldUtils.getFieldType(allBr[0].children[1], Private));
		checkFieldType(Prop("haxelibRepo", Public, true, Get, Never), FieldUtils.getFieldType(allBr[0].children[1], Public));

		checkFieldType(Var("_haxelibRepo", Public, false, false, false, false), FieldUtils.getFieldType(allBr[0].children[2], Private));
		checkFieldType(Var("_haxelibRepo", Public, false, false, false, false), FieldUtils.getFieldType(allBr[0].children[2], Public));

		checkFieldType(Prop("haxelibRepo", Public, false, Get, Never), FieldUtils.getFieldType(allBr[0].children[3], Private));
		checkFieldType(Prop("haxelibRepo", Public, false, Get, Never), FieldUtils.getFieldType(allBr[0].children[3], Public));

		checkFieldType(Var("_haxelibRepo", Public, true, true, false, false), FieldUtils.getFieldType(allBr[0].children[4], Private));
		checkFieldType(Var("_haxelibRepo", Public, true, true, false, false), FieldUtils.getFieldType(allBr[0].children[4], Public));

		checkFieldType(Function("main", Public, true, false, false, false, false), FieldUtils.getFieldType(allBr[0].children[5], Private));
		checkFieldType(Function("main", Public, true, false, false, false, false), FieldUtils.getFieldType(allBr[0].children[5], Public));

		checkFieldType(Function("main", Private, false, false, true, false, false), FieldUtils.getFieldType(allBr[0].children[6], Private));
		checkFieldType(Function("main", Public, false, false, true, false, false), FieldUtils.getFieldType(allBr[0].children[6], Public));
	}

	function checkFieldType(expected:TokenFieldType, actual:TokenFieldType, ?pos:PosInfos) {
		Assert.isTrue(Type.enumEq(expected, actual), pos);
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