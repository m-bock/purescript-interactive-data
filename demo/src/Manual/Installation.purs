{-
<!-- START hide -->
-}
module Manual.Installation where

dummy :: Int
dummy = 1

{-
<!-- END hide -->

# Installation

1. Install the library

   ```
   spago install interactive-data
   ```

2. Install a virtual dom implementation, e.g. one of the following:

   ```
   spago install chameleon-halogen
   spago install chameleon-react-basic
   ```

   This is needed because `interactive-data` itself is framework-agnostic.
   And if you want to run the resulting UI or embed it in an existing app,
   you need an adapter that will turn it into framework specific views.

3. Install a bundler, e.g.:

   ```
   npm install --dev --save parcel
   ```
-}