package tokentree.walk;

class WalkQuestion {
	public static function walkQuestion(stream:TokenStream, parent:TokenTree) {
		var ternary:Bool = isTernary(parent);
		var question:TokenTree = stream.consumeTokenDef(Question);
		parent.addChild(question);
		WalkComment.walkComment(stream, question);
		if (!ternary) {
			WalkStatement.walkStatement(stream, question);
			return;
		}
		WalkStatement.walkStatement(stream, question);
		WalkComment.walkComment(stream, question);
		if (!stream.tokenForMatch().match(DblDot)) return;
		var dblDotTok:TokenTree = stream.consumeTokenDef(DblDot);
		question.addChild(dblDotTok);
		WalkStatement.walkStatement(stream, dblDotTok);
	}

	public static function isTernary(parent:TokenTree):Bool {
		var lastChild:Null<TokenTree> = parent.getLastChild();
		if (lastChild == null) {
			switch (parent.tok) {
				case Const(_):
					return true;
				default:
					lastChild = parent;
			}
		}
		return switch (lastChild.tok) {
			case Const(_): true;
			case BkOpen: true;
			case BrOpen: true;
			case Binop(OpAdd), Binop(OpSub): true;
			case Unop(_): true;
			case Kwd(KwdCast): true;
			case Kwd(KwdNew): true;
			case Kwd(KwdTrue), Kwd(KwdFalse), Kwd(KwdNull): true;
			case Kwd(KwdThis), Kwd(KwdMacro), Kwd(KwdUntyped): true;
			case Kwd(KwdFunction): true;
			case Dollar(_): true;
			case POpen: true;
			case PClose: true;
			case DblDot: true;
			default: false;
		}
	}
}