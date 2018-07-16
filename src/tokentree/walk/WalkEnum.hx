package tokentree.walk;

class WalkEnum {
	public static function walkEnum(stream:TokenStream, parent:TokenTree) {
		var typeTok:TokenTree = stream.consumeToken();
		parent.addChild(typeTok);
		if (stream.is(Kwd(KwdAbstract))) {
			WalkAbstract.walkAbstract(stream, typeTok);
			return;
		}
		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, typeTok);
		// add all comments, annotations
		stream.applyTempStore(name);
		WalkBlock.walkBlock(stream, name);
	}
}