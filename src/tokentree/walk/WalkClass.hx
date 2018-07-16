package tokentree.walk;

import tokentree.TokenTreeAccessHelper;

class WalkClass {

	public static function walkClass(stream:TokenStream, parent:TokenTree) {
		var typeTok:TokenTree = stream.consumeToken();
		parent.addChild(typeTok);
		WalkComment.walkComment(stream, parent);
		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, typeTok);
		// add all comments, annotations
		stream.applyTempStore(name);
		if (stream.isSharp()) WalkSharp.walkSharp(stream, name, WalkClass.walkClassExtends);
		WalkClass.walkClassExtends(stream, name);
		var block:TokenTree = stream.consumeTokenDef(BrOpen);
		name.addChild(block);
		WalkClass.walkClassBody(stream, block);
		block.addChild(stream.consumeTokenDef(BrClose));
	}

	public static function walkClassExtends(stream:TokenStream, name:TokenTree) {
		WalkExtends.walkExtends(stream, name);
		if (stream.isSharp()) WalkSharp.walkSharp(stream, name, WalkClass.walkClassExtends);
		WalkImplements.walkImplements(stream, name);
		if (stream.isSharp()) WalkSharp.walkSharp(stream, name, WalkClass.walkClassExtends);
		WalkComment.walkComment(stream, name);
	}

	public static function walkClassBody(stream:TokenStream, parent:TokenTree) {
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case Kwd(KwdVar):
					WalkVar.walkVar(stream, parent);
				case Kwd(KwdFunction):
					WalkFunction.walkFunction(stream, parent);
				case Sharp(_):
					WalkSharp.walkSharp(stream, parent, WalkClass.walkClassBody);
					walkClassContinueAfterSharp(stream, parent);
				case At:
					stream.addToTempStore(WalkAt.walkAt(stream));
				case BrClose: break;
				case Semicolon:
					parent.addChild(stream.consumeToken());
				case Kwd(KwdPublic),
						Kwd(KwdPrivate),
						Kwd(KwdStatic),
						Kwd(KwdInline),
						Kwd(KwdMacro),
						Kwd(KwdOverride),
						Kwd(KwdDynamic),
						Kwd(KwdExtern):
					stream.consumeToTempStore();
				case Const(CIdent("final")):
					stream.consumeToTempStore();
				// #if (haxe_ver >= 4.0)
				// case Kwd(KwdFinal):
				// stream.consumeToTempStore();
				// #end
				case Comment(_), CommentLine(_):
					parent.addChild(stream.consumeToken());
				default:
					switch (TokenStream.MODE) {
						case RELAXED: WalkStatement.walkStatement(stream, parent);
						case STRICT: throw "invalid token tree structure - found:" + '${stream.token()}';
					}
			}
		}
		var tempStore:Array<TokenTree> = stream.getTempStore();
		if (tempStore.length > 0) {
			switch (TokenStream.MODE) {
				case RELAXED: stream.applyTempStore(parent);
				case STRICT: throw "invalid token tree structure - found:" + '$tempStore';
			}
		}
	}

	static function walkClassContinueAfterSharp(stream:TokenStream, parent:TokenTree) {
		var brOpen:TokenTreeAccessHelper = TokenTreeAccessHelper
			.access(parent)
			.lastChild().is(Sharp("if"))
			.lastOf(Kwd(KwdFunction))
			.firstChild()
			.lastChild()
			.is(BrOpen);
		if (brOpen.token == null) return;
		if (brOpen.lastChild().is(BrClose).token != null) return;
		WalkBlock.walkBlockContinue(stream, parent);
	}
}