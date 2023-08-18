{-
<!-- START hide -->
-}
module Manual.ComposingDataUIs where


dummy :: Int
dummy = 1

{-
<!-- END hide -->
# Composing Data UIs

In the following sections we will look at how to compose Data UIs.
They'll appear in the following form:

```hs
DataUI' _ _ SomeType
```

The `DataUI'` type is a simplified version of `DataUI`.
It hides some details which are not relevant here.

Most of the time the first two type parameters are omitted.
We do so by using the `_` wildcard.
It may be helpful o disable the wildcard warnings and completions in your editor.
Refer to the manual of the PureScript IDE plugin for more information.

-}