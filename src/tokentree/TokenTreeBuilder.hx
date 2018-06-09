package tokentree;

import byte.ByteData;

import tokentree.walk.WalkFile;
import tokentree.walk.WalkSharp;

class TokenTreeBuilder {
	public static function buildTokenTree(tokens:Array<Token>, bytes:ByteData):TokenTree {
		// WalkSharp is not thread safe!!
		WalkSharp.clear();

		var stream:TokenStream = new TokenStream(tokens, bytes);
		var root:TokenTree = new TokenTree(null, null, -1);
		WalkFile.walkFile(stream, root);
		return root;
	}
}