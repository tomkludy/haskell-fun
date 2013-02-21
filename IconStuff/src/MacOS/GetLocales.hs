{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
--
-- Module      :  MacOS.GetLocales
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

module GetLocales (
    getLocales
) where

import Data.Text (Text, pack, replace)
import System.Environment (getEnv)

-- Get locale, Mac OSX version --
-- Note: There probably is a much better way to do this, but I can't figure out FFI with Cocoa.
getLocales = do
    lang <- getEnv "LANG"
    let systemLocale = replace "_" "-" $ pack $ takeWhile (/= '.') lang
    return [systemLocale]
