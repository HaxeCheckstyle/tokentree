package tokentree;

import byte.ByteData;
import tokentree.walk.WalkClass;
import tokentree.walk.WalkFile;
import tokentree.walk.WalkStatement;

class TokenTreeBuilder {
	public static function buildTokenTree(tokens:Array<Token>, bytes:ByteData, entryPoint:Null<TokenTreeEntryPoint>):TokenTree {
		if (entryPoint == null) {
			entryPoint = TYPE_LEVEL;
		}
		return buildTokenTreeFromStream(new TokenStream(tokens, bytes), entryPoint);
	}

	static function buildTokenTreeFromStream(stream:TokenStream, entryPoint:TokenTreeEntryPoint):TokenTree {
		var root:TokenTree = new TokenTree(null, "", null, -1);
		switch (entryPoint) {
			case TYPE_LEVEL:
				WalkFile.walkFile(stream, root);
			case FIELD_LEVEL:
				WalkClass.walkClassBody(stream, root);
			case EXPRESSION_LEVEL:
				WalkStatement.walkStatement(stream, root);
		}
		if (stream.hasMore()) {
			// stream is not empty!
			switch (TokenStream.MODE) {
				case RELAXED:
					var progress:TokenStreamProgress = new TokenStreamProgress(stream);
					while (progress.streamHasChanged()) {
						WalkStatement.walkStatement(stream, root);
					}
					if (stream.hasMore()) {
						throw "invalid token tree structure - found:" + stream.token();
					}
				case STRICT:
					throw "invalid token tree structure - found:" + stream.token();
			}
		}
		var tempStore:Array<TokenTree> = stream.getTempStore();
		switch (TokenStream.MODE) {
			case STRICT:
				if (tempStore.length != 0) {
					throw "invalid token tree structure - tokens in temp store:" + tempStore.join(", ");
				}
			case RELAXED:
				for (stored in tempStore) {
					root.addChild(stored);
				}
		}
		return root;
	}
}

enum TokenTreeEntryPoint {
	TYPE_LEVEL;
	FIELD_LEVEL;
	EXPRESSION_LEVEL;
}