package tokentree;

import haxe.PosInfos;
import massive.munit.Assert;

class TokenTreeBuilderParsingTest {
	@Test
	public function testIssues() {
		assertCodeParses(ISSUE_76);
		assertCodeParses(ISSUE_79);
		assertCodeParses(ISSUE_154);
		assertCodeParses(ISSUE_235);
		assertCodeParses(ISSUE_238);
		assertCodeParses(ISSUE_239);
		assertCodeParses(ISSUE_244);
		assertCodeParses(ISSUE_245);
		assertCodeParses(ISSUE_249);
		assertCodeParses(ISSUE_251);
		assertCodeParses(ISSUE_252);
		assertCodeParses(ISSUE_253);
		assertCodeParses(ISSUE_256);
		assertCodeParses(DOLLAR_TOKEN_AS_VAR_NAME);
		assertCodeParses(REFERENCE_CONSTRUCTOR);
		assertCodeParses(SHORT_LAMBDA);
		assertCodeParses(EXPRESSION_METADATA_ISSUE_365);
		assertCodeParses(MULTIPLE_METADATAS);
		assertCodeParses(TERNARY_WITH_KEYWORD);
		assertCodeParses(OBJECT_WITH_ARRAY);
		assertCodeParses(MACRO_REIFICATION);
		assertCodeParses(BLOCK_METADATA);
		assertCodeParses(COMMENTS_IN_FUNCTION_PARAMS);
		assertCodeParses(BLOCK_OBJECT_DECL_SAMPLES_ISSUE_396_1);
		assertCodeParses(BLOCK_OBJECT_DECL_SAMPLES_ISSUE_396_2);
		assertCodeParses(BLOCK_OBJECT_DECL_SAMPLES_ISSUE_396_3);
		assertCodeParses(BLOCK_OBJECT_DECL_WITH_TERNARY);
	}

	@Test
	public function testIssues2() {
		assertCodeParses(TYPEDEF_COMMENTS);
		assertCodeParses(TYPEDEF_COMMENTS_2);
		assertCodeParses(FUNCTION_RETURN_TYPE);
		assertCodeParses(FUNCTION_SHARP);
		assertCodeParses(SWITCH_IN_OBJECT_DECL);
		assertCodeParses(COMMENTS_IN_TYPES);
		assertCodeParses(ENUM_ABSTRACT);
		assertCodeParses(QUALIFIED_META);
		assertCodeParses(VAR_QUESTION);
		assertCodeParses(EXTERN_FIELD);
		assertCodeParses(CAST_IN_OBJECT);
		assertCodeParses(SWITCH_THIS);
		assertCodeParses(MACRO_CLASS_REIFICATION);
		assertCodeParses(STRUCTURE_EXTENSION);
		assertCodeParses(BROKEN_OBJECT_DECL);
		assertCodeParses(FINAL_VARS);
		assertCodeParses(CONST_TYPE_PARAMETER);
		assertCodeParses(CASE_VAR);
		assertCodeParses(COMMENTS_IN_IF_ELSE);
		assertCodeParses(COMMENTS_IN_TYPEDEF);
		assertCodeParses(ADVANCED_ARRAY_ITEMS);
		assertCodeParses(IF_ELSE_COMMENTS);
		assertCodeParses(PROPS_AND_VARS);
		assertCodeParses(MULTIPLE_METADATA);
		assertCodeParses(A_LOT_OF_COMMENTS);
		assertCodeParses(TYPEDEF_OVERLOAD);
		assertCodeParses(TERNARY_PARSING);
	}

	@Test
	public function testIssues3() {
		assertCodeParses(SWITCH_CONDITIONAL);
		assertCodeParses(IMPLEMENTS_EXTENDS);
		assertCodeParses(MACRO_PATTERNS);
		assertCodeParses(MACRO_CLASS_NAME);
		assertCodeParses(CONDITIONALS_IN_NEW);
		assertCodeParses(ANON_FUNTION_IN_OBJECT_LITERAL);
		assertCodeParses(COMMENTS_IN_SWITCH_CASES);
		assertCodeParses(TERNARY_WITH_MACRO);
		assertCodeParses(STRUCTURE_EXTENSION_2);
		assertCodeParses(MACRO_DO_WHILE);
		assertCodeParses(INTERESTING_USE_OF_CONDITIONALS);
		assertCodeParses(NESTED_LOOPS);
		assertCodeParses(TYPED_PARAM_STRUCTURE_EXT);
		assertCodeParses(OBJECT_LITERAL_IN_IF_ELSE_CHAIN);
		assertCodeParses(UNOP_AFTER_OP_ASSIGN);
		assertCodeParses(UNOP_IN_DO_WHILE);
		assertCodeParses(TYPEDEF_WITHOUT_ASSIGN);
	}

