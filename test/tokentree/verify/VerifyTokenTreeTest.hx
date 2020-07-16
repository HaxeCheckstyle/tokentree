package tokentree.verify;

import haxeparser.Data;
import tokentree.TokenTreeBuilderParsingTest.TokenTreeBuilderParsingTests;

class VerifyTokenTreeTest extends VerifyTokenTreeBase {
	@Test
	public function testImport() {
		var root:IVerifyTokenTree = buildTokenTree(VerifyTokenTreeTests.IMPORT);

		root.first().matches(Kwd(KwdPackage)).count(1).filter(Const(CIdent("checkstyle"))).count(1).childs().matches(Dot).childs().childs().matches(Semicolon);

		root.filter(Kwd(KwdImport)).count(4).filter(Const(CIdent("checkstyle"))).count(3).childs().matches(Dot).childs().childs().count(3).matches(Semicolon);
		root.filter(Kwd(KwdImport)).count(4).filter(Const(CIdent("haxeparser"))).count(1).childs().matches(Dot).childs().childs().count(1).matches(Semicolon);

		root.last().matches(Kwd(KwdUsing)).filter(Const(CIdent("checkstyle"))).count(1).childs().matches(Dot).childs().childs().count(1).matches(Semicolon);
	}

	@Test
	public function testObjectDecl() {
		var root:IVerifyTokenTree = buildTokenTree(TokenTreeBuilderParsingTests.BLOCK_OBJECT_DECL_SAMPLES_ISSUE_396_1);

		// class
		var block:IVerifyTokenTree = root.childFirst().matches(Kwd(KwdClass)).count(1).childFirst().matches(Const(CIdent("Test"))).childFirst().matches(BrOpen).childCount(2);
		block.childLast().matches(BrClose).noChilds();

		// function test()
		var func:IVerifyTokenTree = block.childFirst().matches(Kwd(KwdFunction)).childFirst().matches(Const(CIdent("test"))).childCount(2);
		func.childFirst().matches(POpen).childFirst().matches(PClose).noChilds();

		// function body
		block = func.last().matches(BrOpen).childCount(3);
		block.childFirst().matches(CommentLine("fails with: bad token Comma != BrClose")).noChilds();
		block.last().matches(BrClose).noChilds();

		// var test = switch a
		var eq:IVerifyTokenTree = block.childAt(1).matches(Kwd(KwdVar)).childs().count(1).matches(Const(CIdent("test"))).childs().count(1).matches(Binop(OpAssign));
		var sw:IVerifyTokenTree = eq.childs().count(1).matches(Kwd(KwdSwitch)).childCount(2);
		sw.childFirst().matches(Const(CIdent("a"))).noChilds();

		// switch body
		block = sw.childLast().matches(BrOpen).childCount(3);

		// case 3
		var cas:IVerifyTokenTree = block.childFirst().matches(Kwd(KwdCase)).childCount(2);
		cas.childFirst().matches(Const(CInt("3"))).noChilds();
		cas = cas.childLast().matches(DblDot).childs().count(1);
		cas = cas.first().matches(BrOpen).childCount(4).childs();
		cas.first().matches(Const(CIdent("a"))).childs().count(2).first().matches(DblDot).childs().count(1).matches(Const(CInt("1"))).noChilds();
		cas.first().matches(Const(CIdent("a"))).childs().count(2).last().matches(Comma).noChilds();
		cas.at(1).matches(Const(CIdent("b"))).childs().count(1).matches(DblDot).childs().count(1).matches(Const(CInt("2"))).noChilds();
		cas.at(2).matches(BrClose).noChilds();
		cas.last().matches(Semicolon).noChilds();

		// default
		cas = block.childAt(1).matches(Kwd(KwdDefault)).childs().matches(DblDot).childs().count(1);
		cas = cas.first().matches(BrOpen).childCount(4).childs();
		cas.first().matches(Const(CIdent("a"))).childs().count(2).first().matches(DblDot).childs().count(1).matches(Const(CInt("0"))).noChilds();
		cas.first().matches(Const(CIdent("a"))).childs().count(2).last().matches(Comma).noChilds();
		cas.at(1).matches(Const(CIdent("b"))).childs().count(1).matches(DblDot).childs().count(1).matches(Const(CInt("2"))).noChilds();
		cas.at(2).matches(BrClose).noChilds();
		cas.last().matches(Semicolon).noChilds();

		block.childLast().matches(BrClose).noChilds();
	}

