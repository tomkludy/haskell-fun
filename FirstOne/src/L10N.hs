{-# LANGUAGE CPP, TemplateHaskell, OverloadedStrings, MultiParamTypeClasses #-}
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
import Foreign
import Foreign.C

-- This is the magic of Shakespeare.I18N; the "messages" file is compiled into a type
-- "I18NMessage".  The default language is defined as "en".  Then the messages are
-- exported from this module so that they can be used where appropriate.  Callers are
-- free to use the "localize" method to localize the messages into human-readable
-- strings appropriate for their locale.

data I18N = I18N
mkMessage "I18N" "messages" "en"

-- Get locale, Mac OSX version --
-- Note: There probably is a much better way to do this, but I can't figure out FFI with Cocoa.
getLocalesFromEnvironment = do
    lang <- getEnv "LANG"
    let systemLocale = replace "_" "-" $ pack $ takeWhile (/= '.') lang
    return [systemLocale]

-- Get locale, Windows version --
-- Prefers the user's locale, then the system's locale.


#if defined(mingw32_HOST_OS) || defined(__MINGW32__)
foreign import stdcall unsafe "GetUserDefaultLocaleName"
    getUserDefaultLocaleName :: CWString -> Int -> IO Int
foreign import stdcall unsafe "GetSystemDefaultLocaleName"
    getSystemDefaultLocaleName :: CWString -> Int -> IO Int
#else
getUserDefaultLocaleName = undefined
getSystemDefaultLocaleName = undefined
#endif

maxLocaleChars = 85 -- Hardcoded constand in the Windows API
maxLocaleBytes = 2*maxLocaleChars  -- UCS-2 encoded

userDefaultLocaleName :: IO String
userDefaultLocaleName = allocaBytes maxLocaleBytes $ \ptr -> do
    rc <- getUserDefaultLocaleName ptr maxLocaleChars
    if (rc < 0)
        then return "Bad data"
        else peekCWString ptr

systemDefaultLocaleName :: IO String
systemDefaultLocaleName = allocaBytes maxLocaleBytes $ \ptr -> do
    rc <- getSystemDefaultLocaleName ptr maxLocaleChars
    if (rc < 0)
        then return "Bad data"
        else peekCWString ptr

getLocalesFromWindows = do
    userLocale <- userDefaultLocaleName
    systemLocale <- systemDefaultLocaleName
    let userLocaleT = pack userLocale
    let systemLocaleT = pack systemLocale
    return [userLocaleT,systemLocaleT]

-- END Windows --

getLocalesForOS "darwin" = getLocalesFromEnvironment
getLocalesForOS "mingw32" = getLocalesFromWindows
getLocalesForOS _ = return ["Unknown"]

-- The magic function for localization --
localize a = do
    locale <- getLocalesForOS os
    return $ renderMessage I18N locale a
