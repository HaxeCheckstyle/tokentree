package tokentree.walk;

class WalkStatement {
	public static function walkStatement(stream:TokenStream, parent:TokenTree) {
		walkStatementWithoutSemicolon(stream, parent);
		if (stream.is(Semicolon)) {
			var semicolon:TokenTree = stream.consumeToken();
			var lastChild:TokenTree = parent.getLastChild();
			if (lastChild == null) {
				lastChild = parent;
			}
			switch (lastChild.tok) {
				case BrClose, BkClose, PClose:
					lastChild = parent;
				default:
			}
			lastChild.addChild(semicolon);
		}
	}

	static function walkStatementWithoutSemicolon(stream:TokenStream, parent:TokenTree) {
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
					if (stream.is(Arrow)) {
						walkStatementWithoutSemicolon(stream, parent);
					}
					return;
				}
				wantMore = true;
			case Binop(OpGt):
				var gtTok:TokenTree = stream.consumeOpGt();
				parent.addChild(gtTok);
				walkStatementWithoutSemicolon(stream, gtTok);
				return;
			case Binop(_):
				wantMore = true;
			case Unop(_):
				if (parent.isCIdentOrCString()) {
					var newChild:TokenTree = stream.consumeToken();
					parent.addChild(newChild);
					return;
				}
			case IntInterval(_):
				wantMore = true;
			case Kwd(_):
				if (walkKeyword(stream, parent)) wantMore = true;
				else return;
			case Arrow:
				wantMore = true;
			case BrOpen:
				WalkBlock.walkBlock(stream, parent);
				return;
			case BkOpen:
				WalkArrayAccess.walkArrayAccess(stream, parent);
				walkStatementContinue(stream, parent);
				return;
			case Dollar(name):
				var dollarTok:TokenTree = stream.consumeToken();
				parent.addChild(dollarTok);
				if (stream.is(DblDot)) {
					return;
				}
				WalkBlock.walkBlock(stream, dollarTok);
				return;
			case POpen:
				var pOpen:TokenTree = WalkPOpen.walkPOpen(stream, parent);
				if (parent.isCIdent()) {
					walkStatementContinue(stream, parent);
				}
				else {
					if (parent.is(Kwd(KwdIf)) && stream.is(Binop(OpSub))) {
						return;
					}
					walkStatementContinue(stream, pOpen);
				}
				return;
			case Question:
				WalkQuestion.walkQuestion(stream, parent);
				return;
			case PClose, BrClose, BkClose:
				return;
			case Comma:
				return;
			case Semicolon:
				return;
			case Sharp(_):
				WalkSharp.walkSharp(stream, parent, walkStatement);
				walkStatementContinueAfterSharp(stream, parent);
				return;
			case Dot:
				wantMore = true;
			case DblDot:
				if (parent.is(Dot)) {
					return;
				}
				if (WalkQuestion.isTernary(parent)) {
					walkStatementContinue(stream, parent);
					return;
				}
				wantMore = true;
			default:
				wantMore = false;
		}
		var newChild:TokenTree = stream.consumeToken();
		parent.addChild(newChild);
		stream.applyTempStore(newChild);
		walkTrailingComment(stream, newChild);
		if (wantMore) walkStatementWithoutSemicolon(stream, newChild);
		walkStatementContinue(stream, newChild);
		walkTrailingComment(stream, newChild);
	}

	public static function walkTrailingComment(stream:TokenStream, parent:TokenTree) {
		if (!stream.hasMore()) {
			return;
		}
		switch (stream.token()) {
			case CommentLine(_):
				var currentPos:Int = stream.getStreamIndex();
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
				walkStatementWithoutSemicolon(stream, parent);
			case DblDot:
				walkDblDot(stream, parent);
			case Semicolon:
				return;
			case Arrow:
				walkStatementWithoutSemicolon(stream, parent);
			case Binop(OpBoolAnd), Binop(OpBoolOr):
				walkOpBool(stream, parent);
			case Binop(_):
				walkStatementWithoutSemicolon(stream, parent);
			case Unop(_):
				if (parent.isCIdentOrCString()) {
					walkStatementWithoutSemicolon(stream, parent);
				}
			case Question:
				WalkQuestion.walkQuestion(stream, parent);
			case BkOpen:
				walkStatementWithoutSemicolon(stream, parent);
			case POpen:
				walkStatementWithoutSemicolon(stream, parent);
			case CommentLine(_):
				var nextTokDef:TokenDef = stream.peekNonCommentToken();
				if (nextTokDef == null) {
					return;
				}
				switch (nextTokDef) {
					case Dot, DblDot, Binop(_), Unop(_), Question:
						WalkComment.walkComment(stream, parent);
						walkStatementContinue(stream, parent);
					default:
				}
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
					walkStatementContinue(stream, newChild);
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
				if (!parent.is(BrOpen) && parent.parent.is(Kwd(KwdDo))) {
					return false;
				}
				WalkWhile.walkWhile(stream, parent);
			case Kwd(KwdNull), Kwd(KwdTrue), Kwd(KwdFalse):
				var newChild:TokenTree = stream.consumeToken();
				parent.addChild(newChild);
				switch (stream.token()) {
					case Semicolon: newChild.addChild(stream.consumeToken());
					case Binop(_): walkStatementWithoutSemicolon(stream, newChild);
					default:
				}
				return false;
			case Kwd(KwdCast):
				var newChild:TokenTree = stream.consumeToken();
				parent.addChild(newChild);
				walkStatementWithoutSemicolon(stream, newChild);
				return false;
			case Kwd(KwdThis):
				var newChild:TokenTree = stream.consumeToken();
				parent.addChild(newChild);
				walkStatementContinue(stream, newChild);
				return false;
			// case Kwd(KwdReturn):
			// 	trace(stream.token());
			// 	var newChild:TokenTree = stream.consumeToken();
			// 	parent.addChild(newChild);
			// 	// walkStatementContinue(stream, newChild);
			// 	return true;
			default:
				return true;
		}
		return false;
	}

	public static function walkDblDot(stream:TokenStream, parent:TokenTree) {
		var question:TokenTree = findQuestionParent(parent);
		if (question != null) {
			return;
		}
		var dblDotTok:TokenTree = stream.consumeToken();
		parent.addChild(dblDotTok);
		if (parent.isCIdentOrCString() && parent.parent.is(BrOpen)) {
			walkStatementWithoutSemicolon(stream, dblDotTok);
			return;
		}
		if (stream.is(Kwd(KwdNew))) {
			WalkNew.walkNew(stream, dblDotTok);
			return;
		}
		if (!walkKeyword(stream, dblDotTok)) return;
		WalkTypeNameDef.walkTypeNameDef(stream, dblDotTok);
		if (stream.is(Binop(OpAssign))) {
			walkStatementWithoutSemicolon(stream, parent);
		}
		if (stream.is(Arrow)) {
			walkStatementWithoutSemicolon(stream, parent);
		}
	}

	static function findQuestionParent(token:TokenTree):Null<TokenTree> {
		var parent:Null<TokenTree> = token;
		while (parent != null && parent.tok != null) {
			switch (parent.tok) {
				case Question:
					if (WalkQuestion.isTernary(parent)) return parent;
					return null;
				case Comma:
					return null;
				case BrOpen:
					if (!TokenTreeAccessHelper.access(parent).firstOf(BrClose).exists()) {
						return null;
					}
				case POpen:
					if (!TokenTreeAccessHelper.access(parent).firstOf(PClose).exists()) {
						return null;
					}
				case Kwd(KwdReturn):
					return parent;
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

	static function walkStatementContinueAfterSharp(stream:TokenStream, parent:TokenTree) {
		switch (stream.token()) {
			case Kwd(KwdCase), Kwd(KwdDefault):
				var lastChild:TokenTree = parent.getLastChild();
				if (lastChild == null) {
					lastChild = parent;
				}
				WalkSwitch.walkSwitchCases(stream, lastChild);
			default:
		}
	}

	static function walkOpBool(stream:TokenStream, token:TokenTree) {
		var parent = token.parent;
		while (parent.tok != null) {
			switch (parent.tok) {
				case Binop(OpAssign), Binop(OpAssignOp(_)):
					break;
				case Binop(OpBoolAnd), Binop(OpBoolOr):
					token = parent;
					break;
				case POpen:
					if (token.is(POpen)) {
						token = parent;
					}
					break;
				case Kwd(KwdReturn), Kwd(KwdUntyped), Kwd(KwdIf), Kwd(KwdWhile):
					break;
				case Kwd(KwdFunction), Arrow:
					break;
				default:
					token = parent;
					parent = parent.parent;
			}
		}
		walkStatementWithoutSemicolon(stream, token);
	}
}