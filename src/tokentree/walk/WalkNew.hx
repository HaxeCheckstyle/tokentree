package tokentree.walk;

class WalkNew {
	public static function walkNew(stream:TokenStream, parent:TokenTree) {
		var newTok:TokenTree = stream.consumeTokenDef(Kwd(KwdNew));
		parent.addChild(newTok);
		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, newTok);

		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Binop(OpGt):
					var gt:TokenTree = stream.consumeTokenDef(Binop(OpGt));
					name.addChild(gt);
				default:
			}
		}
		switch (stream.token()) {
			case POpen:
				WalkPOpen.walkPOpen(stream, name);
			case Sharp(_):
				WalkSharp.walkSharp(stream, parent, WalkStatement.walkStatement);
			default:
		}
		if (stream.is(Dot)) {
			WalkStatement.walkStatement(stream, name);
		}
	}
}