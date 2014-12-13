import Options.Applicative
import System.Hourglass

---

data Flags = Flags { echo  :: Maybe String
                   , num   :: Maybe Int
                   , side  :: Side
                   , time  :: Bool
                   , maybe :: Maybe (Maybe Int)
                   , extra :: [String] } deriving (Eq,Show)

data Side = Soup | Salad deriving (Eq,Show)

-- Can parse anything with a Read instance.
numP :: Parser Int
numP = option auto (short 'n' <> metavar "NUM" <> help "A number")

-- Haskell Data too! `-m "Just 5"` works.
maybeP :: Parser (Maybe Int)
maybeP = option auto (short 'm' <> metavar "Just NUM | Nothing")

flags :: Parser Flags
flags = Flags
        -- Wants a string value: `--echo blah` or `--echo=blah`
        -- Short: `-e blah` or `-eblah`
        <$> optional (strOption (long "echo"
                                 <> short 'e'
                                 <> metavar "PHRASE" 
                                 <> help "Echo smth"))
        <*> optional numP
        -- A flag. Doesn't take arguments. Either there or not there.
        -- Defaults to the first arg given to `flag` if nothing
        -- is given on the command line.
        <*> flag Soup Salad (long "side"
                             <> short 's'
                             <> help "The side dish you want")
        -- A Boolean flag.
        <*> switch (long "time" <> help "Tell the time")
        -- An option that takes Haskell data as an arg.
        <*> optional maybeP
        -- Non-option arguments. File lists, package names, etc.
        -- Anything after a `--` will be considered an argument.
        <*> many (argument str $ metavar "EXTRAS...")

-- Handle all the options.
work :: Flags -> IO ()
work (Flags _ _ _ True _ _) = dateCurrent >>= print
work fs = print fs

main :: IO ()
main = execParser opts >>= work
  where opts = info (helper <*> flags)
               (fullDesc <> header "opts - Testing the library")
