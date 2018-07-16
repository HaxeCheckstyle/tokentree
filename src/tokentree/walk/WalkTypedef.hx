package tokentree.walk;

class WalkTypedef {
	public static function walkTypedef(stream:TokenStream, parent:TokenTree) {
		var typeTok:TokenTree = stream.consumeToken();
		parent.addChild(typeTok);
		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, typeTok);
		// add all comments, annotations
		stream.applyTempStore(name);
		var assign:TokenTree = stream.consumeTokenDef(Binop(OpAssign));
		name.addChild(assign);
		WalkTypedefBody.walkTypedefBody(stream, assign);
	}
}