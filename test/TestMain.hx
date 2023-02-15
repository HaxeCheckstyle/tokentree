import tokentree.TokenStreamTest;
import tokentree.TokenTreeBuilderParsingTest;
import tokentree.TokenTreeBuilderTest;
import tokentree.utils.FieldUtilsTest;
import tokentree.utils.TokenTreeCheckUtilsTest;
import tokentree.verify.VerifyTokenTreeTest;
import tokentree.walk.WalkFileTest;
import tokentree.walk.WalkIfTest;
import tokentree.walk.WalkWhileTest;
import utest.Runner;
import utest.ui.Report;

using StringTools;

class TestMain {
	static function main():Void {
		var tests:Array<ITest> = [
			new FieldUtilsTest(),
			new TokenTreeCheckUtilsTest(),
			new TokenStreamTest(),
			new TokenTreeBuilderTest(),
			new TokenTreeBuilderParsingTest(),
			new VerifyTokenTreeTest(),
			new WalkIfTest(),
			new WalkWhileTest(),
			new WalkFileTest()
		];
		var runner:Runner = new Runner();

		#if instrument
		runner.onComplete.add(_ -> {
			instrument.coverage.Coverage.endCoverage();
		});
		#end

		Report.create(runner);
		for (test in tests) runner.addCase(test);
		runner.run();
	}
}