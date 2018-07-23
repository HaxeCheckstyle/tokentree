package tokentree.walk;

class WalkFieldDef {
	public static function walkFieldDef(stream:TokenStream, parent:TokenTree) {
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Kwd(KwdVar), Kwd(KwdFunction), Const(CIdent("final")):
					var tok:TokenTree = stream.consumeToken();
					parent.addChild(tok);
					parent = tok;
				#if (haxe_ver >= 4.0)
				case Kwd(KwdFinal):
					var tok:TokenTree = stream.consumeToken();
					parent.addChild(tok);
					parent = tok;
				#end
				case At:
					stream.addToTempStore(WalkAt.walkAt(stream));
				case Comment(_), CommentLine(_):
					WalkComment.walkComment(stream, parent);
				default:
					break;
			}
		}

		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, parent);
		stream.applyTempStore(name);
		if (stream.is(DblDot)) {
			var dblDot:TokenTree = stream.consumeTokenDef(DblDot);
			name.addChild(dblDot);
			WalkTypedefBody.walkTypedefBody(stream, dblDot);
		}
		if (stream.is(Binop(OpAssign))) {
			WalkStatement.walkStatement(stream, name);
		}
		switch (stream.token()) {
			case Comma:
				name.addChild(stream.consumeTokenDef(Comma));
			case Semicolon:
				name.addChild(stream.consumeTokenDef(Semicolon));
			default:
		}
	}
}