package tokentree.walk;

class WalkFinal {
	public static function walkFinal(stream:TokenStream, parent:TokenTree) {
		var name:Null<TokenTree> = null;
		var finalTok:TokenTree = stream.consumeToken();
		stream.addToTempStore(finalTok);
		WalkComment.walkComment(stream, parent);
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Const(CIdent(_)):
					name = stream.consumeToken();
					break;
				case Question:
					var nameParent:TokenTree = stream.consumeToken();
					name = stream.consumeConstIdent();
					nameParent.addChild(name);
					name = nameParent;
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
		var tempStore:Array<TokenTree> = stream.getTempStore();
		for (stored in tempStore) {
			switch (stored.tok) {
				case Const(CIdent("final")):
				#if (haxe_ver >= 4.0)
				case Kwd(KwdFinal):
				#end
				default:
					name.addChild(stored);
			}
		}
		stream.clearTempStore();
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