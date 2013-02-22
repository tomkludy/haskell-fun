{-# LANGUAGE OverloadedStrings, ForeignFunctionInterface #-}
-----------------------------------------------------------------------------
--
-- Module      :  GetLocales
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :
-- Stability   :
-- Portability : Windows only
--
-- |
--
-----------------------------------------------------------------------------

module GetLocales (
    getLocales
) where

import Data.Text as T
import Foreign
import Foreign.C

foreign import stdcall unsafe "GetUserDefaultLocaleName"
    getUserDefaultLocaleName :: CWString -> Int -> IO Int
foreign import stdcall unsafe "GetSystemDefaultLocaleName"
    getSystemDefaultLocaleName :: CWString -> Int -> IO Int

-- Get locale, Windows version --
-- Prefers the user's locale, then the system's locale.

maxLocaleChars = 85 -- Hardcoded constand in the Windows API
maxLocaleBytes = 2 * maxLocaleChars  -- UCS-2 encoded

userDefaultLocaleName :: IO String
userDefaultLocaleName = allocaBytes maxLocaleBytes $ \ptr -> do
    rc <- getUserDefaultLocaleName ptr maxLocaleChars
    if rc < 0
        then return "Bad data"
        else peekCWString ptr

systemDefaultLocaleName :: IO String
systemDefaultLocaleName = allocaBytes maxLocaleBytes $ \ptr -> do
    rc <- getSystemDefaultLocaleName ptr maxLocaleChars
    if rc < 0
        then return "Bad data"
        else peekCWString ptr

getLocales = do
    userLocale <- userDefaultLocaleName
    systemLocale <- systemDefaultLocaleName
    let userLocaleT = T.pack userLocale
    let systemLocaleT = T.pack systemLocale
    return [userLocaleT,systemLocaleT]
