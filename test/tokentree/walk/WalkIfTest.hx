package tokentree.walk;

import tokentree.TokenTree;
import tokentree.TokenStream;
import tokentree.verify.IVerifyTokenTree;
import tokentree.verify.VerifyTokenTreeBase;

class WalkIfTest extends VerifyTokenTreeBase {
	@Test
	public function testIfExpr() {
		var root:IVerifyTokenTree = buildTokenTree("if (test) {doSomething();}");

		var ifTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().is(POpen).childCount(2);
		ifExpr.first().is(Const(CIdent("test"))).noChilds();
		ifExpr.last().is(PClose).noChilds();
		testifBody(ifTok);
	}

	@Test
	public function testIfUnOpSub() {
		var root:IVerifyTokenTree = buildTokenTree("if (test) -1;");

		var ifTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().is(POpen).childCount(2);
		ifExpr.first().is(Const(CIdent("test"))).noChilds();
		ifExpr.last().is(PClose).noChilds();
		ifTok.last().is(Const(CInt("-1"))).oneChild().first().is(Semicolon).noChilds();
	}

	@Test
	public function testIfNull() {
		var root:IVerifyTokenTree = buildTokenTree("if (test) null;");

		var ifTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().is(POpen).childCount(2);
		ifExpr.first().is(Const(CIdent("test"))).noChilds();
		ifExpr.last().is(PClose).noChilds();
		ifTok.last().is(Kwd(KwdNull)).oneChild().first().is(Semicolon).noChilds();
	}

	@Test
	public function testIfExprAndExpr() {
		var root:IVerifyTokenTree = buildTokenTree("if (test && test2) {doSomething();}");

		var ifTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().is(POpen).childCount(2);
		ifExpr.first().is(Const(CIdent("test"))).oneChild().first().is(Binop(OpBoolAnd)).oneChild().first().is(Const(CIdent("test2"))).noChilds();
		ifExpr.last().is(PClose).noChilds();
		testifBody(ifTok);
	}

	@Test
	public function testIfExprAndExpr2() {
		var root:IVerifyTokenTree = buildTokenTree("if (test) && (test2) {doSomething();}");

		var ifTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdIf)).childCount(2);
		var ifExpr:IVerifyTokenTree = ifTok.first().is(POpen).childCount(3);
		ifExpr.first().is(Const(CIdent("test"))).noChilds();
		ifExpr.childAt(1).is(PClose).noChilds();
		ifExpr = ifExpr.last().is(Binop(OpBoolAnd)).oneChild().first().is(POpen).childCount(2);
		ifExpr.first().is(Const(CIdent("test2"))).noChilds();
		ifExpr.last().is(PClose).noChilds();
		testifBody(ifTok);
	}

	@Test
	public function testIfExprAndExpr3() {
		var root:IVerifyTokenTree = buildTokenTree("if test && test2 {doSomething();}");

		var ifTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdIf)).childCount(2);
		ifTok.first().is(Const(CIdent("test"))).oneChild().first().is(Binop(OpBoolAnd)).oneChild().first().is(Const(CIdent("test2"))).noChilds();
		testifBody(ifTok);
	}

	@Test
	public function testIfExprAndExpr4() {
		var root:IVerifyTokenTree = buildTokenTree("if test && test2 doSomething();");

		var ifTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdIf)).childCount(2);
		ifTok.first().is(Const(CIdent("test"))).oneChild().first().is(Binop(OpBoolAnd)).oneChild().first().is(Const(CIdent("test2"))).noChilds();

		var exprCall:IVerifyTokenTree = ifTok.last().is(Const(CIdent("doSomething"))).childCount(2);
		exprCall.first().is(POpen).oneChild().first().is(PClose).noChilds();
		exprCall.last().is(Semicolon).noChilds();
	}

	function testifBody(ifTok:IVerifyTokenTree) {
		var ifBody:IVerifyTokenTree = ifTok.last().is(BrOpen).childCount(2);
		var exprCall:IVerifyTokenTree = ifBody.first().is(Const(CIdent("doSomething"))).childCount(2);
		exprCall.first().is(POpen).oneChild().first().is(PClose).noChilds();
		exprCall.last().is(Semicolon).noChilds();
		ifBody.last().is(BrClose).noChilds();
	}

	override function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkIf.walkIf(stream, parent);
	}
}