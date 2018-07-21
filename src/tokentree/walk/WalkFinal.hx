package tokentree.walk;

class WalkFinal {
	public static function walkFinal(stream:TokenStream, parent:TokenTree) {
		var name:TokenTree = null;
		var finalTok:TokenTree = stream.consumeToken();
		stream.addToTempStore(finalTok);
		WalkComment.walkComment(stream, parent);
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Const(CIdent(_)):
					name = stream.consumeToken();
					break;
				case Kwd(KwdPublic), Kwd(KwdPrivate), Kwd(KwdStatic), Kwd(KwdInline), Kwd(KwdMacro), Kwd(KwdOverride), Kwd(KwdDynamic), Kwd(KwdExtern):
					stream.consumeToTempStore();
				case Comment(_), CommentLine(_):
					stream.consumeToTempStore();
				case Kwd(KwdFunction):
					return;
				default:
			}
		}
		parent.addChild(finalTok);
		stream.clearTempStore();
		var tempStore:Array<TokenTree> = stream.getTempStore();
		for (stored in tempStore) {
			switch (stored.tok) {
				case Kwd(KwdPublic), Kwd(KwdPrivate), Kwd(KwdStatic), Kwd(KwdInline), Kwd(KwdMacro), Kwd(KwdOverride), Kwd(KwdDynamic), Kwd(KwdExtern):
					finalTok.addChild(stored);
				case Comment(_), CommentLine(_):
					finalTok.addChild(stored);
				default:
			}
		}
		finalTok.addChild(name);
		WalkComment.walkComment(stream, name);
		if (stream.is(DblDot)) {
			var dblDot:TokenTree = stream.consumeTokenDef(DblDot);
			name.addChild(dblDot);
			WalkTypedefBody.walkTypedefAlias(stream, dblDot);
		}
		if (stream.is(Binop(OpAssign))) {
			WalkStatement.walkStatement(stream, name);
		}
		if (stream.is(Semicolon)) {
			name.addChild(stream.consumeTokenDef(Semicolon));
		}
	}
}