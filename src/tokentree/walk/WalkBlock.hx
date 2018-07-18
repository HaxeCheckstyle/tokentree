package tokentree.walk;

class WalkBlock {
	/**
	 * BrOpen
	 *  |- statement
	 *  |- statement
	 *  |- BrClose
	 *
	 */
	public static function walkBlock(stream:TokenStream, parent:TokenTree) {
		while (stream.is(At)) stream.addToTempStore(WalkAt.walkAt(stream));
		var rewindPos:Int = stream.currentPos();
		if (stream.is(BrOpen)) {
			var openTok:TokenTree = stream.consumeTokenDef(BrOpen);
			parent.addChild(openTok);
			stream.applyTempStore(openTok);
			walkBlockContinue(stream, openTok);
		}
		else {
			stream.rewindTo(rewindPos);
			WalkStatement.walkStatement(stream, parent);
		}
	}

	public static function walkBlockContinue(stream:TokenStream, parent:TokenTree) {
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case BrClose: break;
				case Comma, BkClose, PClose:
					var child:TokenTree = stream.consumeToken();
					parent.addChild(child);
				default: WalkStatement.walkStatement(stream, parent);
			}
		}
		parent.addChild(stream.consumeTokenDef(BrClose));
	}
}