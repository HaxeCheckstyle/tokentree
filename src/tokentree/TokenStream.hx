package tokentree;

import byte.ByteData;

class TokenStream {

	public static inline var NO_MORE_TOKENS:String = "no more tokens";

	public static var MODE:TokenStreamMode = STRICT;

	var tokens:Array<Token>;
	var current:Int;
	var bytes:ByteData;

	var sharpIfStack:Array<TokenTree>;
	var tempStore:Array<TokenTree>;

	public function new(tokens:Array<Token>, bytes:ByteData) {
		this.tokens = tokens;
		this.bytes = bytes;
		sharpIfStack = [];
		tempStore = [];
		current = 0;
	}

	public function hasMore():Bool {
		return current < tokens.length;
	}

	public function consumeToken():TokenTree {
		if ((current < 0) || (current >= tokens.length)) {
			switch (MODE) {
				case RELAXED: return createDummyToken(CommentLine("auto insert"));
				case STRICT: throw NO_MORE_TOKENS;
			}
		}
		var token:Token = tokens[current];
		current++;
		#if debugTokenTree
		Sys.println(token);
		#end
		var space:String = "";
		#if keep_whitespace
		space = token.space;
		#end
		return new TokenTree(token.tok, space, token.pos, current - 1);
	}

	public function consumeConstIdent():TokenTree {
		switch (token()) {
			case Dollar(_): return consumeToken();
			case Const(CIdent(_)): return consumeToken();
			default:
				switch (MODE) {
					case RELAXED: return createDummyToken(Const(CIdent("autoInsert")));
					case STRICT:
						error('bad token ${token()} != Const(CIdent(_))');
						return null;
				}
		}
	}

	public function consumeConst():TokenTree {
		switch (token()) {
			case Const(_): return consumeToken();
			default:
				switch (MODE) {
					case RELAXED: return createDummyToken(Const(CString("autoInsert")));
					case STRICT:
						error('bad token ${token()} != Const(_)');
						return null;
				}
		}
	}

	public function consumeTokenDef(tokenDef:TokenDef):TokenTree {
		if (is(tokenDef)) return consumeToken();
		switch (MODE) {
			case RELAXED: return createDummyToken(tokenDef);
			case STRICT:
				error('bad token ${token()} != $tokenDef');
				return null;
		}
	}

	public function consumeToTempStore() {
		tempStore.push(consumeToken());
	}

	public function addToTempStore(token:TokenTree) {
		tempStore.push(token);
	}

	public function applyTempStore(parent:TokenTree) {
		while (tempStore.length > 0) {
			parent.addChild(tempStore.shift());
		}
	}

	public function getTempStore():Array<TokenTree> {
		return tempStore;
	}

	public inline function error(s:String) {
		throw formatCurrentPos() + ": " + s;
	}

	function formatCurrentPos():String {
		var pos = tokens[current].pos;
		return new hxparse.Position(pos.file, pos.min, pos.max).format(bytes);
	}

	public function is(tokenDef:TokenDef):Bool {
		if ((current < 0) || (current >= tokens.length)) return false;
		var token:Token = tokens[current];
		return Type.enumEq(tokenDef, token.tok);
	}

	public function isSharp():Bool {
		if ((current < 0) || (current >= tokens.length)) return false;
		var token:Token = tokens[current];
		return switch (token.tok) {
			case Sharp(_): true;
			default: false;
		}
	}

	public function isTypedParam():Bool {
		if ((current < 0) || (current >= tokens.length)) return false;
		var index:Int = current + 1;
		var token:Token = tokens[current];
		switch (token.tok) {
			case Binop(OpLt):
			default: return false;
		}
		while (true) {
			token = tokens[index++];
			switch (token.tok) {
				case Dot:
				case DblDot:
				case Comma:
				case Const(CIdent(_)):
				case Kwd(_):
				case Dollar(_):
				case Binop(OpLt):
				case Binop(OpGt): return true;
				default: return false;
			}
		}
		return false;
	}

	public function token():TokenDef {
		if ((current < 0) || (current >= tokens.length)) {
			switch (MODE) {
				case RELAXED: return CommentLine("auto insert");
				case STRICT: throw NO_MORE_TOKENS;
			}
		}
		return tokens[current].tok;
	}

	public function rewind() {
		if (current <= 0) return;
		current--;
	}

	public function currentPos():Int {
		return current;
	}

	public function rewindTo(pos:Int) {
		current = pos;
	}

	/**
	 * HaxeLexer does not handle '>=', '>>', '>>=' and '>>>=' it produces an
	 * individual token for each character.
	 * This function provides a workaround, which scans the tokens following a
	 * Binop(OpGt) and if it is followed by Binop(OpAssign) or Binop(OpGt),
	 * it returns the correct token:
	 * '>' -> Binop(OpGt)
	 * '>=' -> Binop(OpGte)
	 * '>>' -> Binop(OpShr)
	 * '>>=' -> Binop(OpAssignOp(OpShr))
	 * '>>>=' -> Binop(OpAssignOp(OpUShr))
	 *
	 */
	public function consumeOpGt():TokenTree {
		var tok:TokenTree = consumeTokenDef(Binop(OpGt));
		switch (token()) {
			case Binop(OpGt):
				return consumeOpShr(tok);
			case Binop(OpAssign):
				var assignTok:TokenTree = consumeTokenDef(Binop(OpAssign));
				return new TokenTree(Binop(OpGte), tok.space + assignTok.space, {
					file:tok.pos.file,
					min:tok.pos.min,
					max:assignTok.pos.max
				},
				tok.index);
			default:
				return tok;
		}
	}

