package tokentree.walk;

import tokentree.TokenStream;
import tokentree.TokenTree;
import tokentree.verify.IVerifyTokenTree;
import tokentree.verify.VerifyTokenTreeBase;

class WalkFileTest extends VerifyTokenTreeBase implements ITest {
	public function new() {}

	@Test
	public function testEmpty() {
		var root:IVerifyTokenTree = buildTokenTree("");
		root.childCount(0);
	}

	@Test
	public function testImportCompletion() {
		var root:IVerifyTokenTree = buildTokenTree("import MyModule.");
		root.oneChild().first().matches(Kwd(KwdImport)).oneChild().first().matches(Const(CIdent("MyModule"))).oneChild().first().matches(Dot).noChilds();
	}

	override function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkFile.walkFile(stream, parent);
	}
}