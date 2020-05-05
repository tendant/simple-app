git co --orphan gh-pages
helm package .
helm repo index . --url https://tendant.github.io/simple-app
