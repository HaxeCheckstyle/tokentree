import byte.ByteData;
import sys.io.File;
import haxeparser.HaxeLexer;
import haxeparser.Data.Token;
import tokentree.TokenTree;
import tokentree.TokenTreeBuilder;
import tokentree.TokenStream;

class TokenTestMain {
	public static inline var TOKENTREE_BUILDER_TEST:String = "

class FlxActionDigital extends FlxAction {
	private function get_x():Float {
		var color = #if def { rgb:0x00FFFFFF, a:0 }; #end
		(_x != null) ? _x : 0;
		(_x != null) ? return _x : return 0;
		(_x != null) ? return _x : return 0x80;
		(_x != null) ? return -_x : return -0;
		(_x != null) ? return -_x : return -0x80;
	}

	private function get_y():Float {
		(_y != null) ? return _y : return 0.1;
		(_y != null) ? return _y : return -0.1;
	}
}

	";

	public static function main() {
		var code = File.getContent("../../haxe-languageserver/cases/foldingRange/Input.hx");

		// var code = TOKENTREE_BUILDER_TEST;
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