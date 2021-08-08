#!/bin/sh

set -ex

VERSION=$(grep -e ^version Chart.yaml | cut -d' ' -f 2)

VERS=( "0.1.1" "0.1.2" "0.1.3" )

if [ -z "$(git status --porcelain)" ]; then
    # Package master
    helm package .
    for i in "${VERS[@]}"
    do
        echo "Packaging $i..."
        git checkout $i
        helm package .
    done
    # # Package 0.1.2
    # git checkout 0.1.2
    # helm package .
    # # Package 0.1.1
    # git checkout 0.1.1
    # helm package .
    git rev-parse --verify --quiet gh-pages && git branch --quiet -D -f gh-pages
    git checkout --orphan gh-pages
    git reset
    helm repo index . --url https://tendant.github.io/simple-app
    git add index.yaml simple-app-$VERSION.tgz
    for i in "${VERS[@]}"
    do
        echo "Adding file: $i"
        git add $i
    done
    git commit -am "Update release"
    git clean -df
    git push -f origin gh-pages
    git checkout master
else
    echo "There is uncommitted change! Exiting without releasing."
    exit 1
fi