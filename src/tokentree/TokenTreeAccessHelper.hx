package tokentree;

class TokenTreeAccessHelper {

	static var NULL_TOKEN:TokenTreeAccessHelper = new TokenTreeAccessHelper(null);

	public var token:TokenTree;

	function new(tok:TokenTree) {
		token = tok;
	}

	public static function access(tok:TokenTree):TokenTreeAccessHelper {
		return new TokenTreeAccessHelper(tok);
	}

	public function parent():TokenTreeAccessHelper {
		if (token == null) return this;
		return new TokenTreeAccessHelper(token.parent);
	}

	public function previousSibling():TokenTreeAccessHelper {
		if (token == null) return this;
		return new TokenTreeAccessHelper(token.previousSibling);
	}

	public function nextSibling():TokenTreeAccessHelper {
		if (token == null) return this;
		return new TokenTreeAccessHelper(token.nextSibling);
	}

	public function firstChild():TokenTreeAccessHelper {
		if (token == null) return this;
		return new TokenTreeAccessHelper(token.getFirstChild());
	}

	public function lastChild():TokenTreeAccessHelper {
		if (token == null) return this;
		return new TokenTreeAccessHelper(token.getLastChild());
	}

	public function firstOf(tokenDef:TokenDef):TokenTreeAccessHelper {
		if (token == null) return this;
		if (token.children == null) return NULL_TOKEN;
		for (tok in token.children) {
			if (tok.is(tokenDef)) return new TokenTreeAccessHelper(tok);
		}
		return NULL_TOKEN;
	}

	public function lastOf(tokenDef:TokenDef):TokenTreeAccessHelper {
		if (token == null) return this;
		if (token.children == null) return NULL_TOKEN;
		var found:TokenTree = null;
		for (tok in token.children) {
			if (tok.is(tokenDef)) found = tok;
		}
		return new TokenTreeAccessHelper(found);
	}

	public function child(index:Int):TokenTreeAccessHelper {
		if (token == null) return this;
		if (token.children == null) return NULL_TOKEN;
		if (index < 0) return NULL_TOKEN;
		if (token.children.length <= index) return NULL_TOKEN;
		return new TokenTreeAccessHelper(token.children[index]);
	}

	public function is(tokenDef:TokenDef):TokenTreeAccessHelper {
		if (token == null) return this;
		if (token.is(tokenDef)) return this;
		return NULL_TOKEN;
	}

	public function isComment():TokenTreeAccessHelper {
		if (token == null) return this;
		if (token.isComment()) return this;
		return NULL_TOKEN;
	}

	public function isCIdent():TokenTreeAccessHelper {
		if (token == null) return this;
		if (token.isCIdent()) return this;
		return NULL_TOKEN;
	}
}