module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON("package.json"),

		shell: {
			libs: {
				command: "haxelib install haxeparser 3.3.0 && " +
				"haxelib install hxargs 3.0.2 && " +
				"haxelib install compiletime 2.6.0 && " +
				"haxelib install mcover 2.1.1 && " +
				"haxelib install munit"
			}
		},

		haxe: haxeOptions(),

		zip: {
			"tokentree.zip": [
				"src/**",
				"haxelib.json", "README.md", "CHANGES.md"
			]
		}
	});

	grunt.loadNpmTasks("grunt-haxe");
	grunt.loadNpmTasks("grunt-zip");
	grunt.loadNpmTasks("grunt-shell");
	grunt.registerTask("default", ["shell", "haxe:build"]);
};

function haxeOptions() {
	return {
		build: {
			hxml: "build.hxml"
		}
	};
}