export PATH := "node_modules/.bin:" + env_var('PATH')

build-ide:
    spago build --json-errors

build:
    spago build

ci: format gen build check-git-clean

dist-example: build
    #!/bin/bash
    export FRAMEWORK=halogen
    export SAMPLE=Simple
    mv output/package.json output/package.json.bak
    parcel build \
      --dist-dir dist/purescript-interactive-data \
      --public-url /purescript-interactive-data/ \
      demo/static/index.html
    mv output/package.json.bak output/package.json

run-dist:
    http-server dist

format:
    purs-tidy format-in-place "packages/*/src/**/*.purs"
    purs-tidy format-in-place "packages/*/test/**/*.purs"
    purs-tidy format-in-place "demo/src/**/*.purs"
    purs-tidy format-in-place "demo/test/**/*.purs"

gen: gen-graph gen-readme gen-extra-packages gen-assets

gen-graph:
    dot -Tsvg assets/local-packages-graph.dot -o assets/local-packages-graph.svg

gen-readme:
    node scripts/patch-readme.js
    doctoc README.md

gen-extra-packages:
    node scripts/gen-extra-packages.js

gen-assets:
    purs-virtual-dom-assets \
      --srcPath packages/interactive-data-app/assets \
      --dstPath packages/interactive-data-app/src/InteractiveData/App/UI/Assets \
      --baseModule 'InteractiveData.App.UI.Assets'

dev: clean-parcel
    #!/bin/bash
    export FRAMEWORK=halogen
    export SAMPLE=Basic
    parcel demo/static/index.html

run-example: build clean-parcel
    #!/bin/bash
    FILE=`mktemp`
    node scripts/run-example.js $FILE
    export FRAMEWORK=halogen
    export SAMPLE=`cat $FILE`
    echo "Starting $SAMPLE"
    parcel demo/static/index.html

clean: clean-parcel clean-purs-output

clean-purs-output:
    rm -rf output

clean-parcel:
    rm -rf .parcel-cache

purs-docs:
    #!/bin/bash
    shopt -s globstar;
    purs docs $(spago sources)

check-git-clean:
    [ " M docs/extra-packages.yaml" = "$(git status --porcelain)" ]

mk-single-pkg:
    node scripts/mk-single-pkg.js