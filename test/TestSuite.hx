import tokentree.utils.FieldUtilsTest;
import tokentree.utils.TokenTreeCheckUtilsTest;
import tokentree.TokenTreeBuilderTest;
import tokentree.TokenTreeBuilderParsingTest;
import tokentree.verify.VerifyTokenTreeTest;
import tokentree.walk.WalkIfTest;
import tokentree.walk.WalkWhileTest;
import tokentree.walk.WalkFileTest;

class TestSuite extends massive.munit.TestSuite {
	public function new() {
		super();

		add(FieldUtilsTest);
		add(TokenTreeCheckUtilsTest);
		add(TokenTreeBuilderTest);
		add(TokenTreeBuilderParsingTest);
		add(VerifyTokenTreeTest);
		add(WalkIfTest);
		add(WalkWhileTest);
		add(WalkFileTest);
	}
}