package tokentree.walk;

import tokentree.TokenTree;
import tokentree.TokenStream;
import tokentree.verify.IVerifyTokenTree;
import tokentree.verify.VerifyTokenTreeBase;

class WalkWhileTest extends VerifyTokenTreeBase {
	@Test
	public function testWhile() {
		var root:IVerifyTokenTree = buildTokenTree("while (test) {doSomething();}");

		var whileTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdWhile)).childCount(2);
		var ifExpr:IVerifyTokenTree = whileTok.first().matches(POpen).childCount(2);
		ifExpr.first().matches(Const(CIdent("test"))).noChilds();
		ifExpr.last().matches(PClose).noChilds();
		testWhileBody(whileTok);
	}

	@Test
	public function testWhileExprAndExpr() {
		var root:IVerifyTokenTree = buildTokenTree("while (test && test2) {doSomething();}");

		var whileTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdWhile)).childCount(2);
		var ifExpr:IVerifyTokenTree = whileTok.first().matches(POpen).childCount(2);
		ifExpr.first().matches(Const(CIdent("test"))).oneChild().first().matches(Binop(OpBoolAnd)).oneChild().first().matches(Const(CIdent("test2"))).noChilds();
		ifExpr.last().matches(PClose).noChilds();
		testWhileBody(whileTok);
	}

	@Test
	public function testIfExprAndExpr2() {
		var root:IVerifyTokenTree = buildTokenTree("while (test) && (test2) {doSomething();}");

		var whileTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdWhile)).childCount(2);
		var ifExpr:IVerifyTokenTree = whileTok.first().matches(POpen).childCount(3);
		ifExpr.first().matches(Const(CIdent("test"))).noChilds();
		ifExpr.childAt(1).matches(PClose).noChilds();
		ifExpr = ifExpr.last().matches(Binop(OpBoolAnd)).oneChild().first().matches(POpen).childCount(2);
		ifExpr.first().matches(Const(CIdent("test2"))).noChilds();
		ifExpr.last().matches(PClose).noChilds();
		testWhileBody(whileTok);
	}

	@Test
	public function testIfExprAndExpr3() {
		var root:IVerifyTokenTree = buildTokenTree("while test && test2 {doSomething();}");

		var whileTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdWhile)).childCount(2);
		whileTok.first().matches(Const(CIdent("test"))).oneChild().first().matches(Binop(OpBoolAnd)).oneChild().first().matches(Const(CIdent("test2"))).noChilds();
		testWhileBody(whileTok);
	}

	@Test
	public function testIfExprAndExpr4() {
		var root:IVerifyTokenTree = buildTokenTree("while test && test2 doSomething();");

		var whileTok:IVerifyTokenTree = root.oneChild().first().matches(Kwd(KwdWhile)).childCount(2);
		whileTok.first().matches(Const(CIdent("test"))).oneChild().first().matches(Binop(OpBoolAnd)).oneChild().first().matches(Const(CIdent("test2"))).noChilds();

		var exprCall:IVerifyTokenTree = whileTok.last().matches(Const(CIdent("doSomething"))).childCount(2);
		exprCall.first().matches(POpen).childCount(1).first().matches(PClose).noChilds();
		exprCall.last().matches(Semicolon).noChilds();
	}

	function testWhileBody(whileTok:IVerifyTokenTree) {
		var ifBody:IVerifyTokenTree = whileTok.last().matches(BrOpen).childCount(2);
		var exprCall:IVerifyTokenTree = ifBody.first().matches(Const(CIdent("doSomething"))).childCount(2);
		exprCall.first().matches(POpen).childCount(1).first().matches(PClose).noChilds();
		exprCall.last().matches(Semicolon).noChilds();
		ifBody.last().matches(BrClose).noChilds();
	}

	override function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkWhile.walkWhile(stream, parent);
	}
}