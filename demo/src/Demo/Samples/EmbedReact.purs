module Demo.Samples.EmbedReact where

-- import Prelude

-- import Data.Identity (Identity)
-- import Data.Maybe (Maybe(..))
-- import DataMVC.Types (DataUI, DataResult)
-- import Effect (Effect)
-- import Effect (Effect)
-- import Effect.Console (log)
-- import InteractiveData.App.WrapApp (wrapApp)
-- import InteractiveData.App.WrapData (WrapMsg, WrapState)
-- import InteractiveData.App.WrapData as App.WrapData
-- import InteractiveData.Core (class IDHtml, IDSurface)
-- import InteractiveData.DataUIs (StringMsg, StringState)
-- import InteractiveData.DataUIs as ID
-- import InteractiveData.Run as Run
-- import MVC.Types (UI)
-- import React.Basic.DOM.Client as ReactBasicDOM
-- import React.Basic.Hooks (useEffectAlways, (/\))
-- import React.Basic.Hooks as React
-- import VirtualDOM (class Html, class MaybeMsg)
-- import VirtualDOM.Impl.ReactBasic.Html (ReactHtml, defaultConfig, runReactHtml)
-- import Web.DOM as DOM

-- type Sample =
--   { firstName :: String
--   , lastName :: String
--   }

-- sampleDataUi
--   :: forall html
--    . IDHtml html
--   => DataUI (IDSurface html) _ _ _ _ Sample
-- sampleDataUi = ID.record_
--   { firstName: ID.string_
--   , lastName: ID.string_
--   }

-- sampleUi
--   :: { ui :: UI ReactHtml _ _
--      , extract :: _ -> DataResult Sample
--      }
-- sampleUi =
--   Run.toUI
--     { name: "Sample"
--     , initData: Nothing
--     , context: App.WrapData.dataUiCtx
--     }
--     $ wrapApp sampleDataUi

-- reactComponent :: React.Component {}
-- reactComponent ui = do
--   React.component "Root" \_props -> React.do

--     state /\ setState <- React.useState $ sampleUi.init

--     let
--       handler :: msg -> Effect Unit
--       handler msg = do
--         setState $ ui.update msg

--     pure
--       $ runReactHtml { handler } defaultConfig
--       $ ui.view state

-- main :: Effect Unit
-- main = log ""