# Data UIs for Record types

<!-- START hide -->

<!-- END hide -->
<!-- START imports -->
<details><summary>Imports for the code samples</summary>


```hs
import Data.Maybe (Maybe(..))
import InteractiveData (DataUI')
import InteractiveData as ID
```

</details><hr><br>
<!-- END imports -->

In the previous chapter we've seen how to create Data UIs for primitive data types.

Data UIs can also be created for Records. Let's assume we have defined the following Record type alias:


```hs
type User =
  { name :: String
  , age :: Int
  , address :: String
  }
```

Now we can create a Data UI with the `record_` function like this:


```hs
sampleRecord :: DataUI' _ _ User
sampleRecord =
  ID.record_
    { name: ID.string_
    , age: ID.int_
    , address: ID.string_
    }
```


If the `_` is omitted configuration options can be provided for the record. This
works exactly like the configuration for the primitive types:



```hs
sampleRecordOpts :: DataUI' _ _ User
sampleRecordOpts =
  ID.record
    { text: Just "A sample User"
    }
    { name: ID.string_
    , age: ID.int { text: Just "The age of the user", min: 0, max: 100 }
    , address: ID.string_
    }
```

If you just want to use the default options for each field, you can also use the
general `dataUi` function. The actual Data UI will be derived by the type.
This example is equivalent to the `sampleRecord` value above.


```hs
sampleRecord' :: DataUI' _ _ User
sampleRecord' = ID.dataUi
```