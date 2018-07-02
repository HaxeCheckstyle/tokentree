package tokentree.walk;

class WalkEnum {
	public static function walkEnum(stream:TokenStream, parent:TokenTree, prefixes:Array<TokenTree>) {
		var typeTok:TokenTree = stream.consumeToken();
		parent.addChild(typeTok);
		if (stream.is(Kwd(KwdAbstract))) {
			WalkAbstract.walkAbstract(stream, typeTok, prefixes);
			return;
		}
		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, typeTok);
		// add all comments, annotations
		for (prefix in prefixes) name.addChild(prefix);
		WalkBlock.walkBlock(stream, name);
	}
}