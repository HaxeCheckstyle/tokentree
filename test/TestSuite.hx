import tokentree.TokenTreeBuilderTest;
import tokentree.TokenTreeBuilderParsingTest;
import tokentree.verify.VerifyTokenTreeTest;
import tokentree.walk.WalkIfTest;
import tokentree.walk.WalkWhileTest;

class TestSuite extends massive.munit.TestSuite {

	public function new() {
		super();

		add(TokenTreeBuilderTest);
		add(TokenTreeBuilderParsingTest);
		add(VerifyTokenTreeTest);
		add(WalkIfTest);
		add(WalkWhileTest);
	}
}