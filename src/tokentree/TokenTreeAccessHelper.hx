package tokentree;

abstract TokenTreeAccessHelper(TokenTree) from TokenTree {
	public var token(get, never):TokenTree;

	inline function get_token():TokenTree {
		return this;
	}

	public static inline function access(tok:TokenTree):TokenTreeAccessHelper {
		return tok;
	}

	public function parent():Null<TokenTreeAccessHelper> {
		return if (exists()) this.parent else null;
	}

	public function findParent(predicate:TokenTreeAccessHelper->Bool):TokenTreeAccessHelper {
		var parent:TokenTreeAccessHelper = parent();
		while (parent.exists() && parent.token.tok != null) {
			if (predicate(parent)) {
				return parent;
			}
			parent = parent.parent();
		}
		return null;
	}

	public function previousSibling():Null<TokenTreeAccessHelper> {
		return if (exists()) this.previousSibling else null;
	}

	public function nextSibling():Null<TokenTreeAccessHelper> {
		return if (exists()) this.nextSibling else null;
	}

	public function firstChild():Null<TokenTreeAccessHelper> {
		return if (exists()) this.getFirstChild() else null;
	}

	public function lastChild():Null<TokenTreeAccessHelper> {
		return if (exists()) this.getLastChild() else null;
	}

	public function firstOf(tokenDef:TokenDef):Null<TokenTreeAccessHelper> {
		if (!exists() || this.children == null) return null;
		for (tok in this.children) {
			if (tok.is(tokenDef)) return tok;
		}
		return null;
	}

	public function lastOf(tokenDef:TokenDef):Null<TokenTreeAccessHelper> {
		if (!exists() || this.children == null) return null;
		var found:Null<TokenTree> = null;
		for (tok in this.children) {
			if (tok.is(tokenDef)) found = tok;
		}
		return found;
	}

	public function child(index:Int):Null<TokenTreeAccessHelper> {
		return if (exists() && this.children != null) this.children[index] else null;
	}

	public function is(tokenDef:TokenDef):Null<TokenTreeAccessHelper> {
		return if (exists() && this.is(tokenDef)) this else null;
	}

	public function isComment():Null<TokenTreeAccessHelper> {
		return if (exists() && this.isComment()) this else null;
	}

	public function isCIdent():Null<TokenTreeAccessHelper> {
		return if (exists() && this.isCIdent()) this else null;
	}

	public function or(other:TokenTree):TokenTree {
		return if (exists()) this else other;
	}

	public inline function exists():Bool {
		return this != null;
	}
}
