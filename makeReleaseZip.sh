#!/bin/bash -e

npm install
npx lix download
npx lix use haxe 4.3.1

haxe test.hxml

rm -f tokentree.zip
zip -9 -r -q tokentree.zip src haxelib.json hxformat.json package.json README.md CHANGELOG.md LICENSE
