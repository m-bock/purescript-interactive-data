module InteractiveData.App.EnvVars (envVars) where

foreign import envVars
  :: { prefix :: String
     , version :: String
     }