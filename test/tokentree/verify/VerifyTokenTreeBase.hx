package tokentree.verify;

import haxe.PosInfos;
import tokentree.TokenTree;
import tokentree.walk.WalkFile;

class VerifyTokenTreeBase {
	function buildTokenTree(content:String, ?pos:PosInfos):IVerifyTokenTree {
		var root:TokenTree = new TokenTree(null, "", null, -1);
		var builder:TestTokenTreeBuilder = new TestTokenTreeBuilder(content, root);
		walkStream(builder.getTokenStream(), root);
		Assert.isTrue(builder.isStreamEmpty(), "there are still unused tokens in stream!!", pos);
		return new VerifyTokenTree(root);
	}

	function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkFile.walkFile(stream, parent);
	}
}