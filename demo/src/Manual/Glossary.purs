{-
<!-- START hide -->
-}
module Manual.Glossary where

import Chameleon (class Html)
import InteractiveData (DataUI, DataUI')
import InteractiveData.Core (ViewMode)

dummy :: Int
dummy = 1

{-
<!-- END hide -->
# Glossary

## Common Types
<table>
    <tr>
        <th>Type</th>
        <th>Description</th>
    </tr>
<tr></tr>

<!-- ---------------------------------------------------------- -->
<tr valign="top">
<td>
<!-- START removeType -->
-}

type T1 msg sta a = forall html. Html html => DataUI' html msg sta a

{-
<!-- END removeType -->
</td>
<td>

Simplified version of the `DataUI` type

- `msg` is the type of messages that can be sent to the UI
- `sta` is the type of the state of the UI
- `a` is the type of the data that the UI is about

</td>
</tr>
<tr></tr>

<!-- ---------------------------------------------------------- -->
<tr valign="top">
<td>
<!-- START removeType -->
-}

type T2 srf fm fs msg sta a = DataUI
  srf
  fm
  fs
  msg
  sta
  a

{-
<!-- END removeType -->
</td>
<td>

General type for Data UIs

- `srf` is the type of the surface of the UI (Typically some HTML)
- `fm` is the type of a wrapping functor applied to the messages of each Data UI layer
- `fs` is the type of a wrapping functor applied to the state of each Data UI layer
- `msg` is the type of messages that can be sent to the UI
- `sta` is the type of the state of the UI
- `a` is the type of the data that the UI is about


</td>
</tr>
<tr></tr>

<!-- ---------------------------------------------------------- -->
<tr valign="top">
<td>
<!-- START removeType -->
-}

type T3 = ViewMode

{-
<!-- END removeType -->
</td>
<td>

Each Data UI can render itself in two modes:
 - `Standalone`: The UI is rendered as a standalone page
 - `Inline`: The UI is rendered as an inline embed inside a parent UI

Usually the inline rendering is a subset of the standalone rendering.
And it's UI is much more compact.

Taking `String` as an example:
The standalone rendering of a `String` will appear as a multiline text box.
The inline rendering of a `String` will appear as a single line text box.

</td>
</tr>
<tr></tr>


<!-- ---------------------------------------------------------- -->



</table>
-}