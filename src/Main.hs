{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Network.HTTP.Simple            ( httpBS
                                                , getResponseBody
                                                )
import qualified Data.ByteString.Char8         as BS
import           Data.Aeson.Lens                ( key
                                                , _String
                                                )
import           Data.Text                      ( Text )
import           Control.Lens                   ( preview )
import qualified Data.Text.IO                  as TIO


-- {
--   "time": {
--     "updated": "Nov 22, 2020 23:10:00 UTC",
--     "updatedISO": "2020-11-22T23:10:00+00:00",
--     "updateduk": "Nov 22, 2020 at 23:10 GMT"
--   },
--   "disclaimer": "This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org",
--   "chartName": "Bitcoin",
--   "bpi": {
--     "USD": {
--       "code": "USD",
--       "symbol": "&#36;",
--       "rate": "18,537.6472",
--       "description": "United States Dollar",
--       "rate_float": 18537.6472
--     },
--     "GBP": {
--       "code": "GBP",
--       "symbol": "&pound;",
--       "rate": "13,940.3849",
--       "description": "British Pound Sterling",
--       "rate_float": 13940.3849
--     },
--     "EUR": {
--       "code": "EUR",
--       "symbol": "&euro;",
--       "rate": "15,631.6856",
--       "description": "Euro",
--       "rate_float": 15631.6856
--     }
--   }
-- }


fetchJSON :: IO BS.ByteString
fetchJSON = do
  res <- httpBS "https://api.coindesk.com/v1/bpi/currentprice.json"
  return (getResponseBody res)


getRate :: BS.ByteString -> Maybe Text
getRate = preview (key "bpi" . key "USD" . key "rate" . _String)


main :: IO ()
main = do
  json <- fetchJSON

  case getRate json of
    Nothing   -> TIO.putStrLn "Oops! Could not find the Bitcoin rate :("
    Just rate -> TIO.putStrLn $ "The current Bitcoin rate is $" <> rate
