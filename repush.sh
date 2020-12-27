#! /bin/sh


git add -u &&
git commit -m "fix" || exit 1

git tag -d v1
git push origin :v1

git tag v1 &&
git push origin &&
git push --tags
