package tokentree.walk;

class WalkTypedefBody {
	public static function walkTypedefBody(stream:TokenStream, parent:TokenTree) {
		if (stream.is(BrOpen)) {
			var openTok:TokenTree = stream.consumeTokenDef(BrOpen);
			parent.addChild(openTok);
			var progress:TokenStreamProgress = new TokenStreamProgress(stream);
			while (progress.streamHasChanged()) {
				switch (stream.token()) {
					case BrClose: break;
					case Binop(OpGt):
						walkStructureExtension(stream, openTok);
						continue;
					case Comment(_), CommentLine(_):
						WalkComment.walkComment(stream, openTok);
					case Kwd(KwdFunction):
						WalkFunction.walkFunction(stream, openTok);
					default:
						WalkFieldDef.walkFieldDef(stream, openTok);
				}
				WalkComment.walkComment(stream, openTok);
				if (stream.is(BrClose)) break;
				WalkFieldDef.walkFieldDef(stream, openTok);
			}
			openTok.addChild(stream.consumeTokenDef(BrClose));
		}
		else walkTypedefAlias(stream, parent);
		if (stream.is(Binop(OpAnd))) {
			var and:TokenTree = stream.consumeTokenDef(Binop(OpAnd));
			parent.getLastChild().addChild(and);
			walkTypedefBody(stream, and);
		}
	}

	public static function walkTypedefAlias(stream:TokenStream, parent:TokenTree) {
		var newParent:TokenTree;
		if (stream.is(POpen)) {
			newParent = WalkPOpen.walkPOpen(stream, parent);
		}
		else {
			newParent = WalkTypeNameDef.walkTypeNameDef(stream, parent);
		}
		if (stream.is(Arrow)) {
			var arrowTok:TokenTree = stream.consumeTokenDef(Arrow);
			newParent.addChild(arrowTok);
			walkTypedefAlias(stream, arrowTok);
		}
		if (stream.is(Semicolon)) {
			newParent.addChild(stream.consumeTokenDef(Semicolon));
		}
	}

	static function walkStructureExtension(stream:TokenStream, parent:TokenTree) {
		var gt:TokenTree = stream.consumeTokenDef(Binop(OpGt));
		parent.addChild(gt);
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		var name:TokenTree = stream.consumeToken();
		gt.addChild(name);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Comma: break;
				default:
					var child:TokenTree = stream.consumeToken();
					name.addChild(child);
					name = child;
			}
		}
		gt.addChild(stream.consumeToken());
	}
}