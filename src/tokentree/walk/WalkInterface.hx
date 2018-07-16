package tokentree.walk;

class WalkInterface {
	public static function walkInterface(stream:TokenStream, parent:TokenTree) {
		var typeTok:TokenTree = stream.consumeToken();
		parent.addChild(typeTok);
		// add name
		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, typeTok);
		// add all comments, annotations
		stream.applyTempStore(name);
		WalkExtends.walkExtends(stream, name);
		WalkImplements.walkImplements(stream, name);
		var block:TokenTree = stream.consumeTokenDef(BrOpen);
		name.addChild(block);
		WalkInterface.walkInterfaceBody(stream, block);
		block.addChild(stream.consumeTokenDef(BrClose));
	}

	public static function walkInterfaceBody(stream:TokenStream, parent:TokenTree) {
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Kwd(KwdVar):
					WalkVar.walkVar(stream, parent);
				case Kwd(KwdFunction):
					WalkFunction.walkFunction(stream, parent);
				case Sharp(_):
					WalkSharp.walkSharp(stream, parent, WalkInterface.walkInterfaceBody);
				case At:
					stream.addToTempStore(WalkAt.walkAt(stream));
				case BrClose: break;
				case Semicolon:
					parent.addChild(stream.consumeToken());
				case Comment(_), CommentLine(_):
					parent.addChild(stream.consumeToken());
				default:
					stream.consumeToTempStore();
			}
		}
		stream.applyTempStore(parent);
	}
}