{-# Language ForeignFunctionInterface #-}

module Text.Sundown.Markdown.Foreign
       ( Callbacks
       , Extensions (..)
       , c_sd_markdown
       ) where

import Foreign
import Foreign.C.Types

import Text.Sundown.Buffer.Foreign
import Text.Sundown.Flag

#include "markdown.h"

data Callbacks

-- | A set of switches to enable or disable markdown features.
data Extensions = Extensions { extNoIntraEmphasis :: Bool
                             , extTables          :: Bool
                             , extFencedCode      :: Bool
                             , extAutolink        :: Bool
                             , extStrikethrough   :: Bool
                             , extLaxHtmlBlocks   :: Bool
                             }

instance Flag Extensions where
  flagIndexes exts = [ (0, extNoIntraEmphasis exts)
                     , (1, extTables exts)
                     , (2, extFencedCode exts)
                     , (3, extAutolink exts)
                     , (4, extStrikethrough exts)
                     , (5, extLaxHtmlBlocks exts)
                     ]



instance Storable Callbacks where
    sizeOf _ = (#size struct sd_callbacks)
    alignment _ = alignment (undefined :: Ptr ())
    peek _ = error "Callbacks.peek is not implemented"
    poke _ _ = error "Callbacks.poke is not implemented"

c_sd_markdown :: Ptr Buffer -> Ptr Buffer -> Extensions -> Ptr Callbacks -> Ptr () -> IO ()
c_sd_markdown ob ib exts rndr opaque = c_sd_markdown' ob ib (toCUInt exts) rndr opaque
foreign import ccall "markdown.h sd_markdown"
  c_sd_markdown' :: Ptr Buffer -> Ptr Buffer -> CUInt -> Ptr Callbacks -> Ptr () -> IO ()