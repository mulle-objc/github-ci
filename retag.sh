#! /bin/sh

git tag -d v1  
git push github :v1 

git tag v1 &&
git push && 
git push --tags

