# ipfs-publisher

This is a small utility to make it easy to publish websites to [IPFS](https://ipfs.io) while keeping the history of all the versions. 
It is written in Haskell and it is both a library and a small command line interface for easy use. I plan on integrating the library with [Hakyll](https://jaspervdj.be/hakyll/) for easy deploy to IPFS.

## Build and run the command line utility

An IPFS node running a daemon is required. I would advise the [go implementation](https://github.com/ipfs/go-ipfs) for now.

The Haskell IPFS api is needed too. Currently only my version implements the required api calls, you can find it [here](https://github.com/basile-henry/hs-ipfs-api).

Getting the depencencies and building:

```zsh
cabal sandbox init
cabal sandbox add-source <path/to/hs-ipfs/api>
cabal configure
cabal install --only-dependencies
cabal build
```

The binary is placed in `dist/build/ipfs-publisher-cmd/ipfs-publisher-cmd`
To call it more easily (make sure `path/to/ipfs-publisher` is somewhere in `$PATH`):

```zsh
ln -s dist/build/ipfs-publisher-cmd/ipfs-publisher-cmd <path/to/ipfs-publisher>
```

## Usage

```zsh
ipfs-publisher [init <directory> | publish]
```

## License

MIT
Copyright (c) 2016 Basile Henry