#!/bin/sh

set -ex
if [ -z "$(git status --porcelain)" ]; then
    git co --orphan gh-pages
    git reset
    helm package .
    helm repo index . --url https://tendant.github.io/simple-app
    git add index.yaml simple-app-0.1.0.tgz
    git commit -am "Update release"
    git clean -df
    git push -f origin gh-pages
else
    echo "There is uncommitted change! Exiting without releasing."
    exit 1