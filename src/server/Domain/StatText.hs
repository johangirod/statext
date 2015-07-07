{-# LANGUAGE OverloadedStrings #-}

module Domain.StatText (wordCount) where

import qualified Data.Text.Lazy as T

import Data.Function(on)
import Data.List(sortBy)
import Data.Map.Lazy (Map, empty, insertWith, assocs)

import Debug.Trace

wordCount :: T.Text -> [(T.Text, Integer)]
wordCount = count . filter specialWord . filter (\w -> T.length w > 3) . T.split wordSeparator . T.toCaseFold
	where
	wordSeparator :: Char -> Bool
	wordSeparator = flip elem ".,;`()-_=></\"\\#%' \n\r\t" -- Todo use regexp

	specialWord :: T.Text -> Bool
	specialWord = not . flip elem ["the", "be", "to", "of", "and", "a", "in", "that", "have", "I", "it", "for", "not", "on", "with", "he", "as", "you", "do", "at", "this", "but", "his", "by", "from", "they", "we", "say", "her", "she", "or", "an", "will", "my", "one", "all", "would", "there", "their", "what", "so", "up", "out", "if", "about", "who", "get", "which", "go", "me", "when", "make", "can", "like", "time", "no", "just", "him", "know", "take", "people", "into", "year", "your", "good", "some", "could", "them", "see", "other", "than", "then", "now", "look", "only", "come", "its", "over", "think", "also", "back", "us", "after", "use", "two", "how", "our", "work", "first", "well", "way", "even", "new", "want", "because", "any", "these", "give", "day", "most"]

count :: Ord a => [a] -> [(a, Integer)]
count = sortBy (flip $ on compare snd) . assocs . foldr f empty
	where f a = insertWith (+) a 1