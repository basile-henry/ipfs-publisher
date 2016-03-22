{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE NamedFieldPuns #-}

module Network.IPFS.Publisher(
    Config(..), Version(..),
    initDir, publish, saveConfig, readConfig)
where


import           Data.Aeson           (FromJSON, ToJSON, decode, encode)
import           Data.ByteString.Lazy (readFile, writeFile)
import           Data.ByteString.UTF8 (toString)
import           Data.Time            (getCurrentTime)
import           GHC.Generics         (Generic)
import           Network.IPFS         (addDir)
import           Network.IPFS.API     (Endpoint (..))
import qualified Network.IPNS         as IPNS
import           Prelude              hiding (readFile, writeFile)

data Version = Version {
        date_time :: String,
        hash      :: String
    }
    deriving (Show, Eq, Generic)

instance FromJSON Version
instance ToJSON   Version

data Config  = Config {
        directory :: FilePath,
        versions  :: [Version]
    }
    deriving (Show, Eq, Generic)

instance FromJSON Config
instance ToJSON   Config

saveConfig :: Config -> FilePath -> IO ()
saveConfig conf path = writeFile path $ encode conf

readConfig :: FilePath -> IO (Maybe Config)
readConfig path = decode <$> readFile path

initDir :: FilePath -> Config
initDir dir = Config dir []

publish :: Endpoint -> Config -> IO Config
publish endpoint conf@Config{directory, versions} = do
    h   <- addDir endpoint directory
    now <- getCurrentTime
    let new_conf = conf{versions = versions ++ [Version (show now) (toString h)]}
    if length versions > 0 && (hash (last versions) == toString h)
        then do putStrLn "Nothing to update."; return conf
        else do IPNS.publish endpoint (toString h); return new_conf
