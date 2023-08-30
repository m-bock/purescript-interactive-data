# Repo structure

The codebase is split into several local packages organized in a spago monorepo.

| Package name                             | Description                                                     |
| ---------------------------------------- | --------------------------------------------------------------- |
| [interactive-data-core][link-core]       | Core types that are used by most other packages                 |
| [interactive-data-app][link-app]         | UI for App layer that adds general navigation and data wrapping |
| [interactive-data-datauis][link-datauis] | UIs for specific data types                                     |
| [interactive-data-ui][link-ui]           | Reusable UI components                                          |
| [interactive-data-run][link-run]         | Machinery that turns data UIs into a regualar UI components     |
| [interactive-data-class][link-class]     | Type class for generic Data UI creation                         |

Due to a limitation of the current spago@next release local packages are not yet published separately. Instead they are published as a single package located in a generated [mirror repo](https://github.com/thought2/purescript-interactive-data.all).

To give you an idea of the package structure, here is a _Dependency graph of local packages:_

![!image](./assets/local-packages-graph.svg)

[link-core]: packages/interactive-data-core
[link-app]: packages/interactive-data-app
[link-datauis]: packages/interactive-data-datauis
[link-ui]: packages/interactive-data-ui
[link-run]: packages/interactive-data-run
[link-class]: packages/interactive-data-class