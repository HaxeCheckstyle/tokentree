package tokentree.utils;

using tokentree.utils.TokenTreeCheckUtils;
using Lambda;

class FieldUtils {
	public static function getFieldType(field:Null<TokenTree>, defaultVisibility:TokenFieldVisibility):TokenFieldType {
		if (field == null) {
			return UNKNOWN;
		}
		switch (field.tok) {
			case Kwd(KwdFunction):
				return getFunctionFieldType(field, defaultVisibility);
			case Kwd(KwdVar), #if (haxe_ver >= 4) Kwd(KwdFinal) #else Const(CIdent("final")) #end :
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
		var name = field.getNameToken().getName();
		var visibility:TokenFieldVisibility = defaultVisibility;
		var isStatic:Bool = false;
		var isInline:Bool = false;
		var isOverride:Bool = false;
		var isFinal:Bool = false;
		var isExtern:Bool = false;
		if (access.token.children != null) {
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
					#if (haxe_ver >= 4)
					case Kwd(KwdFinal):
						isFinal = true;
					#end
					case Const(CIdent("final")):
						isFinal = true;
					case POpen, BrOpen:
						break;
					default:
				}
			}
		}
		return FUNCTION(name, visibility, isStatic, isInline, isOverride, isFinal, isExtern);
	}

	static function getVarFieldType(field:TokenTree, defaultVisibility:TokenFieldVisibility):TokenFieldType {
		var access:TokenTreeAccessHelper = TokenTreeAccessHelper.access(field).firstChild();
		if (access.token == null) {
			return UNKNOWN;
		}
		var name = field.getNameToken().getName();
		var visibility:TokenFieldVisibility = defaultVisibility;
		var isStatic:Bool = false;
		var isInline:Bool = false;
		var isFinal:Bool = #if (haxe_ver >= 4) field.is(Kwd(KwdFinal)) #else false #end;
		var isExtern:Bool = false;
		if (access.token.children != null) {
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
					default:
				}
			}
		}
		access = access.firstOf(POpen);
		if (isFinal || access.token == null) {
			return VAR(name, visibility, isStatic, isInline, isFinal, isExtern);
		}
		var getterAccess:TokenPropertyAccess = makePropertyAccess(access.firstChild().token);
		var setterAccess:TokenPropertyAccess = makePropertyAccess(access.child(1).token);
		return PROP(name, visibility, isStatic, getterAccess, setterAccess);
	}

	static function makePropertyAccess(accessToken:TokenTree):TokenPropertyAccess {
		if (accessToken == null) {
			return DEFAULT;
		}
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

	public static function isOperatorFunction(functionToken:TokenTree):Bool {
		return functionToken.getMetadata().exists(function(meta) {
			return switch (meta.tok) {
				case Const(CIdent("op")): true;
				case Const(CIdent("arrayAccess")): true;
				case Const(CIdent("resolve")): true;
				case _: false;
			}
		});
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