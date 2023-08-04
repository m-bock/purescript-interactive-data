# purescript-interactive-data

![interactive-data](./assets/logo.svg)

Composable UIs for interactive data.

![ci](https://github.com/thought2/purescript-interactive-data/actions/workflows/ci.yaml/badge.svg)

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Discaimer ⚠](#discaimer-)
- [Live Demo](#live-demo)
- [Features](#features)
- [Supported types](#supported-types)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Minimal complete example](#minimal-complete-example)
  - [Run](#run)
- [Contributing](#contributing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Discaimer ⚠

This library is in early development and the API is not stable yet. Things may not yet work as expected.

## Live Demo

<img src="https://github.com/thought2/assets/blob/ae1e971611b02c4a6bcd42124e4e1d43aa2e537e/interactive-data/demo1.png" width="200">

[thought2.github.io/purescript-interactive-data](https://thought2.github.io/purescript-interactive-data)

## Features

- **Framework agnostic**
  <br>
  _Can be embedded in any ReactBasic or Halogen app_
- **Configurable**
  <br>
  _UIs for each data type can be customized_
- **Extensible**
  <br>
  _UIs for any data type can be written in a simple MVC architecture_

## Supported types

The following types are supported out of the box:

- `String`
- `Int`
- `Number`
- `Record`

## Getting started

### Installation

1. Install the library

   ```sh
   spago install interactive-data
   ```

2. Install a virtual dom implementation, e.g.:

   ```sh
   spago install chameleon-halogen
   ```

3. Install a bundler, e.g.:

   ```sh
   npm install --dev --save parcel
   ```

### Minimal complete example

The following example renders with `Halogen`. Have a look at the demo folder for more examples in different frameworks.

<!-- START demoApp -->
*src/Main.purs:*
```hs
module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData as ID
import Chameleon.Impl.Halogen as HI

main :: Effect Unit
main = do
  let
    -- 1. Compose a "Data UI" for a specific type
    sampleDataUi = ID.record_
      { user: ID.record_
          { firstName: ID.string_
          , lastName: ID.string_
          , size: ID.number { min: 0.0, max: 100.0 }
          }
      , meta: ID.record_
          { description: ID.string_
          , headline: ID.string_
          }
      }

    -- 2. Turn "Data UI" into an App interface
    sampleApp =
      ID.toApp
        { name: "Sample"
        , initData: Nothing
        , fullscreen: true
        }
        sampleDataUi

    -- 3. Create Halogen component
    halogenComponent =
      HI.uiToHalogenComponent
        { onStateChange: \newState -> do

            -- Use the `extract` function to get data out of the state
            log (show $ sampleApp.extract newState)
        }
        sampleApp.ui

  -- 4. Finally mount the component to the DOM
  HI.uiMountAtId "root" halogenComponent
```
<!-- END demoApp -->

We also need to create a simple html file and a `main.js` file to run the web app.

<!-- START demoHtml -->
*static/index.html:*
```html
<html>
  <head>
    <title>Interactive Data Sample</title>
  </head>
  <body>
    <script src="main.js" type="module"></script>
    <div id="root"></div>
  </body>
</html>
```
<!-- END demoHtml -->

<!-- START demoIndex -->
*static/main.js:*
```js
import { main } from "../output/Main/index.js";

main();
```
<!-- END demoIndex -->

### Run

```
spago build
parcel static/index.html
```

Go to http://localhost:1234

## Contributing

If you have ideas for improvements or want to contribute, please open an issue or PR.

The codebase is split into several local packages organized in a spago monorepo.

| Package name                             | Description                                                     |
| ---------------------------------------- | --------------------------------------------------------------- |
| interactive-data-[core][link-core]       | Core types that are used by most other packages                 |
| interactive-data-[app][link-app]         | UI for App layer that adds general navigation and data wrapping |
| interactive-data-[datauis][link-datauis] | UIs for specific data types                                     |
| interactive-data-[ui][link-ui]           | Reusable UI components                                          |
| interactive-data-[run][link-run]         | Machinery that turns data UIs into a regualar UI components     |
| interactive-data-[class][link-class]     | Type class for generic Data UI creation                         |

Due to a limitation of the current spago@next release local packages are not yet published separately. Instead they are published as a single package located in a generated [mirror repo](https://github.com/thought2/purescript-interactive-data.all).

To give you an idea of the package structure, here is a _Dependency graph of local packages:_

![!image](./assets/local-packages-graph.svg)

[link-core]: packages/interactive-data-core
[link-app]: packages/interactive-data-app
[link-datauis]: packages/interactive-data-datauis
[link-ui]: packages/interactive-data-ui
[link-run]: packages/interactive-data-run
[link-class]: packages/interactive-data-class
