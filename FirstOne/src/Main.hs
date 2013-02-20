{-# LANGUAGE CPP, TemplateHaskell, OverloadedStrings #-}
-----------------------------------------------------------------------------
--
-- Module      :  Main
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

module Main (
    main
) where

import Control.Monad (unless)
import Data.List (stripPrefix)
import System.Exit (exitFailure)
import Test.QuickCheck.All (quickCheckAll)
import Data.Text.IO (putStrLn)
import L10N


-- Simple function to create a hello message.
hola s = MsgHello s

hello s = localize (hola s)

-- Tell QuickCheck that if you strip "Hello " from the start of
-- hello s you will be left with s (for any s).
--prop_hello s = stripPrefix "Hello " (hello s) == Just s

-- Hello World
exeMain = do
   msg <- hello "World"
   Data.Text.IO.putStrLn msg

-- Entry point for unit tests.
testMain = do
    allPass <- $quickCheckAll -- Run QuickCheck on all prop_ functions
    unless allPass exitFailure

-- This is a clunky, but portable, way to use the same Main module file
-- for both an application and for unit tests.
-- MAIN_FUNCTION is preprocessor macro set to exeMain or testMain.
-- That way we can use the same file for both an application and for tests.
#ifndef MAIN_FUNCTION
#define MAIN_FUNCTION exeMain
#endif
main = MAIN_FUNCTION

