package tokentree.walk;

class WalkAt {
	/**
	 * At
	 *  |- DblDot
	 *      |- Const(CIdent)
	 *          |- POpen
	 *              |- expression
	 *              |- PClose
	 *
	 * At
	 *  |- DblDot
	 *      |- Const(CIdent)
	 *
	 * At
	 *  |- Const(CIdent)
	 *      |- POpen
	 *          |- expression
	 *          |- PClose
	 *
	 * At
	 *  |- Const(CIdent)
	 *
	 */
	public static function walkAt(stream:TokenStream):TokenTree {
		var atTok:TokenTree = stream.consumeTokenDef(At);
		var parent:TokenTree = atTok;
		if (stream.is(DblDot)) {
			var dblDot:TokenTree = stream.consumeTokenDef(DblDot);
			atTok.addChild(dblDot);
			parent = dblDot;
		}
		walkIdent(stream, parent);
		return atTok;
	}

	static function walkIdent(stream:TokenStream, parent:TokenTree) {
		var ident:TokenTree;
		switch (stream.token()) {
			case Const(CIdent(_)):
				ident = stream.consumeConstIdent();
			case Kwd(KwdDefault):
				ident = stream.consumeToken();
			case Kwd(KwdExtern):
				ident = stream.consumeToken();
			case Kwd(KwdEnum):
				ident = stream.consumeToken();
			#if (haxe_ver >= 4.0)
			case Kwd(KwdFinal):
				ident = stream.consumeToken();
			#end
			case Kwd(KwdAbstract):
				ident = stream.consumeToken();
			default:
				return;
		}
		parent.addChild(ident);
		switch (stream.token()) {
			case Dot:
				var child:TokenTree = stream.consumeToken();
				ident.addChild(child);
				walkIdent(stream, child);
			case POpen:
				WalkPOpen.walkPOpen(stream, ident);
			default:
		}
	}

	public static function walkAts(stream:TokenStream) {
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case At:
					stream.addToTempStore(WalkAt.walkAt(stream));
				default:
			}
		}
	}
}