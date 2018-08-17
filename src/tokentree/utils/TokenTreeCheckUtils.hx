package tokentree.utils;

using Lambda;

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
				case Kwd(KwdImport):
					return true;
				case Kwd(KwdUsing):
					return true;
				default:
					return false;
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
			case Binop(OpGt): (token.access().parent().is(BrOpen).parent().is(Binop(OpAssign)).parent().isCIdent().parent().is(Kwd(KwdTypedef)).token != null);
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
			case POpen: if ((token.previousSibling != null) && (token.previousSibling.is(PClose))) false; else true;
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
				var prev:TokenTree = token.previousSibling;
				if (prev == null) {
					return false;
				}
				var lastToken:TokenTree = getLastToken(prev);
				if (lastToken == null) {
					return false;
				}
				switch (lastToken.tok) {
					case Comma:
						return false;
					case Semicolon:
						return false;
					default:
						return true;
				}
			case Comma:
				return false;
			case Binop(_):
				return true;
			case Kwd(KwdVar), Kwd(KwdFunction):
				return false;
			case Const(CIdent("final")):
				return false;
			#if (haxe_ver >= 4.0)
			case Kwd(KwdFinal):
				return false;
			#end
			default:
				return true;
		}
	}

	public static function isTypeEnumAbstract(type:TokenTree):Bool {
		switch (type.tok) {
			case Kwd(KwdAbstract):
				var name:TokenTree = type.access().firstChild().token;
				if ((name == null) || (name.children == null) || (name.children.length <= 0)) {
					return false;
				}
				if (name.access().firstOf(Kwd(KwdEnum)).exists()) {
					return true;
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
		var afterAssign = typedefToken.access().firstChild().isCIdent().firstOf(Binop(OpAssign)).firstChild();
		return afterAssign.is(BrOpen).exists() || afterAssign.isCIdent().firstOf(Binop(OpAnd)).exists();
	}

	public static function isTypeEnum(enumToken:TokenTree):Bool {
		if (!enumToken.is(Kwd(KwdEnum))) {
			return false;
		}
		if (isTypeEnumAbstract(enumToken)) {
			return false;
		}
		if (enumToken.access().parent().is(DblDot).parent().is(At).exists()) {
			return false;
		}
		return true;
	}

	public static function isTypeMacroClass(classToken:TokenTree):Bool {
		return classToken.is(Kwd(KwdClass)) && classToken.access().parent().is(Kwd(KwdMacro)).exists();
	}

	public static function isBrOpenAnonTypeOrTypedef(token:TokenTree):Bool {
		switch (getBrOpenType(token)) {
			case BLOCK:
				return false;
			case TYPEDEFDECL:
				return true;
			case OBJECTDECL:
				return false;
			case ANONTYPE:
				return true;
			case UNKNOWN:
				return false;
		}
	}

	/**
		Gets the name for a name token (`KwdNew`, `CIdent`).
	**/
	public static function getName(token:TokenTree):Null<String> {
		if (token == null) {
			return null;
		}
		return switch (token.tok) {
			case Const(CIdent(ident)): ident;
			case Kwd(KwdNew): "new";
			case _: null;
		}
	}

	/**
		Gets the name token of a type, var or function token, or a CIdent token itself.
	**/
	public static function getNameToken(token:TokenTree):Null<TokenTree> {
		if (isNameToken(token)) {
			return token;
		}
		var nameToken = token.access().firstChild();
		if (isNameToken(nameToken.token)) {
			return nameToken.token;
		}
		nameToken = nameToken.is(Question).firstChild();
		if (isNameToken(nameToken.token)) {
			return nameToken.token;
		}
		return null;
	}

	/**
		Whether the token is a name token (`KwdNew`, `CIdent`).
	**/
	public static function isNameToken(token:TokenTree):Bool {
		if (token == null) {
			return false;
		}
		return switch (token.tok) {
			case Const(CIdent(_)), Kwd(KwdNew): true;
			case _: false;
		}
	}

	/**
		Returns a list of metas (without At + DblDot) for a given decl keyword (`function`, `var`...).
	**/
	public static function getMetadata(declToken:TokenTree):Array<TokenTree> {
		var ident = declToken.access().firstChild().isCIdent().token;
		if (ident == null || !ident.hasChildren()) {
			return [];
		}

		return ident.children.map(function(token) {
			return token.access().is(At).firstChild().is(DblDot).firstChild().token;
		}).filter(function(token) {
			return token != null;
		});
	}

	/**
		Tries to get the doc comment for a given type or field.
	**/
	public static function getDocComment(declToken:TokenTree):Null<TokenTree> {
		var access = declToken.access();
		do {
			access = access.previousSibling();
			if (access.token == null) {
				return null;
			}
			switch (access.token.tok) {
				case Comment(_):
					return access.token;
				case CommentLine(_):
					continue;
				case _:
					return null;
			}
		} while (true);
		return null;
	}

	public static function isModifier(keyword:TokenTree):Bool {
		if (keyword == null) {
			return false;
		}
		return switch (keyword.tok) {
			case Kwd(KwdPublic): true;
			case Kwd(KwdPrivate): true;
			case Kwd(KwdStatic): true;
			case Kwd(KwdInline): true;
			case Kwd(KwdOverride): true;
			case Kwd(KwdExtern): true;
			case Kwd(KwdDynamic): true;
			case Kwd(KwdMacro): true;
			case _: false;
		}
	}

	public static function getBrOpenType(token:TokenTree):BrOpenType {
		if (token == null) {
			return UNKNOWN;
		}
		switch (token.parent.tok) {
			case Binop(OpAnd):
				return TYPEDEFDECL;
			case Binop(OpAssign):
				if (isInsideTypedef(token.parent)) {
					return TYPEDEFDECL;
				}
				return determinBrChildren(token);
			case Binop(OpLt):
				return ANONTYPE;
			case Binop(_):
				return OBJECTDECL;
			case Kwd(KwdReturn):
				return determinBrChildren(token);
			case Question:
				if (isTernary(token.parent)) {
					return OBJECTDECL;
				}
			case DblDot:
				if (isTernary(token.parent)) {
					return OBJECTDECL;
				}
				var parent:TokenTree = token.parent.parent;
				switch (parent.tok) {
					case Const(CIdent(_)):
					case Const(CString(_)):
					case Kwd(KwdCase):
						return OBJECTDECL;
					case Kwd(KwdDefault):
						return OBJECTDECL;
					default:
						return ANONTYPE;
				}
				parent = parent.parent;
				switch (parent.tok) {
					case Question:
						return ANONTYPE;
					case Kwd(KwdVar):
						return ANONTYPE;
					case Kwd(KwdFunction):
						return ANONTYPE;
					case BrOpen:
						return getBrOpenType(parent);
					case POpen:
						return ANONTYPE;
					default:
						return OBJECTDECL;
				}
			case POpen:
				var pOpenType:POpenType = getPOpenType(token.parent);
				switch (pOpenType) {
					case PARAMETER:
						return ANONTYPE;
					case CALL:
						return OBJECTDECL;
					case CONDITION:
						return UNKNOWN;
					case FORLOOP:
						return UNKNOWN;
					case EXPRESSION:
						return OBJECTDECL;
				}
			case BkOpen:
				return OBJECTDECL;
			case Const(CIdent("from")), Const(CIdent("to")):
				return ANONTYPE;
			case Const(_):
				return BLOCK;
			default:
		}
		return determinBrChildren(token);
	}

	static function determinBrChildren(token:TokenTree):BrOpenType {
		if ((token.children == null) || (token.children.length <= 0)) {
			switch (token.parent.tok) {
				case Kwd(_):
					return BLOCK;
				default:
					return OBJECTDECL;
			}
		}
		if ((token.children.length == 1)) {
			switch (token.parent.tok) {
				case Kwd(_):
					return BLOCK;
				default:
					return OBJECTDECL;
			}
		}
		var onlyComment:Bool = true;
		for (child in token.children) {
			switch (child.tok) {
				case Const(CIdent(_)), Const(CString(_)):
					if (!child.access().firstChild().is(DblDot).exists()) {
						return BLOCK;
					}
					onlyComment = false;
				case Comment(_), CommentLine(_):
				case BrClose:
					if (onlyComment) {
						switch (token.parent.tok) {
							case Kwd(_):
								return BLOCK;
							default:
								return OBJECTDECL;
						}
					}
					return OBJECTDECL;
				default:
					return BLOCK;
			}
		}
		return OBJECTDECL;
	}

	public static function getPOpenType(token:TokenTree):POpenType {
		if (token == null) {
			return EXPRESSION;
		}
		var parent:TokenTree = token.parent;
		if ((parent == null) || (parent.tok == null)) {
			return EXPRESSION;
		}
		switch (parent.tok) {
			case Binop(OpLt):
				parent = parent.parent;
			default:
		}
		switch (parent.tok) {
			case Kwd(KwdIf):
				return CONDITION;
			case Kwd(KwdWhile):
				return CONDITION;
			case Kwd(KwdFor):
				return FORLOOP;
			case Kwd(KwdCatch):
				return CONDITION;
			case POpen:
				return EXPRESSION;
			case Kwd(KwdFunction):
				return PARAMETER;
			case Kwd(KwdNew):
				return PARAMETER;
			case Const(CIdent(_)):
				if ((parent.parent == null) || (parent.parent.tok == null)) {
					return CALL;
				}
				switch (parent.parent.tok) {
					case Kwd(KwdFunction):
						if (parent.previousSibling == null) {
							return PARAMETER;
						}
						return CALL;
					case Kwd(KwdAbstract):
						return PARAMETER;
					default:
						return CALL;
				}
			default:
		}
		if (TokenTreeAccessHelper.access(token).firstOf(Arrow).exists()) {
			return PARAMETER;
		}
		return EXPRESSION;
	}

	public static function isInsideTypedef(token:TokenTree):Bool {
		if (token == null) {
			return false;
		}
		var parent:TokenTree = token;
		while (parent.parent != null) {
			if (parent.is(Kwd(KwdTypedef))) {
				return true;
			}
			parent = parent.parent;
		}
		return false;
	}

	/**
		Whether a given type or field has `@:deprecated` metadata.
	**/
	public static function isDeprecated(declToken:TokenTree):Bool {
		return getMetadata(declToken).exists(function(meta) return meta.tok.match(Const(CIdent("deprecated"))));
	}

	public static function getArrowType(token:TokenTree):ArrowType {
		if (token == null) {
			return ARROW_FUNCTION;
		}
		var child:TokenTree = token.getFirstChild();
		while (child != null) {
			switch (child.tok) {
				case Arrow, Dot, Semicolon, Question:
				case Const(CIdent(_)), Kwd(KwdMacro):
				case Binop(OpLt):
					child = child.nextSibling;
					continue;
				case POpen:
				default:
					return ARROW_FUNCTION;
			}
			child = child.getFirstChild();
		}
		var parent:TokenTree = token.parent;
		if (parent == null) {
			return ARROW_FUNCTION;
		}
		var resultType:ArrowType = checkArrowParent(parent);
		if (resultType != null) {
			return resultType;
		}
		return checkArrowChildren(parent);
	}

	static function checkArrowChildren(parent:TokenTree):ArrowType {
		var child:TokenTree = parent.getFirstChild();

		if (child == null) {
			return ARROW_FUNCTION;
		}
		var seenArrow:Bool = false;
		while (child != null) {
			switch (child.tok) {
				case Arrow:
					seenArrow = true;
				case Const(CIdent(_)):
				case Kwd(_):
					return ARROW_FUNCTION;
				case Dot, Semicolon:
				case Binop(OpLt):
					child = child.nextSibling;
					continue;
				case POpen:
					var result:ArrowType = checkArrowPOpen(child);
					if (result != null) {
						return result;
					}
					child = child.nextSibling;
					continue;
				case PClose:
				case Question:
				default:
					return FUNCTION_TYPE_HAXE4;
			}
			child = child.getFirstChild();
		}
		if (seenArrow) {
			return FUNCTION_TYPE_HAXE3;
		}
		return FUNCTION_TYPE_HAXE4;
	}

	static function checkArrowPOpen(token:TokenTree):ArrowType {
		if ((token.children == null) || (token.children.length <= 1)) {
			return null;
		}
		if (token.parent.isCIdent()) {
			return ARROW_FUNCTION;
		}
		var childArrows:Array<TokenTree> = token.filter([Arrow], ALL);
		if (childArrows.length <= 0) {
			return ARROW_FUNCTION;
		}
		return FUNCTION_TYPE_HAXE3;
	}

	static function checkArrowParent(parent:TokenTree):ArrowType {
		if (parent == null) {
			return ARROW_FUNCTION;
		}
		switch (parent.tok) {
			case POpen:
			case Const(CIdent(_)):
				if (parent.parent.is(POpen)) {
					switch (getPOpenType(parent.parent)) {
						case PARAMETER:
							return FUNCTION_TYPE_HAXE3;
						case EXPRESSION:
							return FUNCTION_TYPE_HAXE3;
						default:
							return ARROW_FUNCTION;
					}
				}
			default:
				return FUNCTION_TYPE_HAXE3;
		}
		return null;
	}

	public static function getColonType(token:TokenTree):ColonType {
		if (token == null) {
			return UNKNOWN;
		}
		if (isTernary(token)) {
			return TERNARY;
		}
		var parent:TokenTree = token.parent;
		if (parent == null) {
			return UNKNOWN;
		}
		switch (parent.tok) {
			case Kwd(KwdCase), Kwd(KwdDefault):
				return SWITCH_CASE;
			case At:
				return AT;
			case BrOpen:
				var brClose:TokenTree = parent.access().firstOf(BrClose).token;
				if (brClose == null) {
					return UNKNOWN;
				}
				if (brClose.pos.max <= token.pos.min) {
					return TYPE_CHECK;
				}
			case POpen:
				return findColonParent(token);
			case Binop(OpLt):
				return findColonParent(parent);
			case Const(CIdent(_)), Const(CString(_)):
				return findColonParent(parent);
			case Kwd(KwdNew):
				return findColonParent(parent);
			case Kwd(KwdThis):
				return findColonParent(parent);
			default:
		}
		return UNKNOWN;
	}

	static function findColonParent(token:TokenTree):ColonType {
		var parent:TokenTree = token;
		while (parent.tok != null) {
			switch (parent.tok) {
				case Kwd(KwdFunction), Kwd(KwdVar), Const(CIdent("final")):
					return TYPE_HINT;
				#if (haxe_ver >= 4.0)
				case Kwd(KwdFinal):
					return TYPE_HINT;
				#end
				case BrOpen:
					var brType:BrOpenType = getBrOpenType(parent);
					switch (brType) {
						case BLOCK:
							return UNKNOWN;
						case TYPEDEFDECL:
							return TYPE_HINT;
						case OBJECTDECL:
							return OBJECT_LITERAL;
						case ANONTYPE:
							return TYPE_HINT;
						case UNKNOWN:
							return UNKNOWN;
					}
				case POpen:
					var pClose:TokenTree = parent.access().firstOf(PClose).token;
					if ((pClose != null) && (pClose.pos.max <= token.pos.min)) {
						return TYPE_HINT;
					}
					var pType:POpenType = getPOpenType(parent);
					switch (pType) {
						case PARAMETER:
							return TYPE_HINT;
						case CALL:
							return UNKNOWN;
						case CONDITION:
							return UNKNOWN;
						case FORLOOP:
							return UNKNOWN;
						case EXPRESSION:
							return TYPE_CHECK;
					}
				default:
			}
			parent = parent.parent;
		}
		return UNKNOWN;
	}

	public static function getLastToken(token:TokenTree):TokenTree {
		if (token == null) {
			return null;
		}
		if (token.children == null) {
			return token;
		}
		if (token.children.length <= 0) {
			return token;
		}
		var lastChild:TokenTree = token.getLastChild();
		while (lastChild != null) {
			var newLast:TokenTree = lastChild.getLastChild();
			if (newLast == null) {
				return lastChild;
			}
			lastChild = newLast;
		}
		return null;
	}
}

enum BrOpenType {
	BLOCK;
	TYPEDEFDECL;
	OBJECTDECL;
	ANONTYPE;
	UNKNOWN;
}

enum POpenType {
	PARAMETER;
	CALL;
	CONDITION;
	FORLOOP;
	EXPRESSION;
}

enum ArrowType {
	ARROW_FUNCTION;
	FUNCTION_TYPE_HAXE3;
	FUNCTION_TYPE_HAXE4;
}

enum ColonType {
	SWITCH_CASE;
	TYPE_HINT;
	TYPE_CHECK;
	TERNARY;
	OBJECT_LITERAL;
	AT;
	UNKNOWN;
}