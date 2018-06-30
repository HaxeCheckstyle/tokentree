package tokentree.verify;

import massive.munit.Assert;

import tokentree.TokenTree;

import tokentree.walk.WalkFile;

class VerifyTokenTreeBase {

	function buildTokenTree(content:String):IVerifyTokenTree {
		var builder:TestTokenTreeBuilder = new TestTokenTreeBuilder(content);
		var root:TokenTree = new TokenTree(null, "", null, -1);
		walkStream(builder.getTokenStream(), root);
		Assert.isTrue(builder.isStreamEmpty());
		return new VerifyTokenTree(root);
	}

	function walkStream(stream:TokenStream, parent:TokenTree) {
		WalkFile.walkFile(stream, parent);
	}
}