#!/bin/sh

set -ex

VERSION=$(grep -e ^version Chart.yaml | cut -d' ' -f 2)

if [ -z "$(git status --porcelain)" ]; then
    git rev-parse --verify --quiet gh-pages && git branch --quiet -D -f gh-pages
    git checkout --orphan gh-pages
    git reset
    helm package .
    helm repo index . --url https://tendant.github.io/simple-app
    git add index.yaml simple-app-$VERSION.tgz
    git commit -am "Update release"
    git clean -df
    git push -f origin gh-pages
    git checkout master
else
    echo "There is uncommitted change! Exiting without releasing."
    exit 1
fi