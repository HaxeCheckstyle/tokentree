package tokentree;

import byte.ByteData;
import haxeparser.HaxeLexer;
import haxeparser.Data.Token;
import tokentree.walk.WalkFile;

class TestTokenTreeBuilder extends TokenTreeBuilder {
	public static function parseCode(code:String):TestTokenTreeBuilder {
		var builder:TestTokenTreeBuilder = new TestTokenTreeBuilder(code);
		builder.root = new TokenTree(null, "", null, -1);
		WalkFile.walkFile(builder.stream, builder.root);
		return builder;
	}

	public static function makeTokenStream(code:String):TokenStream {
		var tokens:Array<Token> = [];
		var lexer = new HaxeLexer(byte.ByteData.ofString(code), "TokenStream");
		var t:Token = lexer.token(HaxeLexer.tok);
		while (t.tok != Eof) {
			tokens.push(t);
			t = lexer.token(haxeparser.HaxeLexer.tok);
		}
		return new TokenStream(tokens, ByteData.ofString(code));
	}

	var stream:TokenStream;

	public var root:TokenTree;

	public function new(code:String) {
		stream = makeTokenStream(code);
	}

	public function setTokenStream(newStream:TokenStream) {
		this.stream = newStream;
	}

	public function getTokenStream():TokenStream {
		return stream;
	}

	public function isStreamEmpty():Bool {
		return !stream.hasMore();
	}
}