{-# LANGUAGE OverloadedStrings #-}
-----------------------------------------------------------------------------
--
-- Module      :  GetLocales
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :
-- Stability   :
-- Portability : MacOS (darwin) only
--
-- |
--
-----------------------------------------------------------------------------

module GetLocales (
    getLocales
) where

import qualified Data.Text as T
import System.Process(readProcess)

charsToIgnore = "(),\""
stripChars = T.pack . (filter . flip notElem) charsToIgnore

-- Get locale, Mac OSX version --
-- Note: There probably is a much better way to do this, but I can't figure out FFI with Cocoa.
getLocales = do
    syslangs <- readProcess "defaults" ["read","NSGlobalDomain","AppleLanguages"] []
    return $ T.words $ stripChars syslangs
