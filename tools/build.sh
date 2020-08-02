#!/bin/sh

rm -rf dist
mkdir dist
cp -r LiveStack.lrdevplugin dist/LiveStack.lrplugin
cp LICENSE README.md dist/LiveStack.lrplugin
cd dist
zip -r LiveStack.zip LiveStack.lrplugin
rm -rf LiveStack.lrplugin
