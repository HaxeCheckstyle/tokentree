package tokentree.walk;

import tokentree.TokenStream;
import tokentree.TokenTree;
import tokentree.verify.IVerifyTokenTree;
import tokentree.verify.VerifyTokenTreeBase;

class WalkIfTest extends VerifyTokenTreeBase implements ITest {
	public function new() {}

	@Test
	public function testIfExpr() {
		var root:IVerifyTokenTree = buildTokenTree("if (test) {doSomething();}");

		var ifTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().matches(POpen).childCount(2);
		ifExpr.first().matches(Const(CIdent("test"))).noChilds();
		ifExpr.last().matches(PClose).noChilds();
		ifBodyTest(ifTok);
	}

	@Test
	public function testIfUnOpSub() {
		var root:IVerifyTokenTree = buildTokenTree("if (test) -1;");

		var ifTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().matches(POpen).childCount(2);
		ifExpr.first().matches(Const(CIdent("test"))).noChilds();
		ifExpr.last().matches(PClose).noChilds();
		ifTok.last().matches(Const(CInt("-1"))).oneChild().first().matches(Semicolon).noChilds();
	}

	@Test
	public function testIfNull() {
		var root:IVerifyTokenTree = buildTokenTree("if (test) null;");

		var ifTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().matches(POpen).childCount(2);
		ifExpr.first().matches(Const(CIdent("test"))).noChilds();
		ifExpr.last().matches(PClose).noChilds();
		ifTok.last().matches(Kwd(KwdNull)).oneChild().first().matches(Semicolon).noChilds();
	}

	@Test
	public function testIfExprAndExpr() {
		var root:IVerifyTokenTree = buildTokenTree("if (test && test2) {doSomething();}");

		var ifTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().matches(POpen).childCount(2);
		ifExpr.first().matches(Const(CIdent("test"))).oneChild().first().matches(Binop(OpBoolAnd)).oneChild().first().matches(Const(CIdent("test2")))
			.noChilds();
		ifExpr.last().matches(PClose).noChilds();
		ifBodyTest(ifTok);
	}

	@Test
	public function testIfExprAndExpr2() {
		var root:IVerifyTokenTree = buildTokenTree("if (test) && (test2) {doSomething();}");

		var ifTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().matches(POpen).childCount(3);
		ifExpr.first().matches(Const(CIdent("test"))).noChilds();
		ifExpr.childAt(1).matches(PClose).noChilds();
		ifExpr = ifExpr.last().matches(Binop(OpBoolAnd)).oneChild().first().matches(POpen).childCount(2);
		ifExpr.first().matches(Const(CIdent("test2"))).noChilds();
		ifExpr.last().matches(PClose).noChilds();
		ifBodyTest(ifTok);
	}

	@Test
	public function testIfExprAndExpr3() {
		var root:IVerifyTokenTree = buildTokenTree("if test && test2 {doSomething();}");

		var ifTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdIf)).childCount(2);
		ifTok.first().matches(Const(CIdent("test"))).oneChild().first().matches(Binop(OpBoolAnd)).oneChild().first().matches(Const(CIdent("test2"))).noChilds();
		ifBodyTest(ifTok);
	}

	@Test
	public function testIfExprAndExpr4() {
		var root:IVerifyTokenTree = buildTokenTree("if test && test2 doSomething();");

		var ifTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdIf)).childCount(2);
		ifTok.first().matches(Const(CIdent("test"))).oneChild().first().matches(Binop(OpBoolAnd)).oneChild().first().matches(Const(CIdent("test2"))).noChilds();

		var exprCall:IVerifyTokenTree = ifTok.last().matches(Const(CIdent("doSomething"))).childCount(2);
		exprCall.first().matches(POpen).oneChild().first().matches(PClose).noChilds();
		exprCall.last().matches(Semicolon).noChilds();
	}

	function ifBodyTest(ifTok:IVerifyTokenTree) {
		var ifBody:IVerifyTokenTree = ifTok.last().matches(BrOpen).childCount(2);
		var exprCall:IVerifyTokenTree = ifBody.first().matches(Const(CIdent("doSomething"))).childCount(2);
		exprCall.first().matches(POpen).oneChild().first().matches(PClose).noChilds();
		exprCall.last().matches(Semicolon).noChilds();
		ifBody.last().matches(BrClose).noChilds();
	}

	override function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkIf.walkIf(stream, parent);
	}
}