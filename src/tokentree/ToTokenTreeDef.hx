package tokentree;

import haxeparser.Data;

abstract ToTokenTreeDef(TokenTreeDef) {
	function new(tok:TokenTreeDef) {
		this = tok;
	}

	@:to
	public function toTokenTreeDef():TokenTreeDef {
		return this;
	}

	@:from
	public static function fromTokenDef(tok:TokenDef):ToTokenTreeDef {
		return new ToTokenTreeDef(switch (tok) {
			case Kwd(k): Kwd(k);
			case Const(c): Const(c);
			case Sharp(s): Sharp(s);
			case Dollar(s): Dollar(s);
			case Unop(op): Unop(op);
			case Binop(op): Binop(op);
			case Comment(s): Comment(s);
			case CommentLine(s): CommentLine(s);
			case IntInterval(s): IntInterval(s);
			case Semicolon: Semicolon;
			case Dot: Dot;
			case DblDot: DblDot;
			case Arrow: Arrow;
			case Comma: Comma;
			case BkOpen: BkOpen;
			case BkClose: BkClose;
			case BrOpen: BrOpen;
			case BrClose: BrClose;
			case POpen: POpen;
			case PClose: PClose;
			case Question: Question;
			case At: At;
			case Eof: Eof;
		});
	}
}