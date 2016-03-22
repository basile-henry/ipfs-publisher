{-# LANGUAGE LambdaCase #-}

module Main(main) where

import           Network.IPFS.API       (localEndpoint)
import           Network.IPFS.Publisher (Config (..), Version (..), initDir,
                                         publish, readConfig, saveConfig)
import           System.Directory       (doesDirectoryExist)
import           System.Environment     (getArgs)

main :: IO ()
main = dealWithArgs =<< getArgs

dealWithArgs :: [String] -> IO ()
dealWithArgs ("init":dir:_) = do
    isDir <- doesDirectoryExist dir
    if isDir
        then saveConfig (initDir dir) configPath
        else printUsage
dealWithArgs ("publish":_) = do
    endpoint <- localEndpoint
    readConfig configPath >>= (\case
        Nothing     -> putStrLn "There was an error reading the config file."
        (Just conf) -> do
            new_conf <- publish endpoint conf
            saveConfig new_conf configPath)
dealWithArgs _ = printUsage

configPath :: FilePath
configPath = "ipfs-publisher.json"

printUsage :: IO ()
printUsage = putStrLn "Usage: ./ipfs-publisher [init <directory> | publish]"