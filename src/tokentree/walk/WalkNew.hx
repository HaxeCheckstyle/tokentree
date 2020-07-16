package tokentree.walk;

class WalkNew {
	public static function walkNew(stream:TokenStream, parent:TokenTree) {
		var newTok:TokenTree = stream.consumeTokenDef(Kwd(KwdNew));
		parent.addChild(newTok);
		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, newTok);

		WalkComment.walkComment(stream, name);
		switch (stream.token()) {
			case POpen:
				WalkPOpen.walkPOpen(stream, name);
			case Sharp(_):
				WalkSharp.walkSharp(stream, parent, WalkStatement.walkStatement);
			default:
		}
		WalkComment.walkComment(stream, name);
		if (stream.tokenForMatch().match(Dot)) {
			WalkStatement.walkStatement(stream, name);
		}
	}
}