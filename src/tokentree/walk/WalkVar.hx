package tokentree.walk;

class WalkVar {
	public static function walkVar(stream:TokenStream, parent:TokenTree) {
		var name:TokenTree = null;
		var varTok:TokenTree = stream.consumeTokenDef(Kwd(KwdVar));
		parent.addChild(varTok);
		WalkComment.walkComment(stream, parent);
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			if (stream.is(Kwd(KwdVar))) {
				return;
			}
			WalkComment.walkComment(stream, parent);
			var nameParent:TokenTree = varTok;
			if (stream.is(Question)) {
				nameParent = stream.consumeToken();
				varTok.addChild(nameParent);
			}
			name = stream.consumeConstIdent();
			nameParent.addChild(name);
			stream.applyTempStore(name);
			WalkComment.walkComment(stream, name);
			if (stream.is(POpen)) {
				WalkPOpen.walkPOpen(stream, name);
			}
			if (stream.is(DblDot)) {
				var dblDot:TokenTree = stream.consumeTokenDef(DblDot);
				name.addChild(dblDot);
				WalkTypedefBody.walkTypedefAlias(stream, dblDot);
			}
			if (stream.is(Binop(OpAssign))) {
				WalkStatement.walkStatement(stream, name);
			}
			if (stream.is(Comma)) {
				var comma:TokenTree = stream.consumeTokenDef(Comma);
				name.addChild(comma);
				continue;
			}
			break;
		}
		if (stream.is(Semicolon)) {
			name.addChild(stream.consumeTokenDef(Semicolon));
		}
	}
}