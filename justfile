export PATH := "node_modules/.bin:" + env_var('PATH')

dev:
    spago --version