	@Test
	public function testTypedefComments() {
		var root:IVerifyTokenTree = buildTokenTree(TokenTreeBuilderParsingTests.TYPEDEF_COMMENTS);

		// typedef CheckFile
		var type:IVerifyTokenTree = root.childFirst().matches(Kwd(KwdTypedef)).oneChild().childFirst().matches(Const(CIdent("CheckFile")));
		var brOpen:IVerifyTokenTree = type.childFirst().matches(Binop(OpAssign)).oneChild().childFirst().matches(BrOpen).childCount(8);
		brOpen.childAt(0).matches(CommentLine(" °"));

		// var name:String;
		var v:IVerifyTokenTree = brOpen.childAt(1).matches(Kwd(KwdVar)).oneChild().childFirst().matches(Const(CIdent("name"))).oneChild();
		v.childFirst().matches(DblDot).oneChild().childFirst().matches(Const(CIdent("String"))).oneChild().childFirst().matches(Semicolon).noChilds();

		brOpen.childAt(2).matches(CommentLine(" öäü")).noChilds();

		// var content:String;
		v = brOpen.childAt(3).matches(Kwd(KwdVar)).oneChild().childFirst().matches(Const(CIdent("content"))).oneChild();
		v.childFirst().matches(DblDot).oneChild().childFirst().matches(Const(CIdent("String"))).oneChild().childFirst().matches(Semicolon).noChilds();

		brOpen.childAt(4).matches(CommentLine(" €łµ")).noChilds();

		// var index:Int;
		v = brOpen.childAt(5).matches(Kwd(KwdVar)).oneChild().childFirst().matches(Const(CIdent("index"))).oneChild();
		v.childFirst().matches(DblDot).oneChild().childFirst().matches(Const(CIdent("Int"))).oneChild().childFirst().matches(Semicolon).noChilds();

		brOpen.childAt(6).matches(CommentLine(" æ@ð")).noChilds();
		brOpen.childLast().matches(BrClose).noChilds();
	}

	@Test
	public function testTypedefComments2() {
		var root:IVerifyTokenTree = buildTokenTree(TokenTreeBuilderParsingTests.TYPEDEF_COMMENTS_2);

		// typedef CheckFile
		var type:IVerifyTokenTree = root.childFirst().matches(Kwd(KwdTypedef)).oneChild().childFirst().matches(Const(CIdent("CheckFile")));
		var brOpen:IVerifyTokenTree = type.childFirst().matches(Binop(OpAssign)).oneChild().childFirst().matches(BrOpen).childCount(6);
		brOpen.childAt(0).matches(CommentLine(" °"));

		// var name:String;
		var v:IVerifyTokenTree = brOpen.childAt(1).matches(Kwd(KwdVar)).oneChild().childFirst().matches(Const(CIdent("name"))).oneChild();
		v.childFirst().matches(DblDot).oneChild().childFirst().matches(Const(CIdent("String"))).oneChild().childFirst().matches(Semicolon).noChilds();

		// var content:String;
		v = brOpen.childAt(2).matches(Kwd(KwdVar)).oneChild().childFirst().matches(Const(CIdent("content"))).oneChild();
		v.childFirst().matches(DblDot).oneChild().childFirst().matches(Const(CIdent("String"))).oneChild().childFirst().matches(Semicolon).noChilds();

		brOpen.childAt(3).matches(CommentLine(" €łµ")).noChilds();

		// var index:Int;
		v = brOpen.childAt(4).matches(Kwd(KwdVar)).oneChild().childFirst().matches(Const(CIdent("index"))).oneChild();
		v.childFirst().matches(DblDot).oneChild().childFirst().matches(Const(CIdent("Int"))).oneChild().childFirst().matches(Semicolon).noChilds();

		brOpen.childLast().matches(BrClose).noChilds();
	}
}

@:enum
abstract VerifyTokenTreeTests(String) to String {
	var IMPORT = "
		package checkstyle.checks;

		import haxeparser.*;
		import checkstyle.TokenTree;,
		import checkstyle.TokenStream;
		import checkstyle.TokenTreeBuilder;
		using checkstyle.TokenTree;
	";
}