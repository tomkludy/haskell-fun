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

import Data.Text (Text, pack, replace)
import Text.Shakespeare.I18N (RenderMessage(..), mkMessage, Lang)
import System.Environment (getEnv)
import System.Info (os)

data I18N = I18N

mkMessage "I18N" "messages" "en"

getLocalesFromEnvironment = do
    lang <- getEnv "LANG"
    let systemLocale = replace "_" "-" $ pack $ takeWhile (/= '.') lang
    return [systemLocale]

getLocalesForOS "darwin" = getLocalesFromEnvironment
getLocalesForOS _ = return ["Unknown"]

localize a = do
    locale <- getLocalesForOS os
    return $ renderMessage I18N locale a
