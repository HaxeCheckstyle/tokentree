package tokentree;

import byte.ByteData;
import tokentree.walk.WalkFile;

class TokenTreeBuilder {
	public static function buildTokenTree(tokens:Array<Token>, bytes:ByteData):TokenTree {
		var stream:TokenStream = new TokenStream(tokens, bytes);
		var root:TokenTree = new TokenTree(null, "", null, -1);
		WalkFile.walkFile(stream, root);
		return root;
	}
}