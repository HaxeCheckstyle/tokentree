package tokentree;

import haxe.PosInfos;

class TokenStreamTest implements ITest {
	public function new() {}

	@Test
	public function testIsTypedParam() {
		function codeIsTyeParam(code:String):Bool {
			var stream:TokenStream = TestTokenTreeBuilder.makeTokenStream(code);
			return stream.isTypedParam();
		}
		Assert.isFalse(codeIsTyeParam(""));
		Assert.isFalse(codeIsTyeParam("1"));
		Assert.isFalse(codeIsTyeParam("< 1"));
		Assert.isFalse(codeIsTyeParam("< (y >> 1);"));
		Assert.isFalse(codeIsTyeParam("< arr[1];"));
		Assert.isFalse(codeIsTyeParam("< arr[i << 1];"));
		Assert.isFalse(codeIsTyeParam("< arr[i]];"));
		Assert.isFalse(codeIsTyeParam("< arr[i]};"));

		Assert.isTrue(codeIsTyeParam("<String>"));
		Assert.isTrue(codeIsTyeParam("<haxe.Json>"));
		Assert.isTrue(codeIsTyeParam("<Array<haxe.Json>>"));
		Assert.isTrue(codeIsTyeParam("<Map<String, haxe.Json>>"));
	}
}