package tokentree.walk;

class WalkSwitch {
	/**
	 * Kwd(KwdSwitch)
	 *  |- POpen
	 *  |   |- expression
	 *  |   |- PClose
	 *  |- BrOpen
	 *      |- Kwd(KwdCase)
	 *      |   |- expression
	 *      |   |- DblDot
	 *      |       |- statement
	 *      |       |- statement
	 *      |- Kwd(KwdCase)
	 *      |   |- expression
	 *      |   |- DblDot
	 *      |       |- BrOpen
	 *      |           |- statement
	 *      |           |- BrClose
	 *      |- Kwd(KwdDefault)
	 *      |- BrClose
	 *
	 */
	public static function walkSwitch(stream:TokenStream, parent:TokenTree) {
		var switchTok:TokenTree = stream.consumeTokenDef(Kwd(KwdSwitch));
		parent.addChild(switchTok);
		WalkComment.walkComment(stream, switchTok);
		WalkStatement.walkStatement(stream, switchTok);
		WalkComment.walkComment(stream, switchTok);
		switch (stream.token()) {
			case Sharp(_):
				WalkSharp.walkSharp(stream, parent, WalkSwitch.walkSwitchCases);
			default:
		}
		if (stream.is(BrOpen)) {
			var brOpen:TokenTree = stream.consumeTokenDef(BrOpen);
			switchTok.addChild(brOpen);
			WalkSwitch.walkSwitchCases(stream, brOpen);
			brOpen.addChild(stream.consumeTokenDef(BrClose));
		}
	}

	public static function walkSwitchCases(stream:TokenStream, parent:TokenTree) {
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case BrClose:
					break;
				case Kwd(KwdCase), Kwd(KwdDefault):
					WalkSwitch.walkCase(stream, parent);
				case Sharp(_):
					WalkSharp.walkSharp(stream, parent, WalkSwitch.walkSwitchCases);
				case Comment(_), CommentLine(_):
					WalkComment.walkComment(stream, parent);
				default:
					WalkStatement.walkStatement(stream, parent);
			}
		}
	}

	/**
	 * Kwd(KwdCase) | Kwd(KwdDefault)
	 *  |- expression
	 *  |- DblDot
	 *      |- statement
	 *      |- statement
	 *
	 * Kwd(KwdCase) | Kwd(KwdDefault)
	 *  |- expression
	 *  |- DblDot
	 *      |- BrOpen
	 *          |- statement
	 *          |- BrClose
	 *
	 */
	public static function walkCase(stream:TokenStream, parent:TokenTree) {
		WalkComment.walkComment(stream, parent);
		var caseTok:TokenTree = stream.consumeToken();
		parent.addChild(caseTok);
		WalkSwitch.walkCaseExpr(stream, caseTok);
		var dblDot:TokenTree = stream.consumeTokenDef(DblDot);
		caseTok.addChild(dblDot);
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Kwd(KwdCase), Kwd(KwdDefault), BrClose:
					return;
				case BrOpen:
					WalkBlock.walkBlock(stream, dblDot);
				case Comment(_), CommentLine(_):
					WalkComment.walkComment(stream, dblDot);
				case Sharp(_):
					WalkSharp.walkSharp(stream, parent, WalkSwitch.walkSwitchCases);
					/*
					 * relocate sharp subtree from:
					 *  |- BrOpen
					 *      |- Kwd(KwdCase)
					 *      |   |- expression
					 *      |   |- DblDot
					 *      |       |- statement
					 *      |- Sharp(If)
					 *      |   |- condition
					 *      |   |- statement (if not a new case)
					 * to:
					 *      |- Kwd(KwdCase)
					 *      |   |- expression
					 *      |   |- DblDot
					 *      |       |- statement
					 *      |       |- Sharp(If)
					 *      |           |- condition
					 *      |           |- statement
					 */
					var sharp:TokenTree = parent.getLastChild();
					if (sharp.children.length < 2) continue;
					var body:TokenTree = sharp.children[1];
					if (body.is(Kwd(KwdCase))) continue;
					parent.children.pop();
					dblDot.addChild(sharp);
				default:
					WalkStatement.walkStatement(stream, dblDot);
			}
		}
	}

	static function walkCaseExpr(stream:TokenStream, parent:TokenTree) {
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Comma:
					var comma:TokenTree = stream.consumeTokenDef(Comma);
					var child:TokenTree = parent.getLastChild();
					if (child == null) child = parent;
					child.addChild(comma);
				case Semicolon, BrClose, BkClose, PClose, DblDot:
					return;
				case Kwd(KwdVar):
					var varTok:TokenTree = stream.consumeToken();
					parent.addChild(varTok);
					WalkStatement.walkStatement(stream, varTok);
				default:
					WalkStatement.walkStatement(stream, parent);
			}
		}
	}
}