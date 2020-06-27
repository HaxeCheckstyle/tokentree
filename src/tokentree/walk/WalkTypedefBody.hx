package tokentree.walk;

class WalkTypedefBody {
	public static function walkTypedefBody(stream:TokenStream, parent:TokenTree) {
		if (stream.is(BrOpen)) {
			var openTok:TokenTree = stream.consumeTokenDef(BrOpen);
			parent.addChild(openTok);
			walkTypedefCurlyBody(stream, openTok);
			openTok.addChild(stream.consumeTokenDef(BrClose));
		}
		else {
			walkTypedefAlias(stream, parent);
		}
		if (stream.is(Binop(OpAnd))) {
			var and:TokenTree = stream.consumeTokenDef(Binop(OpAnd));
			parent.getLastChild().addChild(and);
			walkTypedefBody(stream, parent);
		}
		if (stream.is(Arrow)) {
			WalkStatement.walkStatement(stream, parent);
		}
	}

	public static function walkTypedefCurlyBody(stream:TokenStream, openTok:TokenTree) {
		var progress:TokenStreamProgress = new TokenStreamProgress(stream);
		while (progress.streamHasChanged()) {
			switch (stream.token()) {
				case At:
					stream.addToTempStore(WalkAt.walkAt(stream));
				case BrClose:
					break;
				case Sharp(_):
					WalkSharp.walkSharp(stream, openTok, WalkTypedefBody.walkTypedefCurlyBody);
				case Binop(OpGt):
					walkStructureExtension(stream, openTok);
				case Comment(_), CommentLine(_):
					WalkComment.walkComment(stream, openTok);
				case Kwd(KwdFunction):
					WalkFunction.walkFunction(stream, openTok);
				case Kwd(KwdVar):
					WalkVar.walkVar(stream, openTok);
				case Kwd(KwdPublic), Kwd(KwdPrivate), Kwd(KwdStatic), Kwd(KwdInline), Kwd(KwdMacro), Kwd(KwdOverride), Kwd(KwdDynamic), Kwd(KwdExtern):
					stream.consumeToTempStore();
				case Const(CIdent("final")):
					WalkFinal.walkFinal(stream, openTok);
				#if (haxe_ver >= 4.0)
				case Kwd(KwdFinal):
					WalkFinal.walkFinal(stream, openTok);
				#end
				default:
					WalkFieldDef.walkFieldDef(stream, openTok);
			}
		}
		var tempStore:Array<TokenTree> = stream.getTempStore();
		if (tempStore.length > 0) {
			switch (TokenStream.MODE) {
				case Relaxed:
					stream.applyTempStore(openTok);
				case Strict:
					throw "invalid token tree structure - found:" + '$tempStore';
			}
		}
	}

	public static function walkTypedefAlias(stream:TokenStream, parent:TokenTree) {
		var newParent:TokenTree;
		if (stream.is(POpen)) {
			newParent = WalkPOpen.walkPOpen(stream, parent);
		}
		else {
			newParent = WalkTypeNameDef.walkTypeNameDef(stream, parent);
		}
		if (stream.is(Arrow)) {
			var arrowTok:TokenTree = stream.consumeTokenDef(Arrow);
			newParent.addChild(arrowTok);
			walkTypedefAlias(stream, arrowTok);
		}
		if (stream.is(Semicolon)) {
			newParent.addChild(stream.consumeTokenDef(Semicolon));
		}
	}

	static function walkStructureExtension(stream:TokenStream, parent:TokenTree) {
		var gt:TokenTree = stream.consumeTokenDef(Binop(OpGt));
		parent.addChild(gt);
		var name:TokenTree = WalkTypeNameDef.walkTypeNameDef(stream, parent);
		gt.addChild(name);
		if (stream.is(Comma)) {
			name.addChild(stream.consumeToken());
		}
	}
}