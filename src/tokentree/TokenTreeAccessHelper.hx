package tokentree;

abstract TokenTreeAccessHelper(TokenTree) from TokenTree {
	public var token(get, never):TokenTree;

	inline function get_token():TokenTree {
		return this;
	}

	public static inline function access(tok:TokenTree):TokenTreeAccessHelper {
		return tok;
	}

	public function parent():TokenTreeAccessHelper {
		return if (this != null) this.parent else null;
	}

	public function previousSibling():TokenTreeAccessHelper {
		return if (this != null) this.previousSibling else null;
	}

	public function nextSibling():TokenTreeAccessHelper {
		return if (this != null) this.nextSibling else null;
	}

	public function firstChild():TokenTreeAccessHelper {
		return if (this != null) this.getFirstChild() else null;
	}

	public function lastChild():TokenTreeAccessHelper {
		return if (this != null) this.getLastChild() else null;
	}

	public function firstOf(tokenDef:TokenDef):TokenTreeAccessHelper {
		if (this == null || this.children == null) return null;

		for (tok in this.children) {
			if (tok.is(tokenDef)) return tok;
		}
		return null;
	}

	public function lastOf(tokenDef:TokenDef):TokenTreeAccessHelper {
		if (this == null || this.children == null) return null;

		var found:TokenTree = null;
		for (tok in this.children) {
			if (tok.is(tokenDef)) found = tok;
		}
		return found;
	}

	public function child(index:Int):TokenTreeAccessHelper {
		return if (this != null && this.children != null) this.children[index] else null;
	}

	public function is(tokenDef:TokenDef):TokenTreeAccessHelper {
		return if (this != null && this.is(tokenDef)) this else null;
	}

	public function isComment():TokenTreeAccessHelper {
		return if (this != null && this.isComment()) this else null;
	}

	public function isCIdent():TokenTreeAccessHelper {
		return if (this != null && this.isCIdent()) this else null;
	}

	public function or(other:TokenTree):TokenTree {
		return if (this != null) this else other;
	}

	public inline function exists():Bool {
		return this != null;
	}
}