package tokentree.walk;

class WalkPackageImport {
	/**
	 * Kwd(KwdPackage)
	 *  |- Const(CIdent(_))
	 *      |- Dot
	 *          |- Const(CIdent(_))
	 *              |- Semicolon
	 *
	 * Kwd(KwdImport)
	 *  |- Const(CIdent(_))
	 *      |- Dot
	 *          |- Const(CIdent(_))
	 *              |- Semicolon
	 *
	 */
	public static function walkPackageImport(stream:TokenStream, parent:TokenTree) {
		var newChild:TokenTree = stream.consumeToken();
		parent.addChild(newChild);
		if (Type.enumEq(Semicolon, newChild.tok)) return;
		if (!stream.hasMore()) return;
		WalkPackageImport.walkPackageImport(stream, newChild);
	}
}