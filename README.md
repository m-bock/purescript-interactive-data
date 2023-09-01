# purescript-interactive-data

![interactive-data](./assets/logo.svg)

Define UIs in terms of data types.

![ci](https://github.com/thought2/purescript-interactive-data/actions/workflows/ci.yaml/badge.svg)
&nbsp;
![release](https://img.shields.io/github/v/tag/thought2/purescript-interactive-data?label=latest%20release)


## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Live Demo](#live-demo)
- [Features](#features)
- [Use cases](#use-cases)
- [Supported types](#supported-types)
- [Documentation](#documentation)
  - [API](#api)
  - [Library Manual](#library-manual)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Minimal complete example](#minimal-complete-example)
  - [Run](#run)
- [Limitations](#limitations)
- [Contributing](#contributing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Live Demo

<a href="https://interactive-data.app/sample-painting-app-halogen">
  <img src="https://github.com/thought2/assets/blob/3ac74450fed65cc663c6e0e88db52b75fc323c28/interactive-data/demo3.png" width="400">
</a>

- Painting App ([Source](demo/src/Demo/Samples/PaintingApp))
  - [Halogen](https://interactive-data.app/sample-painting-app-halogen) (with routing)
  - [React](https://interactive-data.app/sample-painting-app-react/) (no routing)

## Features

<!-- START features  -->
- **Data centric**
  <br>
  _UIs are defined in terms of data types. You don't have to know much about frontends._
- **Type safety**
  <br>
  _Impossible to create wrong configutations for given types._
- **Framework agnostic**
  <br>
  _Can be embedded in any ReactBasic or Halogen app_
- **Configurable**
  <br>
  _UIs for each data type can be customized_
- **Extensible**
  <br>
  _UIs for any data type can be written in a simple MVC architecture_
- **Data validation**
  <br>
  _Data is validated on the fly and errors are displayed_
<!-- END features -->


## Use cases

Any part of a web app that need to handle user input of nested structured data. E.g:
It works best for scenarios where highest priority is correctness of data and not so much the look and feel.

- Settings/Config panels
- Controls to showcase UI components
- Back office tools

## Supported types

The following types are supported out of the box:

- Primitives like `String`, `Int`, `Number`, `Boolean`
- `Record`
- `Variant`
- `Array`
- Common ADTs like `Maybe`, `Either`, `Tuple`
- Newtypes
- Refinement of existing types (smart constructor pattern)
- Custom ADTs
- Generic Json inputs for not yet supported types

## Documentation

### API

[API docs](https://pursuit.purescript.org/packages/purescript-interactive-data) are published on Pursuit.

### Library Manual

Learn about the core concepts of `interactive-data` in the [Library Manual](https://interactive-data.app/manual).

## Getting started

### Installation

1. Install the library

   ```
   spago install interactive-data
   ```

2. Install a virtual dom implementation, e.g. one of the following:

   ```
   spago install chameleon-halogen
   spago install chameleon-react-basic
   ```

3. Install a bundler, e.g.:

   ```
   npm install --dev --save parcel
   ```

### Minimal complete example

The following example renders with `Halogen`. Have a look at the demo folder for more examples in different frameworks.

<!-- START demoApp  -->
*src/Main.purs:*
```hs
module Main (main) where

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
        , showLogo: false
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

We also need to create a simple html file and a `index.js` file to run the web app.

<!-- START demoHtml  -->
*static/index.html:*
```html
<html>
  <head>
    <title>Interactive Data Sample</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <script src="index.js" type="module"></script>
    <div id="root"></div>
  </body>
</html>
```
<!-- END demoHtml -->

<!-- START demoIndex  -->
*static/index.js:*
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

## Limitations

- Currently no support for recursive types.
- Data UIs cannot have side effects other than user input. A Data UI that fetches data from a server is currently not possible.

## Contributing

If you have ideas for improvements or want to contribute, please open an issue or PR.

The repo structure is described in [docs/repo-structure.md](docs/repo-structure.md).