{-# LANGUAGE OverloadedStrings #-}

module StatText (wordCount) where

import qualified Data.Text.Lazy as T

import Data.Function(on)
import Data.List(sortBy)
import Data.Map.Lazy (Map, empty, insertWith, assocs)


wordCount :: T.Text -> [(T.Text, Integer)]
wordCount = count . filter specialWord . filter (\w -> T.length w > 3) . T.split wordSeparator . T.toCaseFold
	where

	wordSeparator :: Char -> Bool
	wordSeparator = flip elem ".`()-_=></\"\\#%' \n\r\t" -- Todo use regexp

	specialWord :: T.Text -> Bool
	specialWord = not . flip elem ["nous", "avec", "dans", "mais", "vous", "notre", "plus", "pour"]

count :: Ord a => [a] -> [(a, Integer)]
count = filter ((>2) . snd) . sortBy (flip $ on compare snd) . assocs . foldr f empty
	where f a = insertWith (+) a 1