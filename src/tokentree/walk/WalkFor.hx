package tokentree.walk;

class WalkFor {
	/**
	 * Kwd(KwdFor)
	 *  |- POpen
	 *  |   |- Const(CIdent(_))
	 *  |   |   |- Kwd(KwdIn)
	 *  |   |       |- Const(CIdent(_)
	 *  |   |- PClose
	 *  |- BrOpen
	 *      |- statement
	 *      |- statement
	 *      |- BrClose
	 *
	 * Kwd(KwdFor)
	 *  |- POpen
	 *  |   |- Const(CIdent(_))
	 *  |   |   |- Kwd(KwdIn)
	 *  |   |       |- IntInterval(_)
	 *  |   |           |- Const(CInt(_))
	 *  |   |- PClose
	 *  |- BrOpen
	 *      |- statement
	 *      |- statement
	 *      |- BrClose
	 *
	 */
	public static function walkFor(stream:TokenStream, parent:TokenTree) {
		var forTok:TokenTree = stream.consumeTokenDef(Kwd(KwdFor));
		parent.addChild(forTok);
		WalkComment.walkComment(stream, forTok);
		WalkFor.walkForPOpen(stream, forTok);
		WalkComment.walkComment(stream, forTok);
		WalkBlock.walkBlock(stream, forTok);
	}

	/**
	 * POpen
	 *  |- Const(CIdent(_))
	 *  |   |- Kwd(KwdIn)
	 *  |       |- Const(CIdent(_)
	 *  |- PClose
	 *
	 * POpen
	 *  |- Const(CIdent(_))
	 *  |   |- Kwd(KwdIn)
	 *  |       |- IntInterval(_)
	 *  |           |- Const(CInt(_))
	 *  |- PClose
	 *
	 */
	static function walkForPOpen(stream:TokenStream, parent:TokenTree) {
		var pOpen:TokenTree = stream.consumeTokenDef(POpen);
		parent.addChild(pOpen);
		WalkComment.walkComment(stream, pOpen);
		var identifier:TokenTree = null;
		switch (stream.token()) {
			case Dollar(_):
				WalkStatement.walkStatement(stream, pOpen);
				identifier = pOpen.getLastChild();
			default:
				identifier = stream.consumeConstIdent();
				pOpen.addChild(identifier);
		}
		WalkComment.walkComment(stream, identifier);
		if (stream.is(Binop(OpArrow))) {
			var arrowTok:TokenTree = stream.consumeToken();
			identifier.addChild(arrowTok);
			var valueIdent:TokenTree = stream.consumeConstIdent();
			arrowTok.addChild(valueIdent);
		}
		var inTok:TokenTree = null;
		switch (stream.token()) {
			case #if (haxe_ver < 4.0) Kwd(KwdIn) #else Binop(OpIn) #end:
				inTok = stream.consumeToken();
				identifier.addChild(inTok);
				WalkComment.walkComment(stream, inTok);
				WalkStatement.walkStatement(stream, inTok);
				WalkComment.walkComment(stream, pOpen);
				pOpen.addChild(stream.consumeTokenDef(PClose));
				WalkComment.walkComment(stream, parent);
			case PClose:
				pOpen.addChild(stream.consumeTokenDef(PClose));
				WalkComment.walkComment(stream, parent);
				return;
			default:
		}
	}
}