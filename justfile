export PATH := "node_modules/.bin:" + env_var('PATH')

build-ide:
    spago build --json-errors

build:
    spago build --pedantic-packages

format:
    purs-tidy format-in-place "packages/*/src/**/*.purs"
    purs-tidy format-in-place "packages/*/test/**/*.purs"
    purs-tidy format-in-place "packages/*/sample/**/*.purs"

gen:
    dot -Tsvg assets/local-packages-graph.dot -o assets/local-packages-graph.svg

gen-readme:
    node scripts/patch-readme.js
    doctoc README.md

dev: clean-parcel
    #!/bin/bash
    export FRAMEWORK=halogen
    export SAMPLE=basic
    parcel demo/static/index.html

clean-parcel:
    rm -rf .parcel-cache

purs-docs:
    #!/bin/bash
    shopt -s globstar;
    purs docs $(spago sources)