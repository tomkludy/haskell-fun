{-# LANGUAGE TemplateHaskell, OverloadedStrings, MultiParamTypeClasses #-}
-----------------------------------------------------------------------------
--
-- Module      :  L10N
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :
-- Stability   :
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------

module L10N (
    localize, I18NMessage(..)
) where

import Data.Text (Text)
import Text.Shakespeare.I18N (RenderMessage(..), mkMessage, Lang)

-- This imports the OS-specific implementation of GetLocales.getLocales.
-- Cabal handles including the correct source search paths per-platform.
import GetLocales(getLocales)

-- This is the magic of Shakespeare.I18N; the "messages" file is compiled into a type
-- "I18NMessage".  The default language is defined as "en".  Then the messages are
-- exported from this module so that they can be used where appropriate.  Callers are
-- free to use the "localize" method to localize the messages into human-readable
-- strings appropriate for their locale.

data I18N = I18N
mkMessage "I18N" "messages" "en"

-- The magic function for localization --
localize a = do
    locale <- getLocales
    return $ renderMessage I18N locale a