	function consumeOpShr(parent:TokenTree):TokenTree {
		var tok:TokenTree = consumeTokenDef(Binop(OpGt));
		switch (token()) {
			case Binop(OpGt):
				var innerGt:TokenTree = consumeTokenDef(Binop(OpGt));
				if (is(Binop(OpAssign))) {
					var assignTok:TokenTree = consumeTokenDef(Binop(OpAssign));
					return new TokenTree(Binop(OpAssignOp(OpUShr)), assignTok.space, {
						file:parent.pos.file,
						min:parent.pos.min,
						max:assignTok.pos.max
					},
					parent.index);
				}
				return new TokenTree(Binop(OpUShr), innerGt.space, {
					file:parent.pos.file,
					min:parent.pos.min,
					max:innerGt.pos.max
				},
				parent.index);
			case Binop(OpAssign):
				var assignTok:TokenTree = consumeTokenDef(Binop(OpAssign));
				return new TokenTree(Binop(OpAssignOp(OpShr)), assignTok.space, {
					file:parent.pos.file,
					min:parent.pos.min,
					max:assignTok.pos.max
				},
				parent.index);
			default:
				return new TokenTree(Binop(OpShr), tok.space, {
					file:parent.pos.file,
					min:parent.pos.min,
					max:tok.pos.max
				},
				parent.index);
		}
	}

	/**
	 * HaxeLexer does not detect negative Const(CInt(_)) or Const(CFloat(_))
	 * This function provides a workaround, which scans the tokens around
	 * Binop(OpSub) to see if the token stream should contain a negative const
	 * value and returns a proper Const(CInt(-x)) or Const(CFloat(-x)) token
	 */
	public function consumeOpSub():TokenTree {
		var tok:TokenTree = consumeTokenDef(Binop(OpSub));
		switch (token()) {
			case Const(CInt(_)), Const(CFloat(_)):
			default:
				return new TokenTree(tok.tok, tok.space, tok.pos, tok.index);
		}
		var previous:Int = current - 2;
		if (previous < 0) throw NO_MORE_TOKENS;
		var prevTok:Token = tokens[previous];
		switch (prevTok.tok) {
			case Binop(_), Unop(_), BkOpen, POpen, Comma, DblDot, IntInterval(_), Question:
			case Kwd(KwdReturn), Kwd(KwdIf), Kwd(KwdElse), Kwd(KwdWhile), Kwd(KwdDo), Kwd(KwdFor), Kwd(KwdCase), Kwd(KwdCast):
			default:
				return new TokenTree(tok.tok, tok.space, tok.pos, tok.index);
		}
		switch (token()) {
			case Const(CInt(n)):
				var const:TokenTree = consumeConst();
				return new TokenTree(Const(CInt('-$n')), const.space, {
					file:tok.pos.file,
					min:tok.pos.min,
					max:const.pos.max
				},
				tok.index);
			case Const(CFloat(n)):
				var const:TokenTree = consumeConst();
				return new TokenTree(Const(CFloat('-$n')), const.space, {
					file:tok.pos.file,
					min:tok.pos.min,
					max:const.pos.max
				},
				tok.index);
			default:
				throw NO_MORE_TOKENS;
		}
	}

	public function getCurrentPos():Int {
		return current;
	}

	public function pushSharpIf(token:TokenTree) {
		sharpIfStack.push(token);
	}

	public function popSharpIf():TokenTree {
		if (sharpIfStack.length <= 0) {
			switch (MODE) {
				case RELAXED: return createDummyToken(CommentLine("dummy token"));
				case STRICT: throw NO_MORE_TOKENS;
			}
		}
		return sharpIfStack.pop();
	}

	public function peekSharpIf():TokenTree {
		if (sharpIfStack.length <= 0) {
			switch (MODE) {
				case RELAXED: return createDummyToken(CommentLine("dummy token"));
				case STRICT: throw NO_MORE_TOKENS;
			}
		}
		return sharpIfStack[sharpIfStack.length - 1];
	}

	function createDummyToken(tokDef:TokenDef):TokenTree {
		var pos:Position = null;
		if ((current < 0) || (current >= tokens.length)) {
			pos = tokens[tokens.length - 1].pos;
			pos.min = pos.max;
		}
		else {
			pos = tokens[current].pos;
			pos.max = pos.min;
		}
		return new TokenTree(tokDef, "", pos, -1, true);
	}
}

enum TokenStreamMode {
	STRICT;
	RELAXED;
}