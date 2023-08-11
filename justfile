export PATH := "node_modules/.bin:" + env_var('PATH')

build-ide:
    spago build --json-errors | node scripts/filter-warnings.js

build:
    spago build

build-strict:
    spago build --json-errors | node scripts/filter-warnings.js

ci: clean format gen build build-strict dist-examples check-git-clean

dist-examples:
    #!/usr/bin/env bash
    set -euxo pipefail
    rm -f output/package.json
    rm -rf .parcel-cache
    rm -rf dist
    main_dir="purescript-interactive-data"; \
    for dir in demo/src/Demo/Samples/*/; do \
        name=$(basename $dir); \
        echo Building $name; \
        parcel build --dist-dir dist/$main_dir/$name --public-url /$main_dir/$name/ $dir/index.html ; \
    done

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
    node scripts/gen-readme.js
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
    export SAMPLE=SimpleHalogen
    parcel demo/static/index.html

run-example: build clean-parcel
    #!/bin/bash
    FILE=`mktemp`
    node scripts/run-example.js $FILE
    export SAMPLE=`cat $FILE`
    echo "Starting $SAMPLE"
    parcel demo/src/Demo/Samples/$SAMPLE/index.html

clean: clean-parcel clean-purs

clean-purs:
    rm -rf .spago output

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

install-git-hooks:
    rm -rf .git/hooks
    ln -s ../git-hooks .git/hooks

suggest-list:
    spago build --json-errors | node scripts/filter-warnings.js | ps-suggest --list

suggest-apply:
    spago build --json-errors | node scripts/filter-warnings.js | ps-suggest --apply

lint:
    node scripts/lint.js

open-all-files:
    code $(node scripts/modules.js)