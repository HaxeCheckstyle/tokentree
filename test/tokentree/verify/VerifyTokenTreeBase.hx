package tokentree.verify;

import haxe.PosInfos;
import massive.munit.Assert;
import tokentree.TokenTree;
import tokentree.walk.WalkFile;

class VerifyTokenTreeBase {
	function buildTokenTree(content:String, ?pos:PosInfos):IVerifyTokenTree {
		var builder:TestTokenTreeBuilder = new TestTokenTreeBuilder(content);
		var root:TokenTree = new TokenTree(null, "", null, -1);
		walkStream(builder.getTokenStream(), root);
		Assert.isTrue(builder.isStreamEmpty(), "there are still unused tokens in stream!!", pos);
		return new VerifyTokenTree(root);
	}

	function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkFile.walkFile(stream, parent);
	}
}