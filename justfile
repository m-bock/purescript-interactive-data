export PATH := "node_modules/.bin:" + env_var('PATH')

build:
    spago build

build-strict:
    spago build --json-errors | node scripts/filter-warnings.js


mk-single-pkg:
    node scripts/mk-single-pkg.js

install-git-hooks:
    rm -rf .git/hooks
    ln -s ../git-hooks .git/hooks

lint:
    node scripts/lint.js

install:
    npm ci

# Dist

dist-examples:
    #!/usr/bin/env bash
    set -euxo pipefail
    rm -f output/package.json
    rm -rf .parcel-cache
    rm -rf dist
    main_dir="purescript-interactive-data"; \
    export VERSION=$(git rev-parse HEAD); \
    for dir in demo/src/Demo/Samples/*/; do \
        name=$(basename $dir); \
        echo Building $name $VERSION; \
        export PREFIX="/$main_dir/$name"; \
        parcel build --dist-dir dist/$main_dir/$name --public-url /$main_dir/$name/ $dir/index.html ; \
    done

serve-dist:
    http-server dist

# Fix

format:
    purs-tidy format-in-place "packages/*/src/**/*.purs"
    purs-tidy format-in-place "packages/*/test/**/*.purs"
    purs-tidy format-in-place "demo/src/**/*.purs"
    purs-tidy format-in-place "demo/test/**/*.purs"

# Dev

dev: clean-parcel
    #!/bin/bash
    export SAMPLE=SimpleHalogen
    parcel demo/static/index.html

run-example: build clean-parcel
    #!/bin/bash
    FILE=`mktemp`
    node scripts/run-example.js $FILE
    export SAMPLE=`cat $FILE`
    echo "Starting $SAMPLE"
    parcel demo/src/Demo/Samples/$SAMPLE/index.html

run-dist:
    http-server dist

# Clean

clean: clean-parcel clean-purs

clean-purs:
    rm -rf .spago output

clean-parcel:
    rm -rf .parcel-cache

# Generate

gen: gen-graph gen-readme gen-assets gen-manual

gen-graph:
    dot -Tsvg assets/local-packages-graph.dot -o assets/local-packages-graph.svg

gen-readme:
    node scripts/gen-readme.js
    doctoc README.md

clean-manual:
    #!/bin/bash
    MD_PATH=docs/manual
    rm -rf $MD_PATH
    
gen-manual: clean-manual
    just gen-manual_

gen-manual_:
    #!/bin/bash
    PURS_PATH=demo/src
    MD_PATH=mdbook/src

    FILE=Manual
    mkdir -p $MD_PATH/$(dirname $FILE)
    purs-to-md --input-purs $PURS_PATH/$FILE.purs --output-md $MD_PATH/$FILE.md
    node scripts/postprocess-manual-page.js $MD_PATH/$FILE.md

    FILE=Manual/Ch01ComposingDataUIs/Ch01Primitives
    mkdir -p $MD_PATH/$(dirname $FILE)
    purs-to-md --input-purs $PURS_PATH/$FILE.purs --output-md $MD_PATH/$FILE.md
    node scripts/postprocess-manual-page.js $MD_PATH/$FILE.md

    FILE=Manual/Ch01ComposingDataUIs/Ch02Records
    mkdir -p $MD_PATH/$(dirname $FILE)
    purs-to-md --input-purs $PURS_PATH/$FILE.purs --output-md $MD_PATH/$FILE.md
    node scripts/postprocess-manual-page.js $MD_PATH/$FILE.md

gen-assets:
    purs-virtual-dom-assets \
      --srcPath packages/interactive-data-app/assets \
      --dstPath packages/interactive-data-app/src/InteractiveData/App/UI/Assets \
      --baseModule 'InteractiveData.App.UI.Assets'

purs-docs:
    #!/bin/bash
    shopt -s globstar;
    purs docs $(spago sources)

# Fix

suggest-list:
    spago build --json-errors | node scripts/filter-warnings.js | ps-suggest --list

suggest-apply:
    spago build --json-errors | node scripts/filter-warnings.js | ps-suggest --apply

# CI

ci_: install format gen build build-strict dist-examples check-git-clean

ci: clean
    just ci_

ci-tmp:
    HERE=$(pwd); \
    DIR=$(mktemp -d); \
    echo $DIR; \
    cd $DIR; \
    git clone $HERE .; \
    nix develop --command just ci
    
check-git-clean:
    [ "" = "$(git status --porcelain)" ]

# IDE

build-ide:
    spago build --json-errors | node scripts/filter-warnings.js

open-all-files:
    code $(node scripts/modules.js)