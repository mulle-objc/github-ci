#! /bin/sh

git tag -d v3
git push github :v3

git tag v3 &&
git push && 
git push --tags

