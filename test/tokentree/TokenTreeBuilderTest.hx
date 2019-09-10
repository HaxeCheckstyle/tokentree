package tokentree;

import haxe.PosInfos;
import haxeparser.Data.TokenDef;
import massive.munit.Assert;
import tokentree.walk.WalkAt;
import tokentree.walk.WalkIf;
import tokentree.walk.WalkPackageImport;
import tokentree.TokenTreeBuilder.TokenTreeEntryPoint;

class TokenTreeBuilderTest {
	function assertTokenEquals(testCase:TokenTreeBuilderTests, actual:String, ?pos:PosInfos) {
		Assert.areEqual((testCase : String), actual, pos);
	}

	@Test
	public function testImports() {
		var root:TokenTree = new TokenTree(null, "", null, -1);
		var builder:TestTokenTreeBuilder = new TestTokenTreeBuilder(TokenTreeBuilderTests.IMPORT, root);
		var stream:TokenStream = builder.getTokenStream();
		WalkPackageImport.walkPackageImport(stream, root);
		WalkPackageImport.walkPackageImport(stream, root);
		WalkPackageImport.walkPackageImport(stream, root);
		WalkPackageImport.walkPackageImport(stream, root);
		WalkPackageImport.walkPackageImport(stream, root);
		checkStreamEmpty(builder);

		assertTokenEquals(IMPORT_GOLD, treeToString(root));
	}

	@Test
	public function testAt() {
		var root:TokenTree = new TokenTree(null, "", null, -1);
		var builder:TestTokenTreeBuilder = new TestTokenTreeBuilder(TokenTreeBuilderTests.AT_ANNOTATION, root);
		var stream:TokenStream = builder.getTokenStream();
		root.addChild(WalkAt.walkAt(stream));
		root.addChild(WalkAt.walkAt(stream));
		root.addChild(WalkAt.walkAt(stream));
		root.addChild(WalkAt.walkAt(stream));
		builder.getTokenStream().consumeToken(); // remove comment line
		checkStreamEmpty(builder);

		#if (haxe_ver < 4.0)
		assertTokenEquals(cast StringTools.replace(AT_ANNOTATION_GOLD, ",null", ""), treeToString(root));
		#else
		assertTokenEquals(AT_ANNOTATION_GOLD, treeToString(root));
		#end
	}

	@Test
	public function testIf() {
		var root:TokenTree = new TokenTree(null, "", null, -1);
		var builder:TestTokenTreeBuilder = new TestTokenTreeBuilder(TokenTreeBuilderTests.IF, root);
		var stream:TokenStream = builder.getTokenStream();
		WalkIf.walkIf(stream, root);
		WalkIf.walkIf(stream, root);
		WalkIf.walkIf(stream, root);
		WalkIf.walkIf(stream, root);
		checkStreamEmpty(builder);

		#if (haxe_ver < 4.0)
		assertTokenEquals(cast StringTools.replace(IF_GOLD, ",null", ""), treeToString(root));
		#else
		assertTokenEquals(IF_GOLD, treeToString(root));
		#end
	}

	// public static function buildTokenTree(tokens:Array<Token>, bytes:ByteData, entryPoint:TokenTreeEntryPoint):TokenTree {

	@Test
	public function testEntryPoint() {
		parseNoException(ENTRY_POINT_FILE, TYPE_LEVEL);
		parseNoException(ENTRY_POINT_FUNCTION, FIELD_LEVEL);
		parseNoException(ENTRY_POINT_FUNCTION_WITH_BODY, FIELD_LEVEL);
		parseNoException(ENTRY_POINT_EXPRESSION, EXPRESSION_LEVEL);
		parseNoException(ENTRY_POINT_EXPRESSION_SWITCH, EXPRESSION_LEVEL);

		parseWithException(ENTRY_POINT_FILE, EXPRESSION_LEVEL);
		parseWithException(ENTRY_POINT_EXPRESSION_SWITCH, FIELD_LEVEL);
		parseWithException((ENTRY_POINT_FILE : String) + ENTRY_POINT_EXPRESSION_SWITCH, TYPE_LEVEL);
	}

	function parseWithException(code:String, level:TokenTreeEntryPoint) {
		try {
			parseNoException(code, level);
			Assert.fail("should throw an exception!");
		}
		catch (e:Any) {
			Assert.isTrue(true);
		}
	}

	function parseNoException(code:String, level:TokenTreeEntryPoint) {
		TokenStream.MODE = STRICT;
		var root:TokenTree = new TokenTree(null, "", null, -1);
		var testBuilder:TestTokenTreeBuilder = new TestTokenTreeBuilder(code, root);
		testBuilder.buildTokenTree(level);
	}

	function checkStreamEmpty(builder:TestTokenTreeBuilder) {
		Assert.isTrue(builder.isStreamEmpty());
	}

	function treeToString(token:TokenTree, prefix:String = ""):String {
		var buf:StringBuf = new StringBuf();
		var tokDef:TokenDef = token.tok;
		if (tokDef != null) buf.add('$prefix${tokDef}\n');
		if (token.hasChildren()) {
			@:nullSafety(Off)
			for (child in token.children) {
				buf.add(treeToString(child, prefix + "  "));
			}
		}
		return buf.toString();
	}
}

