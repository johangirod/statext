import StatText
import qualified Data.Text.Lazy as T

main = interact $ show . wordCount . T.pack