# purescript-interactive-data

<img align="right" width="400" src="assets/demo.png">
<br>

![interactive-data](./assets/logo.svg)

Composable UIs to interactively maniupulate data.

## Features

- Framework agnostic
- Configurable
- Extensible
- Types
  - Primitive types
  - Custom ADTs
  - Variants

<br>

## Table of Contents

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Minimal complete example](#minimal-complete-example)
  - [Run](#run)
- [Local Packages](#local-packages)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Getting started

### Installation

1. Install the library

   ```sh
   spago install interactive-data
   ```

2. Install a virtual dom implementation, e.g.:

   ```sh
   spago install virtual-dom-halogen
   ```

3. Install a bundler, e.g.:

   ```sh
   npm install --dev --save parcel
   ```

### Minimal complete example

The following example renders with `Halogen`. Have a look at the demo folder for more examples in different frameworks.

_src/Main.purs_

<!-- START demo -->
```hs
module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData as ID
import VirtualDOM.Impl.Halogen as HI

main :: Effect Unit
main = do
  let
    -- 1. Compose a "Data UI" for a specific type
    sampleDataUi =
      ID.record_
        { firstName: ID.string_
        , lastName: ID.string_
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
<!-- END demo -->

_index.html_

```html
<html>
  <body>
    <script src="main.js" type="module"></script>
    <div id="root"></div>
  </body>
</html>
```

_main.js_

```js
import { main } from "../output/Main/index.js";

main();
```

### Run

```
spago build
parcel index.html
```

Go to http://localhost:1234

## Local Packages

|                         |                                |
| ----------------------- | ------------------------------ |
| [core][link-core]       |                                |
| [app][link-app]         | App layer that adds navigation |
| [datauis][link-datauis] | UIs for specific data types    |
| [run][link-run]         |                                |
| [class][link-class]     |                                |

![!image](./assets/local-packages-graph.svg)

[link-core]: packages/interactive-data-core
[link-app]: packages/interactive-data-app
[link-datauis]: packages/interactive-data-datauis
[link-run]: packages/interactive-data-run
[link-class]: packages/interactive-data-class
