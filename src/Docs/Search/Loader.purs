module Docs.Search.Loader where

import Docs.Search.Types (GlobalIdentifier, URL)

import Prelude

import Control.Monad.Error.Class (throwError)
import Control.Promise (Promise, toAffE)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode.Error (printJsonDecodeError)
import Data.Argonaut.Decode.Class (class DecodeJson, decodeJson)
import Data.Either (either)
import Data.Newtype (unwrap)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Exception (error)



load
 :: forall a
 .  DecodeJson a
 => GlobalIdentifier
 -> URL
 -> Aff a
load globalIdentifier url = do
  json <- toAffE (loadFromScript globalIdentifier url)
  either throw pure $ decodeJson json
  where
    throw err = throwError $ error $
      "Couldn't load content from window." <>
      unwrap globalIdentifier <> ": " <> printJsonDecodeError err


foreign import loadFromScript
  :: GlobalIdentifier
  -> URL
  -> Effect (Promise Json)
