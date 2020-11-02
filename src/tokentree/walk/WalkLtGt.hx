package tokentree.walk;

class WalkLtGt {
	public static function walkLtGt(stream:TokenStream, parent:TokenTree) {
		var ltTok:TokenTree = stream.consumeTokenDef(Binop(OpLt));
		parent.addChild(ltTok);
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Comma:
					var comma:TokenTree = stream.consumeToken();
					ltTok.addChild(comma);
					WalkTypeNameDef.walkTypeNameDef(stream, ltTok);
					WalkFieldDef.walkFieldDef(stream, ltTok);
				case Binop(OpGt):
					break;
				case DblDot:
					var dblDot:TokenTree = stream.consumeToken();
					ltTok.addChild(dblDot);
					WalkTypeNameDef.walkTypeNameDef(stream, ltTok);
				case POpen:
					WalkPOpen.walkPOpen(stream, ltTok);
				default:
					WalkFieldDef.walkFieldDef(stream, ltTok);
			}
		}
		ltTok.addChild(stream.consumeTokenDef(Binop(OpGt)));
	}
}