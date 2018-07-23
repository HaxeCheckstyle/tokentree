package tokentree.walk;

import tokentree.TokenTree;
import tokentree.TokenStream;
import tokentree.verify.IVerifyTokenTree;
import tokentree.verify.VerifyTokenTreeBase;

class WalkWhileTest extends VerifyTokenTreeBase {
	@Test
	public function testWhile() {
		var root:IVerifyTokenTree = buildTokenTree("while (test) {doSomething();}");

		var whileTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdWhile)).childCount(2);
		var ifExpr:IVerifyTokenTree = whileTok.first().is(POpen).childCount(2);
		ifExpr.first().is(Const(CIdent("test"))).noChilds();
		ifExpr.last().is(PClose).noChilds();
		testWhileBody(whileTok);
	}

	@Test
	public function testWhileExprAndExpr() {
		var root:IVerifyTokenTree = buildTokenTree("while (test && test2) {doSomething();}");

		var whileTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdWhile)).childCount(2);
		var ifExpr:IVerifyTokenTree = whileTok.first().is(POpen).childCount(2);
		ifExpr.first().is(Const(CIdent("test"))).oneChild().first().is(Binop(OpBoolAnd)).oneChild().first().is(Const(CIdent("test2"))).noChilds();
		ifExpr.last().is(PClose).noChilds();
		testWhileBody(whileTok);
	}

	@Test
	public function testIfExprAndExpr2() {
		var root:IVerifyTokenTree = buildTokenTree("while (test) && (test2) {doSomething();}");

		var whileTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdWhile)).childCount(2);
		var ifExpr:IVerifyTokenTree = whileTok.first().is(POpen).childCount(3);
		ifExpr.first().is(Const(CIdent("test"))).noChilds();
		ifExpr.childAt(1).is(PClose).noChilds();
		ifExpr = ifExpr.last().is(Binop(OpBoolAnd)).oneChild().first().is(POpen).childCount(2);
		ifExpr.first().is(Const(CIdent("test2"))).noChilds();
		ifExpr.last().is(PClose).noChilds();
		testWhileBody(whileTok);
	}

	@Test
	public function testIfExprAndExpr3() {
		var root:IVerifyTokenTree = buildTokenTree("while test && test2 {doSomething();}");

		var whileTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdWhile)).childCount(2);
		whileTok.first().is(Const(CIdent("test"))).oneChild().first().is(Binop(OpBoolAnd)).oneChild().first().is(Const(CIdent("test2"))).noChilds();
		testWhileBody(whileTok);
	}

	@Test
	public function testIfExprAndExpr4() {
		var root:IVerifyTokenTree = buildTokenTree("while test && test2 doSomething();");

		var whileTok:IVerifyTokenTree = root.oneChild().first().is(Kwd(KwdWhile)).childCount(2);
		whileTok.first().is(Const(CIdent("test"))).oneChild().first().is(Binop(OpBoolAnd)).oneChild().first().is(Const(CIdent("test2"))).noChilds();

		var exprCall:IVerifyTokenTree = whileTok.last().is(Const(CIdent("doSomething"))).childCount(2);
		exprCall.first().is(POpen).oneChild().first().is(PClose).noChilds();
		exprCall.last().is(Semicolon).noChilds();
	}

	function testWhileBody(whileTok:IVerifyTokenTree) {
		var ifBody:IVerifyTokenTree = whileTok.last().is(BrOpen).childCount(2);
		var exprCall:IVerifyTokenTree = ifBody.first().is(Const(CIdent("doSomething"))).childCount(2);
		exprCall.first().is(POpen).oneChild().first().is(PClose).noChilds();
		exprCall.last().is(Semicolon).noChilds();
		ifBody.last().is(BrClose).noChilds();
	}

	override function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkWhile.walkWhile(stream, parent);
	}
}