	public function assertCodeParses(code:String, ?pos:PosInfos) {
		var builder:TestTokenTreeBuilder = null;
		try {
			builder = TestTokenTreeBuilder.parseCode(code);
		}
		catch (e:Any) {
			Assert.fail("code should not throw execption", pos);
		}
		Assert.isTrue(builder.isStreamEmpty(), pos);
	}

	public function assertCodeThrows(code:String, ?pos:PosInfos) {
		var builder:TestTokenTreeBuilder = null;
		try {
			builder = TestTokenTreeBuilder.parseCode(code);
		}
		catch (e:Any) {
			Assert.isTrue(true, pos);
			return;
		}
		Assert.fail("code should throw an exception", pos);
	}
}

@:enum
abstract TokenTreeBuilderParsingTests(String) to String {
	var ISSUE_154 = "
	#if macro
		private enum PrivateEnum {}
	#end
	";

	var ISSUE_235 = "
	#if def
		#if def2
		#end

		#if def3
		#end
	#end
	";

	var ISSUE_239 = "
	#if def1
		#if def2
		#end
		// comment
	#end
	class Foo
	{
#if def1
		#if def2
		#end
		public var test:Int;
#end
	}
	";

	var ISSUE_244 = "
	class Foo {
		var list = ['screenX' #if def , 'screenY' #end];
	}";

	var ISSUE_245 = "
	class Foo {
		function foo() {
			var a = 4, b;
		}
	}";

	var ISSUE_249 = "
	#if def
	#elseif def2
	    #if def3
		#end
		// comment
	#end
	";

	var ISSUE_251 = "
	class Foo {
		function foo() {
			var array = ['string'];
			for (char in array[0].split('')) {}
		}
	}";

	var ISSUE_253 = "
	class Foo {
		var color = #if def { rgb:0x00FFFFFF, a:0 }; #end
	}";

	var ISSUE_256 = "
	class Foo {
		function foo() {
			for /* comment */ (/* comment */ i /* comment */ in /* comment */ 0...10 /* comment */) /* comment */ {}
		}
	}";

	var ISSUE_238 = "
	class Foo
	{
		function foo()
		{
			#if def
			if (true) {}
			else
			{
			#end

			trace('test');

			#if def
			}
			#end
		}
	}";

	var ISSUE_252 = "
	class Foo {
		var library = new #if haxe3 Map<String, #else Hash <#end String>();
	}";

	var ISSUE_76 = "
	class Base {}

	#if true
	class Test extends Base
	#else
	class Test
	#end
	{
	}";

	var ISSUE_79 = "
	class Test {
		function foo() {
			#if true
			if (true) {
			#else
			if (true) {
			#end

			}
		}
	}";

	var DOLLAR_TOKEN_AS_VAR_NAME = "
	class Test {
		function foo() {
			macro var $componentVarName = new $typePath();
		}
	}";

	var REFERENCE_CONSTRUCTOR = "
	@:allow(SomeClass.new) class Test {}
	class Test {
		var constructor = SomeClass.new;
	}";

	var EXPRESSION_METADATA_ISSUE_365 = "
	@test enum ContextSelectorEnum {
		@test(2) DIRECT_CHILD;
	}

	@test class Test2 {
		@test static function main() {
			@test 5 - @test 2;
		}
	}";

	var SHORT_LAMBDA = "
		class TestArrowFunctions extends Test {

		var f0_0: Void -> Int;
		var f0_1: Void -> W;

		var f1_0: Int->Int;
		var f1_1: ?Int->Int;

		var f2_0: Int->Int;

		var f3_0: Int->Int->Int;
		var f3_1: ?Int->String->Int;
		var f3_2: Int->?Int->Int;

		var f4:   Int->(Int->Int);
		var f5:   Int->Int->(Int->Int);
		var f6_a: Int->(Int->(Int->Int));
		var f6_b: Int->(Int->(Int->Int));
		var f7:   (Int->Int)->(Int->Int);
		var f8:   Int -> String;

		var arr: Array<Int->Int> = [];
		var map: Map<Int,Int->Int> = new Map();
		var obj: { f : Int->Int };

		var v0:   Int;
		var v1:   String;

		var maybe : Void -> Bool;

		function testSyntax(){

			// skipping hl for now due to variance errors:
			// Don't know how to cast ref(i32) to null(i32) see issue #6210
			#if !(hl || as3)

			maybe = () -> Math.random() > 0.5;

			v0 = (123);
			v0 = (123:Int);

			f0_0 = function () return 1;
			f0_0 = () -> 1;

			f0_0 = (() -> 1);
			f0_0 = (() -> 1:Void->Int);
			f0_0 = cast (() -> 1:Void->Int);

			v0 = f0_0();

			f0_1 = function () : W return 1;
			v1 = f0_1();

			f0_1 = () -> (1:W);
			v1 = f0_1();

			f1_0 = function (a:Int) return a;
			f1_1 = function (?a:Int) return a;

			f1_0 = a -> a;
			v0 = f1_0(1);

			f1_1 = (?a) -> a;
			v0 = f1_1(1);

			f1_1 = (?a:Int) -> a;
			v0 = f1_1(1);

			f1_1 = (a:Int=1) -> a;
			v0 = f1_1();

			f1_1 = (?a:Int=1) -> a;
			v0 = f1_1();

			f1_1 = function (a=2) return a;
			eq(f1_1(),2);

			f1_1 = (a=2) -> a;
			eq(f1_1(),2);

			f3_0 = function (a:Int, b:Int) return a + b;
			f3_1 = function (?a:Int, b:String) return a + b.length;
			f3_2 = function (a:Int, ?b:Int) return a + b;

			f3_0 = (a:Int, b:Int)  -> a + b;
			f3_1 = (?a:Int, b:String) -> a + b.length;
			f3_2 = (a:Int, ?b:Int) -> a + b;

			#if !flash
			f3_1 = function (a=1, b:String) return a + b.length;
			eq(f3_1('--'),3);

			f3_1 = function (?a:Int=1, b:String) return a + b.length;
			eq(f3_1('--'),3);

			f3_2 = function (a:Int, b=2) return a + b;
			eq(f3_2(1),3);

			f3_1 = (a=1, b:String) -> a + b.length;
			eq(f3_1('--'),3);

			f3_1 = (a:Int=1, b:String) -> a + b.length;
			eq(f3_1('--'),3);

			f3_1 = (?a:Int=1, b:String) -> a + b.length;
			eq(f3_1('--'),3);

			f3_2 = (a:Int, b=2) -> a + b;
			eq(f3_2(1),3);
			#end

			f4 = function (a) return function (b) return a + b;
			f4 = a -> b -> a + b;

			f5 = function (a,b) return function (c) return a + b + c;
			f5 = (a, b) -> c -> a + b + c;

			f6_a = function (a) return function (b) return function (c) return a + b + c;
			f6_b = a -> b -> c -> a + b + c;
			eq(f6_a(1)(2)(3),f6_b(1)(2)(3));

			f7 = function (f:Int->Int) return f;
			f7 = f -> f;
			f7 = (f:Int->Int) -> f;
			f7 = maybe() ? f -> f : f -> g -> f(g);
			f7 = switch maybe() {
				case true:  f -> f;
				case false: f -> g -> f(g);
			};

			f8 = (a:Int) -> ('$a':String);

			arr = [for (i in 0...5) a -> a * i];
			arr = [a -> a + a, b -> b + b, c -> c + c];
			arr.map( f -> f(2) );

			var arr2:Array<Int->W> = [for (f in arr) x -> f(x)];

			map = [1 => a -> a + a, 2 => a -> a + a, 3 => a -> a + a];

			obj = { f : a -> a + a };

			#end
		}
	}";

	var MULTIPLE_METADATAS = "
	class Test {
		function foo() {
			if (true)
				@inc('test') @:dox {
					someStuff();
				}
		}
	}";

	var TERNARY_WITH_KEYWORD = "
	class Test {
		function foo() {
			doSomething(withThis, Std.is(args, Array) ? cast args : [args]);
			doSomething(withThis, Std.is(args, Array) ? [args] : cast args);
			doSomething(withThis, Std.is(args, Array) ? (args) : cast args);
			doSomething(withThis, Std.is(args, Array) ? new X(args) : cast args);
			doSomething(withThis, Std.is(args, Array) ? args + 2 : cast args);
		}
	}";

	var OBJECT_WITH_ARRAY = "
	class Test2 {
		var t = {
			arg: [2, 3],
			'arg': [2, 3],
			arg2: [-x, Math.max(-x, -y)],
			arg3: {
				x: Math.max(-x, -y)
			},
			arg4: [for(i in 0...10) {x:i, x:-i}],
		};
	}";

	var MACRO_REIFICATION = "
	class Test {
		function foo() {
			switch (x) {
				case 0:
					return ${typePath};
				case 1:
					return $a{typePath};
				case 2:
					return new $typename();
				case 3:
					return { $name: 1 };
			}
		}
	}";

	var BLOCK_METADATA = "
	class Test2 {
		static function main() @inc('test') @:dox {
			@test 5 - @test 2;

			if (test) @test @:dox return x;
		}
	}";

	var COMMENTS_IN_FUNCTION_PARAMS = "
	class Test {
		function test( /* comment */ a:String /* comment */) { }
		function test2( /* comment */ /* comment */) { }
	}";

	var BLOCK_OBJECT_DECL_SAMPLES_ISSUE_396_1 = "
	class Test {
		function test() {
			//fails with: bad token Comma != BrClose
			var test = switch a
			{
			    case 3: {a: 1, b: 2};
			    default: {a: 0, b: 2};
			}
		}
	}";

	var BLOCK_OBJECT_DECL_SAMPLES_ISSUE_396_2 = "
	class Test {
		function test() {
			//fails with: bad token Kwd(KwdFunction) != DblDot
			return {
			    #if js
			    something:
			    #else
			    somethingelse:
			    #end
			    function (e)
			    {
			        e.preventDefault();
			        callback();
			    }
			};
		}
	}";

	var BLOCK_OBJECT_DECL_SAMPLES_ISSUE_396_3 = "
	class Test {
		function test() {
			return {
			    doSomething();
			    1;
			}
		}
	}";

	var BLOCK_OBJECT_DECL_WITH_TERNARY = "
	class Test {
		public function new() {
			checkInfos[names[i]] = {
				name: names[i],
				clazz: cl,
				test: new Value(1),
				test2: function() { return 1 },
				isAlias: i > 0,
				description: (i == 0) ? desc : desc + ' [DEPRECATED, use ' + names[0] + ' instead]'
			};
		}
	}";

	var TYPEDEF_COMMENTS = "
	typedef CheckFile = {
		// °
		var name:String;
		// öäü
		var content:String;
		// €łµ
		var index:Int;
		// æ@ð
	}";

	var TYPEDEF_COMMENTS_2 = "
	typedef CheckFile = {
		// °
		var name:String;
		var content:String;
		// €łµ
		var index:Int;
	}";

	var FUNCTION_RETURN_TYPE = "
	class Test {
		function test(x:String->Int->Void):String->Int->Void {
			return new TestCallback().with(x);
		}
	}";

	var FUNCTION_SHARP = "
	class Test {
		#if test
		function test() {
		#else
		function _test() {
		#end
			doSomething();
			if (test2()) return false;
		}
		function test2() {
		}
	}";

	var SWITCH_IN_OBJECT_DECL = "
	class Test {
		function foo()
			return {
				value: switch(x) {
						case 1: 1;
						case 2: 2;
					}
				}
	}";

	var COMMENTS_IN_TYPES = "
	// comment
	abstract Test {
		// comment
		function foo() {}
	}

	// comment
	class Test {
		// comment
		function foo() {}
	}

	// comment
	interface Test {
		// comment
		function foo();
	}

	// comment
	enum Test {
		// comment
		FOO;
	}

	// comment
	typedef Test = {
		// comment
		var foo:String;
	}
	";

	var ENUM_ABSTRACT = "
	enum abstract Test(String) {
		var foo:String;
	}
	";

	var QUALIFIED_META = "
	@:a.b.c('test')
	class Test {
		var foo:String;
	}
	";

	var VAR_QUESTION = "
	class Test {
		var ?foo:Int;
	}
	";

	var EXTERN_FIELD = "
	class Test {
		extern var foo:Int;
		extern function foo():Int {};
	}
	";

	var CAST_IN_OBJECT = "
	class Test {
		function foo():Int {
			var x = {
				name:arg,
				content:cast File.getBytes(arg)
			};
		};
	}
	";

	var SWITCH_THIS = "
	class Foo {
		public function toString() {
			return switch this {
				case Right(e): Type.getEnumName(e);
			}
		}
	}
	";

	var MACRO_CLASS_REIFICATION = "
	class Macro {
		static function foo() {
			macro class {
				public function new() {}
			}
		}
	}
	";

	var STRUCTURE_EXTENSION = "
	typedef Bar = {
		> Foo, > Bar2, var foo:Int; var bar:Int;
	}

	typedef Bar2 = {
		> Foo,   foo:Int, ?bar:Int
	}

	typedef Bar3 = Bar &{
		foo:Int, ?bar:Int
	} & Bar2
	";

	var BROKEN_OBJECT_DECL = "
	class Macro {
		function foo() {
			return {, i:1};
		}
	}
	";

	var FINAL_VARS = "
	class Main {
		public final foo:Int = 1;
        final static function main():{final x:Int, y:Int} {
        }
	}
	";

	var CONST_TYPE_PARAMETER = "
	abstract Tls<T>(hl.Abstract <\"hl_tls\">) {}
	";

	var CASE_VAR = "
	class Main {
		static function main() {
			switch (foo) {
				case var bar:
					trace('');
				case Pattern(var foo, var bar):
			}
		}
	}
	";

	var COMMENTS_IN_IF_ELSE = "
	class Main {
		static function main() {
			if (nBuckets > (size << 1))
				resize(nBuckets - 1); // clear 'eleted' elements
			else
				resize(nBuckets + 2); // clear 'eleted' elements
			if (nBuckets > (size << 1)) // clear 'eleted' elements
				resize(nBuckets - 1); // clear 'eleted' elements
			else // clear 'eleted' elements
				resize(nBuckets + 2); // clear 'eleted' elements
		}
	}
	";

	var COMMENTS_IN_TYPEDEF = "
	typedef Package = {
		var path:JsonPackagePath;
		// var ?contents:Array<{name:String, kind:PackageContentKind}>;
	}

	typedef Module = {
		var path:JsonModulePath;
	}
	";

	var ADVANCED_ARRAY_ITEMS = "
	class Main {
		var argHandler = hxargs.Args.generate([
			@doc('File or directory with .hx files to format (multiple allowed)')
			['-s', '--source'] => function(path:String) paths.push(path),
			@doc('Print additional information')
			['-v'] => function() verbose = true,
			@doc('Dont format, only check if files are formatted correctly')
			['--check'] => function() mode = Check,
			@doc('Display this list of options')
			['--help'] => function() help = true
		]);
	}
	";

	var IF_ELSE_COMMENTS = "
	class Main {
		function recycle() {
			// rotated recycling
			if (maxSize > 0) {
				// create new instance
				if (length < maxSize) {
					return recycleCreateObject(ObjectClass, ObjectFactory);
				}
				// get the next member if at capacity
				else {
					if (Revive)
						basic.revive();
				}
			}
			// grow-style recycling - grab a basic with exists == false or create a new one
			else {
				if (basic != null) {
					if (Revive)
						basic.revive();
				}
			}
		}
	}
	";

	var PROPS_AND_VARS = "
	class Main {
		public var canceled(default,null):Bool;
		public var callback:Void->Void;
	}
	";

	var MULTIPLE_METADATA = "
	@:allow(pack.Base)
	@test('foo')
	@new
	class Main {
		function main() {}
	}
	";

	var A_LOT_OF_COMMENTS = "
	class /**/ Main /**/ extends /**/ openfl.display.DisplayObject /**/ {} /**/
	abstract /**/ Abstract /**/ (/**/ String /**/) /**/ from /**/ String /**/ to /**/ /**/ String /**/ {}
	interface /**/ ITest /**/ extends /**/ IBase /**/ {} /**/
	typedef /**/ WinHandle /**/ = /**/ hl.Abstract /**/ <@:const 5 /**/>;
	enum Color /**/ </**/ T> /**/ {} /**/

	public function dispatch2(/**/?/**/value1/**/:/**/T1/**/<T2>/**/ = /**/ '',
		/**/ @:const value2:T2 = SomeClass.Constant,
		value2:/**/{ /**/ ?foo /**/ : /**/ Dynamic /**/ <String> /**/ }):Void
	{
	}
	";

	var TYPEDEF_OVERLOAD = "
	typedef TextDocument = {
		@:overload(function(position:Position):TextLine {})
		function lineAt(line:Int):TextLine;

		@:overload(function(position:Position):TextLine {})
		@:overload(function(position:Pos):TextLine {})
		function lineAt(line:Int):TextLine;
	}

	typedef Test4 = {
		@SuppressWarnings('checkstyle:LocalVariableName')
		public function test() {
			var Count1:Int;
		};
	}

	typedef HaxeMethodResult = {
		final ?additionalTimes:{
			final arrival:Float;
			final beforeProcessing:Float;
			final afterProcessing:Float;
		}
	}
	";

	var TERNARY_PARSING = "
	class Main {
		function __dispatchEvent(event:Event):Bool {
			var parent = event.bubbles ? this.parent : null;
			var result = super.__dispatchEvent(event);
			return result;
		}
	}

	class FlxSimplex
	{
		static inline function getCornerNoise(a:Int):Float
		{
			y = b3 == 1 ? b0 == 1 ? -y : y : b2 == 0 ? b1 == 1 ? -y : y : 0;
			return t * t * (x + y);
		}
	}
	";

	var SWITCH_CONDITIONAL = "
	class Main {
		public static function main() {
			#if neko
				switch (Sys.command ('neko', ['tests.n', name, field.name])) {
			#elseif cpp
				switch (Sys.command ('./bin/FunctionalTest', [name, field.name])) {
			#end
				case 0:
					passed++;
					Sys.println (' succedded');
			#if neko
				case 1:
					Sys.println(' failed');
			#end
				case 1:
					Sys.println(' failed');
				case _:
					Sys.println(' errored');
			}
		}
		public static function main() {
			#if neko
				switch (Sys.command ('neko', ['tests.n', name, field.name])) {
			#elseif cpp
				switch (Sys.command ('./bin/FunctionalTest', [name, field.name])) {
			#end
				default:
					passed++;
					Sys.println (' succedded');
			}
		}
		public static function main() {
			#if neko
				switch (Sys.command ('neko', ['tests.n', name, field.name]))
			#elseif cpp
				switch (Sys.command ('./bin/FunctionalTest', [name, field.name]))
			#end {
				case 0:
					passed++;
					Sys.println (' succedded');
			#if neko
				case 1:
					Sys.println(' failed');
			#end
				case 1:
					Sys.println(' failed');
				case _:
					Sys.println(' errored');
			}
		}
	}
	";

	var IMPLEMENTS_EXTENDS = "
	class Server implements ISocket extends BaseHandler
	{
	}

	class Server extends BaseHandler implements ISocket
	{
	}

	interface Server implements ISocket extends IBaseHandler
	{
	}

	interface Server extends IBaseHandler implements ISocket
	{
	}
	";

	var MACRO_PATTERNS = "
	class ExtendedLoops {
		static public function apply(e:Expr)
			return switch e {
				case macro for ($i{_} in $_)
					$_: e;
				case macro for ($head)
					$body: e;
				default: e;
			}
	}
	";

	var MACRO_CLASS_NAME = "
	class Main {
		public static function main() {
			var name = 'Foo';
			var cl = macro class $name {
				public function new() {}
			}
		}
	}
	";

	var CONDITIONALS_IN_NEW = "
	class Main {
		public static function main() {
			var process = #if sys new sys.io.Process #elseif nodejs js.node.ChildProcess.spawn #end ('curl', []);
		}
	}
	";

	var ANON_FUNTION_IN_OBJECT_LITERAL = "
	class Main {
		public static function main() {
			{
				'outer ': {
					foo: function() {
						trace('bar ');
					}
				}
			}
		}
	}
	";

	var COMMENTS_IN_SWITCH_CASES = "
	class Main {
		public static function main() {
			switch (foo) {
				// nothing to do
				case A:
					// nothing to do
					call();

				// nothing to do
				// nothing to do
				case B:
					// nothing to do
			}
			switch (foo) {
				// nothing to do
				case A:
					// nothing to do
					call();

				// nothing to do
				// nothing to do
				case B:
				// nothing to do
				default:
					// nothing to do
			}
		}
	}
	";

	var TERNARY_WITH_MACRO = "
	class GenExtractor {
		static public function anon(fields:Array<FieldInfo>, ct)
			return (macro function(value:$ct) {
				var __ret:Dynamic = {};
				$b{
					[
						for (f in fields) {
							var name = f.name;
							var assert = f.optional ? macro null:macro macro {
								$assert;
								var value = value.$name;
								__ret.$name = ${f.expr};
							}
						}
					]
				}
				return __ret;
			}).getFunction().sure();
	}
	";

	var STRUCTURE_EXTENSION_2 = "
	typedef TextDocumentClientCapabilities = /* ColorClientCapabilities & */
	{
		var foo:Int;
	}

	typedef TextDocumentClientCapabilities =
		ImplementationClientCapabilities &
		TypeDefinitionClientCapabilities &
		/* ColorClientCapabilities & */
		FoldingRangeClientCapabilities & {
		var foo:Int;
	}

	typedef TextDocumentClientCapabilities =
		/* ColorClientCapabilities & */
		FoldingRangeClientCapabilities & {
		var foo:Int;
		} &	ImplementationClientCapabilities &
		TypeDefinitionClientCapabilities;

	typedef TextDocumentClientCapabilities =
	{
		var foo:Int;
	} &{
		var foo:Int;
	}
	";

	var MACRO_DO_WHILE = "
	class ClassicFor {
		private static function makeForLoop():Expr {
			init.push(macro while($condition) {
					var shouldBreak:Bool = true;
					do $block while(shouldBreak = false);
					if(shouldBreak) break;
					$incrementExpr;
				}
			);
		}
	}
	";

	var INTERESTING_USE_OF_CONDITIONALS = "
	class Main {
		public static function main() {
			#if cs
			pony.cs.Synchro.lock(isRead, function() {
			#end
				// some code
			#if cs
			});
			#end
		}
	}
	";

	var NESTED_LOOPS = "
	class Earcut {
		function foo() {
			do {
				while (true) {}
			} while (true);
		}

		function bar() {
			do {
				while (true) {}
			} while (true);
		}
	}
	";

	var TYPED_PARAM_STRUCTURE_EXT = "
	typedef T_2<S,T> = { v0 : S, v1 : T };
	typedef T_3<S,T,R> = {> T_2<S,T>, v2 : R };
	typedef T_4<S,T,R,P> = {> T_3<S,T,R>, v3 : P };
	typedef T_5<S,T,R,P,Q> = {> T_4<S,T,R,P>, v4 : Q };
	";

	var OBJECT_LITERAL_IN_IF_ELSE_CHAIN = "
	class Main {
		function loop(min, max) {
			return if (mid == min)
				{line: mid, pos: pos - start + 1};
			else if (start > pos)
				loop(min, mid);
			else
				loop(mid, max);
		}
	}
	";

	var UNOP_AFTER_OP_ASSIGN = "
	class Main {
		public static function main() {
			ansIds[ansi] = cids[ci];
			++ci;
		}
	}
	";

	var UNOP_IN_DO_WHILE = "
	class Test {
		function foo() {
			do a++ while (true);
			do ++a while (true);
		}
	}
	";

	var TYPEDEF_WITHOUT_ASSIGN = "
	typedef Testtype {  // <-   '=' assignment is forgotten!
		something: String
	}
	";
}