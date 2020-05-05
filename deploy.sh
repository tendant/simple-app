#!/bin/sh

set -ex

git co --orphan gh-pages
git reset
helm package .
helm repo index . --url https://tendant.github.io/simple-app
git add index.yaml simple-app-0.1.0.tgz
git commit -am "Update release"
git clean -df
# git push