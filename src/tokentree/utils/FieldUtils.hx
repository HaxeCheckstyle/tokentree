package tokentree.utils;

class FieldUtils {
	public static function getFieldType(field:TokenTree, defaultVisibility:TokenFieldVisibility):TokenFieldType {
		if (field == null) {
			return UNKNOWN;
		}
		switch (field.tok) {
			case Kwd(KwdFunction):
				return getFunctionFieldType(field, defaultVisibility);
			case Kwd(KwdVar):
				return getVarFieldType(field, defaultVisibility);
			default:
		}
		return UNKNOWN;
	}

	static function getFunctionFieldType(field:TokenTree, defaultVisibility:TokenFieldVisibility):TokenFieldType {
		var access:TokenTreeAccessHelper = TokenTreeAccessHelper.access(field).firstChild();
		if (access.token == null) {
			return UNKNOWN;
		}
		var name:String = "";
		switch (access.token.tok) {
			case Const(CIdent(text)):
				name = text;
			case Kwd(KwdNew):
				name = "new";
			default:
		}
		var visibility:TokenFieldVisibility = defaultVisibility;
		var isStatic:Bool = false;
		var isInline:Bool = false;
		var isOverride:Bool = false;
		var isFinal:Bool = false;
		var isExtern:Bool = false;
		for (child in access.token.children) {
			switch (child.tok) {
				case Kwd(KwdPublic):
					visibility = PUBLIC;
				case Kwd(KwdPrivate):
					visibility = PRIVATE;
				case Kwd(KwdStatic):
					isStatic = true;
				case Kwd(KwdInline):
					isInline = true;
				case Kwd(KwdOverride):
					isOverride = true;
				case Kwd(KwdExtern):
					isExtern = true;
				// case Kwd(KwdFinal):
				case Const(CIdent("final")):
					isFinal = true;
				case POpen, BrOpen:
					break;
				default:
			}
		}
		return FUNCTION(name, visibility, isStatic, isInline, isOverride, isFinal, isExtern);
	}
	public var x(default, null):Int;

	static function getVarFieldType(field:TokenTree, defaultVisibility:TokenFieldVisibility):TokenFieldType {
		var access:TokenTreeAccessHelper = TokenTreeAccessHelper.access(field).firstChild();
		if (access.token == null) {
			return UNKNOWN;
		}
		var name:String = "";
		switch (access.token.tok) {
			case Const(CIdent(text)):
				name = text;
			default:
		}

		var visibility:TokenFieldVisibility = defaultVisibility;
		var isStatic:Bool = false;
		var isInline:Bool = false;
		var isFinal:Bool = false;
		var isExtern:Bool = false;
		for (child in access.token.children) {
			switch (child.tok) {
				case Kwd(KwdPublic):
					visibility = PUBLIC;
				case Kwd(KwdPrivate):
					visibility = PRIVATE;
				case Kwd(KwdStatic):
					isStatic = true;
				case Kwd(KwdInline):
					isInline = true;
				case Kwd(KwdExtern):
					isExtern = true;
				// case Kwd(KwdFinal):
				case Const(CIdent("final")):
					isFinal = true;
				default:
			}
		}
		access = access.firstOf(POpen);
		if (access.token == null) {
			return VAR(name, visibility, isStatic, isInline, isFinal, isExtern);
		}
		var getterAccess:TokenPropertyAccess = makePropertyAccess(access.firstChild().token);
		var setterAccess:TokenPropertyAccess = makePropertyAccess(access.child(1).token);
		return PROP(name, visibility, isExtern, getterAccess, setterAccess);
	}

	static function makePropertyAccess(accessToken:TokenTree):TokenPropertyAccess {
		return switch (accessToken.tok) {
			case Kwd(KwdDefault): DEFAULT;
			case Kwd(KwdNull): NULL;
			case Kwd(KwdDynamic): DYNAMIC;
			case Const(CIdent("never")): NEVER;
			case Const(CIdent("get")): GET;
			case Const(CIdent("set")): SET;
			default: DEFAULT;
		}
	}
}

enum TokenFieldType {
	FUNCTION(name:String, visibility:TokenFieldVisibility, isStatic:Bool, isInline:Bool, isOverride:Bool, isFinal:Bool, isExtern:Bool);
	VAR(name:String, visibility:TokenFieldVisibility, isStatic:Bool, isInline:Bool, isFinal:Bool, isExtern:Bool);
	PROP(name:String, visibility:TokenFieldVisibility, isStatic:Bool, getter:TokenPropertyAccess, setter:TokenPropertyAccess);
	UNKNOWN;
}

enum TokenFieldVisibility {
	PUBLIC;
	PRIVATE;
}

enum TokenPropertyAccess {
	DEFAULT;
	NULL;
	GET;
	SET;
	DYNAMIC;
	NEVER;
}