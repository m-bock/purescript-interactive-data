# purescript-interactive-data

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

## Getting started


### Installation

```sh
spago install interactive-data
npm install parcel
```

### Minimal complete example

The following example renders with `Halogen`. Have a look at the demo folder for more examples in different frameworks.

*src/Main.purs*
```hs
module Main where

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
    sampleDataUi = ID.string_
  let
    { ui, extract } = VD.Run.toUI
      { name: "Sample"
      , initData: Just "hello!"
      }
      VD.Run.ctxNoWrap
      sampleDataUi

  ui
    # HI.uiToHalogenComponent
        { onStateChange: \newState -> do
            log (show $ extract newState)
        }
    # HI.uiMountAtId "root"
```

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
