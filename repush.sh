#! /bin/sh


git add -u &&
git commit -m "fix" || exit 1

git tag -d v3
git push origin :v3

git tag v3 &&
git push origin &&
git push --tags