// @formatter:off
@:enum
abstract TokenTreeBuilderTests(String) to String {
	var IMPORT = "
		package checkstyle.checks;

		import haxeparser.*;
		import checkstyle.TokenTree;
		import checkstyle.TokenStream;
		import checkstyle.TokenTreeBuilder;
	";
	var IMPORT_GOLD =
		"  Kwd(KwdPackage)\n" +
		"    Const(CIdent(checkstyle))\n" +
		"      Dot\n" +
		"        Const(CIdent(checks))\n" +
		"          Semicolon\n" +
		"  Kwd(KwdImport)\n" +
		"    Const(CIdent(haxeparser))\n" +
		"      Dot\n" +
		"        Binop(OpMult)\n" +
		"          Semicolon\n" +
		"  Kwd(KwdImport)\n" +
		"    Const(CIdent(checkstyle))\n" +
		"      Dot\n" +
		"        Const(CIdent(TokenTree))\n" +
		"          Semicolon\n" +
		"  Kwd(KwdImport)\n" +
		"    Const(CIdent(checkstyle))\n" +
		"      Dot\n" +
		"        Const(CIdent(TokenStream))\n" +
		"          Semicolon\n" +
		"  Kwd(KwdImport)\n" +
		"    Const(CIdent(checkstyle))\n" +
		"      Dot\n" +
		"        Const(CIdent(TokenTreeBuilder))\n" +
		"          Semicolon\n";

	var AT_ANNOTATION = '
		@SuppressWarnings("checkstyle:MagicNumber")
		@SuppressWarnings(["checkstyle:MagicNumber", "checkstyle:AvoidStarImport"])
		@:from
		@Before
		// EOF
	';
	var AT_ANNOTATION_GOLD =
		"  At\n" +
		"    Const(CIdent(SuppressWarnings))\n" +
		"      POpen\n" +
		"        Const(CString(checkstyle:MagicNumber,null))\n" +
		"        PClose\n" +
		"  At\n" +
		"    Const(CIdent(SuppressWarnings))\n" +
		"      POpen\n" +
		"        BkOpen\n" +
		"          Const(CString(checkstyle:MagicNumber,null))\n" +
		"            Comma\n" +
		"          Const(CString(checkstyle:AvoidStarImport,null))\n" +
		"          BkClose\n" +
		"        PClose\n" +
		"  At\n" +
		"    DblDot\n" +
		"      Const(CIdent(from))\n" +
		"  At\n" +
		"    Const(CIdent(Before))\n";

	var IF = '
		if (tokDef != null) return;
		if (tokDef != null)
			return;
		else
			throw "error";
		if (token.hasChildren()) {
			return token.children;
		}
		if (token.hasChildren()) {
			return token.children;
		}
		else {
			return [];
		}
	';
	var IF_GOLD =
		"  Kwd(KwdIf)\n" +
		"    POpen\n" +
		"      Const(CIdent(tokDef))\n" +
		"        Binop(OpNotEq)\n" +
		"          Kwd(KwdNull)\n" +
		"      PClose\n" +
		"    Kwd(KwdReturn)\n" +
		"      Semicolon\n" +
		"  Kwd(KwdIf)\n" +
		"    POpen\n" +
		"      Const(CIdent(tokDef))\n" +
		"        Binop(OpNotEq)\n" +
		"          Kwd(KwdNull)\n" +
		"      PClose\n" +
		"    Kwd(KwdReturn)\n" +
		"      Semicolon\n" +
		"    Kwd(KwdElse)\n" +
		"      Kwd(KwdThrow)\n" +
		"        Const(CString(error,null))\n" +
		"        Semicolon\n" +
		"  Kwd(KwdIf)\n" +
		"    POpen\n" +
		"      Const(CIdent(token))\n" +
		"        Dot\n" +
		"          Const(CIdent(hasChildren))\n" +
		"            POpen\n" +
		"              PClose\n" +
		"      PClose\n" +
		"    BrOpen\n" +
		"      Kwd(KwdReturn)\n" +
		"        Const(CIdent(token))\n" +
		"          Dot\n" +
		"            Const(CIdent(children))\n" +
		"        Semicolon\n" +
		"      BrClose\n" +
		"  Kwd(KwdIf)\n" +
		"    POpen\n" +
		"      Const(CIdent(token))\n" +
		"        Dot\n" +
		"          Const(CIdent(hasChildren))\n" +
		"            POpen\n" +
		"              PClose\n" +
		"      PClose\n" +
		"    BrOpen\n" +
		"      Kwd(KwdReturn)\n" +
		"        Const(CIdent(token))\n" +
		"          Dot\n" +
		"            Const(CIdent(children))\n" +
		"        Semicolon\n" +
		"      BrClose\n" +
		"    Kwd(KwdElse)\n" +
		"      BrOpen\n" +
		"        Kwd(KwdReturn)\n" +
		"          BkOpen\n" +
		"            BkClose\n" +
		"          Semicolon\n" +
		"        BrClose\n";

	var ENTRY_POINT_FILE = "
		package checkstyle.checks;

		import haxeparser.*;
		import checkstyle.TokenTree;
		import checkstyle.TokenStream;
		import checkstyle.TokenTreeBuilder;

		@:access(haxe.Json)
		class Main<T> {
			@:access(test.Main)
			public function main() {
			}
		}
	";

	var ENTRY_POINT_FUNCTION = "
		@:access(test.Main)
		public static inline function main<T> (param:Int, param2:String):T;
	";

	var ENTRY_POINT_FUNCTION_WITH_BODY = "
		@:access(test.Main)
		public static inline function main<T> (param:Int, param2:String):T {
			trace (param2);
		}
	";

	var ENTRY_POINT_EXPRESSION = "
		trace (param2);
	";

	var ENTRY_POINT_EXPRESSION_SWITCH = "
		switch (entryPoint) {
			case FileLevel:
				WalkFile.walkFile(stream, root);
			case FunctionLevel:
				WalkClass.walkClassBody(stream, root);
			case ExpressionLevel:
				WalkStatement.walkStatement(stream, root);
		}
	";
}