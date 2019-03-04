module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),
        shell: {
            libs: {
                command: "haxelib install haxeparser 3.3.0 && " +
                    "haxelib install mcover && " +
                    "haxelib install munit"
            }
        },
        haxe: haxeOptions(),
        zip: {
            release: {
                src: [
                    "src/**",
                    "haxelib.json", "README.md", "CHANGELOG.md", "LICENSE"
                ],
                dest: "tokentree.zip",
                compression: "DEFLATE"
            }
        }
    });
    grunt.loadNpmTasks("grunt-haxe");
    grunt.loadNpmTasks("grunt-zip");
    grunt.loadNpmTasks("grunt-shell");
    grunt.registerTask("default", ["shell", "haxe:build"]);
}

function haxeOptions() {
    return {
        build: {
            hxml: "test.hxml"
        }
    };
}