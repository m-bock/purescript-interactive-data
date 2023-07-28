
# purescript-interactive-data

![interactive-data](./assets/logo.svg)

Composable UIs to interactively maniupulate data.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Features](#features)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Minimal complete example](#minimal-complete-example)
  - [Run](#run)
- [Local Packages](#local-packages)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Features

- Framework agnostic
- Configurable
- Extensible
- Types
  - Primitive types
  - Custom ADTs
  - Variants

## Getting started



### Installation

```sh
spago install interactive-data
npm install parcel
```

### Minimal complete example

The following example renders with `Halogen`. Have a look at the demo folder for more examples in different frameworks.



*src/Main.purs*

<!-- START demo -->
```hs
module Demo.Samples.MinimalComplete where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class.Console (log)
import InteractiveData.DataUIs as ID
import InteractiveData.Run as VD.Run
import VirtualDOM.Impl.Halogen as HI

main :: Effect Unit
main = do
  let
    -- Compose a Data UI for a specific type
    sampleDataUi = ID.string_
  let
    { ui, extract } =
      sampleDataUi
        # VD.Run.toUI
            { name: "Sample"
            , initData: Just "hello!"
            , context: VD.Run.ctxNoWrap
            }

  ui
    -- Turn into a Halogen component
    # HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    -- Mount at the root element
    # HI.uiMountAtId "root"

```
<!-- END demo -->

*index.html*
```html
<html>
  <body>
    <script src="main.js" type="module"></script>
    <div id="root"></div>
  </body>
</html>
```

*main.js*
```js
import { main } from "../../output/Main/index.js";

main();
```

### Run

```
spago build
parcel demo/index.html
```

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
