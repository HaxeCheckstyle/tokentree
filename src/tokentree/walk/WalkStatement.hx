package tokentree.walk;

class WalkStatement {
	public static function walkStatement(stream:TokenStream, parent:TokenTree) {
		WalkComment.walkComment(stream, parent);

		var wantMore:Bool = true;

		WalkAt.walkAts(stream);
		switch (stream.token()) {
			case Binop(OpSub):
				WalkBinopSub.walkBinopSub(stream, parent);
				return;
			case Binop(OpLt):
				if (stream.isTypedParam()) {
					WalkLtGt.walkLtGt(stream, parent);
					return;
				}
				wantMore = true;
			case Binop(OpGt):
				var gtTok:TokenTree = stream.consumeOpGt();
				parent.addChild(gtTok);
				WalkStatement.walkStatement(stream, gtTok);
				return;
			case Binop(_):
				wantMore = true;
			case Unop(_):
				if (parent.tok.match(Const(_))) wantMore = false;
			case IntInterval(_):
				wantMore = true;
			case Kwd(_):
				if (WalkStatement.walkKeyword(stream, parent)) wantMore = true;
				else return;
			case Arrow:
				wantMore = true;
			case BrOpen:
				WalkBlock.walkBlock(stream, parent);
				return;
			case BkOpen:
				WalkArrayAccess.walkArrayAccess(stream, parent);
				WalkStatement.walkStatementContinue(stream, parent);
				return;
			case Dollar(_):
				var dollarTok:TokenTree = stream.consumeToken();
				parent.addChild(dollarTok);
				WalkBlock.walkBlock(stream, dollarTok);
				return;
			case POpen:
				var pOpen:TokenTree = WalkPOpen.walkPOpen(stream, parent);
				if (parent.isCIdent()) {
					WalkStatement.walkStatementContinue(stream, parent);
				}
				else {
					if (parent.is(Kwd(KwdIf)) && stream.is(Binop(OpSub))) {
						return;
					}
					WalkStatement.walkStatementContinue(stream, pOpen);
				}
				return;
			case Question:
				WalkQuestion.walkQuestion(stream, parent);
				return;
			case PClose, BrClose, BkClose:
				return;
			case Comma:
				return;
			case Sharp(_):
				WalkSharp.walkSharp(stream, parent, WalkStatement.walkStatement);
				return;
			case Dot, DblDot:
				wantMore = true;
			default:
				wantMore = false;
		}
		var newChild:TokenTree = stream.consumeToken();
		parent.addChild(newChild);
		stream.applyTempStore(newChild);
		if (wantMore) WalkStatement.walkStatement(stream, newChild);
		WalkStatement.walkStatementContinue(stream, newChild);
		walkTrailingComment(stream, newChild);
	}

	public static function walkTrailingComment(stream:TokenStream, parent:TokenTree) {
		if (!stream.hasMore()) {
			return;
		}
		switch (stream.token()) {
			case CommentLine(_):
				var currentPos:Int = stream.getCurrentPos();
				var commentTok:TokenTree = stream.consumeToken();
				if (!stream.is(Kwd(KwdElse))) {
					stream.rewindTo(currentPos);
					return;
				}
				parent.addChild(commentTok);
			default:
		}
	}

	public static function walkStatementContinue(stream:TokenStream, parent:TokenTree) {
		if (!stream.hasMore()) return;
		switch (stream.token()) {
			case Dot:
				WalkStatement.walkStatement(stream, parent);
			case DblDot:
				walkDblDot(stream, parent);
			case Arrow:
				WalkStatement.walkStatement(stream, parent);
			case Binop(_), Unop(_):
				WalkStatement.walkStatement(stream, parent);
			case Question:
				WalkQuestion.walkQuestion(stream, parent);
			case Semicolon:
				WalkStatement.walkStatement(stream, parent);
			case BkOpen:
				WalkStatement.walkStatement(stream, parent);
			case POpen:
				WalkStatement.walkStatement(stream, parent);
			default:
		}
	}

	static function walkKeyword(stream:TokenStream, parent:TokenTree):Bool {
		switch (stream.token()) {
			case Kwd(KwdVar):
				WalkVar.walkVar(stream, parent);
			case Kwd(KwdNew):
				if (parent.is(Dot)) {
					var newChild:TokenTree = stream.consumeToken();
					parent.addChild(newChild);
					WalkStatement.walkStatementContinue(stream, newChild);
				}
				else {
					WalkNew.walkNew(stream, parent);
				}
			case Kwd(KwdFor):
				WalkFor.walkFor(stream, parent);
			case Kwd(KwdFunction):
				WalkFunction.walkFunction(stream, parent);
			case Kwd(KwdClass):
				WalkClass.walkClass(stream, parent);
			case Kwd(KwdMacro), Kwd(KwdReturn):
				return true;
			case Kwd(KwdSwitch):
				WalkSwitch.walkSwitch(stream, parent);
			case Kwd(KwdCase):
				return false;
			case Kwd(KwdDefault):
				// switch or property
				if (parent.is(BrOpen)) return false;
				return true;
			case Kwd(KwdIf):
				WalkIf.walkIf(stream, parent);
			case Kwd(KwdTry):
				WalkTry.walkTry(stream, parent);
			case Kwd(KwdDo):
				WalkDoWhile.walkDoWhile(stream, parent);
			case Kwd(KwdWhile):
				WalkWhile.walkWhile(stream, parent);
			case Kwd(KwdNull), Kwd(KwdTrue), Kwd(KwdFalse):
				var newChild:TokenTree = stream.consumeToken();
				parent.addChild(newChild);
				switch (stream.token()) {
					case Semicolon:
						newChild.addChild(stream.consumeToken());
					case Binop(_):
						walkStatement(stream, newChild);
					default:
				}
				return false;
			case Kwd(KwdCast):
				var newChild:TokenTree = stream.consumeToken();
				parent.addChild(newChild);
				walkStatement(stream, newChild);
				return false;
			case Kwd(KwdThis):
				var newChild:TokenTree = stream.consumeToken();
				parent.addChild(newChild);
				WalkStatement.walkStatementContinue(stream, newChild);
				return false;
			default:
				return true;
		}
		return false;
	}

	static function walkDblDot(stream:TokenStream, parent:TokenTree) {
		var question:TokenTree = findQuestionParent(parent);
		if (question != null) {
			return;
		}
		var dblDotTok:TokenTree = stream.consumeToken();
		parent.addChild(dblDotTok);
		if (parent.isCIdent() && parent.parent.is(BrOpen)) {
			WalkStatement.walkStatement(stream, dblDotTok);
			return;
		}
		if (stream.is(Kwd(KwdNew))) {
			WalkNew.walkNew(stream, dblDotTok);
			return;
		}
		if (!walkKeyword(stream, dblDotTok)) return;
		WalkTypeNameDef.walkTypeNameDef(stream, dblDotTok);
		if (stream.is(Binop(OpAssign))) {
			walkStatement(stream, parent);
		}
		if (stream.is(Arrow)) {
			walkStatement(stream, parent);
		}
	}

	static function findQuestionParent(token:TokenTree):TokenTree {
		var parent:TokenTree = token;
		while (parent != null && parent.tok != null) {
			switch (parent.tok) {
				case Question:
					if (WalkQuestion.isTernary(parent)) return parent;
					return null;
				case Comma:
					return null;
				case BrOpen:
					return null;
				case Kwd(KwdCase):
					return parent;
				case Kwd(KwdDefault):
					return parent;
				default:
			}
			parent = parent.parent;
		}
		return null;
	}
}