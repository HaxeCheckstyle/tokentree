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
			case Binop(OpGt): (token.access().parent().is(Binop(OpLt)).token != null);
			case Binop(OpLt): (token.access().firstOf(Binop(OpGt)).token != null);
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

	public static function isTernary(token:TokenTree):Bool {
		if (token == null) {
			return false;
		}
		if (token.is(DblDot)) {
			return isTernary(token.parent);
		}
		if (!token.is(Question)) {
			return false;
		}
		if (token.access().firstOf(DblDot).token == null) {
			return false;
		}
		if (token.parent == null) {
			return false;
		}
		switch (token.parent.tok) {
			case POpen:
				var pos:Position = token.parent.getPos();
				if ((pos.min < token.pos.min) && (pos.max > token.pos.max)) {
					return true;
				}
				return false;
			case Comma:
				return false;
			case Binop(_):
				return true;
			default:
				return true;
		}
	}

	public static function isTypeEnumAbstract(type:TokenTree):Bool {
		switch (type.tok) {
			case Kwd(KwdEnum):
				return type.access().firstChild().is(Kwd(KwdAbstract)).exists();
			case Kwd(KwdAbstract):
				if (type.access().parent().is(Kwd(KwdEnum)).exists()) {
					return true;
				}
				var name:TokenTree = type.access().firstChild().token;
				if ((name == null) || (name.children == null) || (name.children.length <= 0)) {
					return false;
				}
				for (child in name.children) {
					if (!child.is(At)) {
						continue;
					}
					var enumTok = child.access().firstChild().is(DblDot).firstChild().is(Kwd(KwdEnum));
					if (!enumTok.exists()) {
						continue;
					}
					return true;
				}
			default:
		}
		return false;
	}

	/**
		Whether this is a `typedef` to an anonymous structure, rather than being a "plain type alias".
	**/
	public static function isTypeStructure(typedefToken:TokenTree):Bool {
		// TODO: check for intersection types once #35 is resolved
		return typedefToken.access().firstChild().isCIdent().firstOf(Binop(OpAssign)).firstChild().is(BrOpen).exists();
	}

	public static function isTypeEnum(enumToken:TokenTree):Bool {
		if (isTypeEnumAbstract(enumToken)) {
			return false;
		}
		return !enumToken.access().parent().is(DblDot).parent().is(At).exists();
	}

	public static function isBrOpenAnonTypeOrTypedef(token:TokenTree):Bool {
		if ((token == null) || (!token.is(BrOpen)) || (token.children == null)) {
			return false;
		}
		if (token.children.length <= 0) {
			return true;
		}
		for (child in token.children) {
			switch (child.tok) {
				case Const(CIdent(_)):
					if (child.access().firstOf(DblDot).token == null) {
						return false;
					}
				case BrClose:
				default:
					return false;
			}
		}
		if (token.parent == null) {
			return true;
		}
		var parent:TokenTree = token.parent;
		switch (parent.tok) {
			case DblDot:
				return true;
			case Binop(OpLt):
				return true;
			case Binop(OpAssign):
				if (parent.access().parent().isCIdent().parent().is(Kwd(KwdTypedef)).token != null) {
					return true;
				}
			default:
				return false;
		}
		return false;
	}

	/**
		Gets the name of a type, var or function.
	**/
	public static function getName(declToken:TokenTree):String {
		var nameToken = declToken.access().firstChild().token;
		if (nameToken == null) {
			return null;
		}
		return switch (nameToken.tok) {
			case Const(CIdent(ident)):
				ident;
			case Kwd(KwdNew):
				"new";
			default:
				null;
		}
	}
}