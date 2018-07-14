package tokentree.utils;

class TokenTreeCheckUtils {

	public static function isImportMult(token:TokenTree):Bool {
		return switch (token.tok) {
			case Binop(OpMult), Dot: isImport(token.parent);
			default: false;
		}
	}

	public static function isImport(token:TokenTree):Bool {
		var parent:TokenTree = token;
		while (parent != null) {
			if (parent.tok == null) return false;
			switch (parent.tok) {
				case Kwd(KwdMacro):
				case Kwd(KwdExtern):
				case Const(CIdent(_)):
				case Dot:
				#if (haxe_ver < 4.0)
				case Kwd(KwdIn):
				#else
				case Binop(OpIn):
				#end
				case Kwd(KwdImport): return true;
				case Kwd(KwdUsing): return true;
				default: return false;
			}
			parent = parent.parent;
		}
		return false;
	}

	public static function isTypeParameter(token:TokenTree):Bool {
		return switch (token.tok) {
			case Binop(OpGt): token.parent.tok.match(Binop(OpLt));
			case Binop(OpLt): token.getLastChild().tok.match(Binop(OpGt));
			default: false;
		}
	}

	public static function isOpGtTypedefExtension(token:TokenTree):Bool {
		return switch (token.tok) {
			case Binop(OpGt):
				(token.access().parent().is(BrOpen).parent().is(Binop(OpAssign)).parent().isCIdent().parent().is(Kwd(KwdTypedef)).token != null);
			default: false;
		}
	}

	public static function filterOpSub(token:TokenTree):Bool {
		if (!token.tok.match(Binop(OpSub))) return false;
		return switch (token.parent.tok) {
			case Binop(_): true;
			case IntInterval(_): true;
			case BkOpen: true;
			case BrOpen: true;
			case POpen: true;
			case Question: true;
			case DblDot: true;
			case Kwd(KwdIf): true;
			case Kwd(KwdElse): true;
			case Kwd(KwdWhile): true;
			case Kwd(KwdDo): true;
			case Kwd(KwdFor): true;
			case Kwd(KwdReturn): true;
			default: false;
		}
	}

	public static function isUnaryLeftSided(tok:TokenTree):Bool {
		var child:TokenTree = tok.getFirstChild();

		if (child == null) return false;
		return switch (child.tok) {
			case Const(_): true;
			case POpen: true;
			case Kwd(KwdMacro): true;
			case Kwd(KwdThis): true;
			default: false;
		}
	}

	public static function isTernary(tok:TokenTree):Bool {
		if (!tok.tok.match(Question)) return false;
		if (!tok.getLastChild().tok.match(DblDot)) return false;
		return true;
	}

	public static function isTypeEnumAbstract(type:TokenTree):Bool {
		switch (type.tok) {
			case Kwd(KwdEnum):
				var child:TokenTree = TokenTreeAccessHelper.access(type).firstChild().is(Kwd(KwdAbstract)).token;
				return (child != null);
			case Kwd(KwdAbstract):
				var name:TokenTree = TokenTreeAccessHelper.access(type).firstChild().token;
				if ((name == null) || (name.children.length <= 0)) {
					return false;
				}
				for (child in name.children) {
					if (!child.is(At)) {
						continue;
					}
					var enumTok:TokenTree = TokenTreeAccessHelper.access(child).firstChild().is(DblDot).firstChild().is(Kwd(KwdEnum)).token;
					if (enumTok == null) {
						continue;
					}
					return true;
				}
			default:
		}
		return false;
	}
}