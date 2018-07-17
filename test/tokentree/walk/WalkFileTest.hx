package tokentree.walk;

import tokentree.TokenTree;
import tokentree.TokenStream;

import tokentree.verify.IVerifyTokenTree;
import tokentree.verify.VerifyTokenTreeBase;

class WalkFileTest extends VerifyTokenTreeBase {

	@Test
	public function testEmpty() {
		var root:IVerifyTokenTree = buildTokenTree("");
		root.childCount(0);
	}

	@Test
	public function testImportCompletion() {
		var root:IVerifyTokenTree = buildTokenTree("import MyModule.");
		root.oneChild().first().is(Kwd(KwdImport)).oneChild().first().is(Const(CIdent("MyModule"))).oneChild().first().is(Dot).noChilds();
	}

	override function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkFile.walkFile(stream, parent);
	}
}