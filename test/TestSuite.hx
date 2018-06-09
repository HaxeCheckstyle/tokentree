import tokentree.TokenTreeBuilderTest;
import tokentree.TokenTreeBuilderParsingTest;
import tokentree.verify.VerifyTokenTreeTest;

class TestSuite extends massive.munit.TestSuite {

	public function new() {
		super();

		add(TokenTreeBuilderTest);
		add(TokenTreeBuilderParsingTest);
		add(VerifyTokenTreeTest);
	}
}