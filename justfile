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

dev: clean-parcel
    FRAMEWORK=halogen yarn run parcel samples/static/index.html

clean-parcel:
    rm -rf .parcel-cache
