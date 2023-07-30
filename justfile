export PATH := "node_modules/.bin:" + env_var('PATH')

build-ide:
    spago build --json-errors

build:
    spago build

ci: format gen build

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
    export SAMPLE=basic
    parcel demo/static/index.html

run-example: build clean-parcel
    #!/bin/bash
    FILE=`mktemp`
    node scripts/run-example.js $FILE
    export FRAMEWORK=halogen
    export SAMPLE=`cat $FILE`
    echo "Starting $SAMPLE"
    parcel demo/static/index.html
    
clean-parcel:
    rm -rf .parcel-cache

purs-docs:
    #!/bin/bash
    shopt -s globstar;
    purs docs $(spago sources)