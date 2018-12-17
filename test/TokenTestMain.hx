import byte.ByteData;
// import sys.io.File;
import haxeparser.HaxeLexer;
import haxeparser.Data.Token;
import tokentree.TokenTree;
import tokentree.TokenTreeBuilder;
import tokentree.TokenStream;

class TokenTestMain {
	public static inline var TOKENTREE_BUILDER_TEST:String = "

	class Main {
		function loop(min, max) {
			if (test) && (test2) {doSomething();}
		}
	}

	";

	public static function main() {
		// var code = File.getContent("../../haxe-languageserver/cases/foldingRange/Input.hx");

		var code = TOKENTREE_BUILDER_TEST;
		var tokens:Array<Token> = [];
		var bytes:ByteData = ByteData.ofString(code);
		var lexer = new HaxeLexer(bytes, "TokenStream");
		var t:Token = lexer.token(HaxeLexer.tok);

		while (t.tok != Eof) {
			tokens.push(t);
			t = lexer.token(haxeparser.HaxeLexer.tok);
		}

		TokenStream.MODE = RELAXED;

		for (tok in tokens) Sys.println('${tok.tok} ${tok.pos}');
		var root:TokenTree = TokenTreeBuilder.buildTokenTree(tokens, bytes);
		Sys.print(root.printTokenTree());
	}
}