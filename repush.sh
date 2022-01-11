#! /bin/sh


git add -u &&
git commit -m "fix" || exit 1

git tag -d v3
git push github :v3

git tag v3 &&
git push github &&
git push --tags
