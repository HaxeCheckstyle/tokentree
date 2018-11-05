package tokentree.walk;

class WalkFile {
	public static function walkFile(stream:TokenStream, parent:TokenTree) {
		while (stream.hasMore()) {
			switch (stream.token()) {
				case Kwd(KwdPackage), Kwd(KwdImport), Kwd(KwdUsing):
					stream.applyTempStore(parent);
					WalkPackageImport.walkPackageImport(stream, parent);
				case Sharp(_):
					WalkSharp.walkSharp(stream, parent, WalkFile.walkFile);
					if (!stream.hasMore()) return;
					switch (stream.token()) {
						case BrOpen: WalkBlock.walkBlock(stream, parent.children[parent.children.length - 1]);
						default:
					}
				case At:
					stream.addToTempStore(WalkAt.walkAt(stream));
				case Comment(_), CommentLine(_):
					WalkComment.walkComment(stream, parent);
				case Kwd(KwdClass), Kwd(KwdInterface), Kwd(KwdEnum), Kwd(KwdTypedef), Kwd(KwdAbstract):
					WalkType.walkType(stream, parent);
				case PClose, BrClose, BkClose, Semicolon, Comma:
					parent.addChild(stream.consumeToken());
				case Kwd(KwdExtern), Kwd(KwdPrivate), Kwd(KwdPublic), Const(CString("final")):
					stream.consumeToTempStore();
				#if (haxe_ver >= 4.0)
				case Kwd(KwdFinal):
					stream.consumeToTempStore();
				#end
				default:
					WalkBlock.walkBlock(stream, parent);
			}
		}
		var tempStore:Array<TokenTree> = stream.getTempStore();
		for (stored in tempStore) {
			switch (stored.tok) {
				case Kwd(KwdExtern), Kwd(KwdPrivate), Kwd(KwdPublic), At:
					switch (TokenStream.MODE) {
						case RELAXED: parent.addChild(stored);
						case STRICT: throw "invalid token tree structure - found:" + stored;
					}
				default:
					parent.addChild(stored);
			}
		}
	}
}