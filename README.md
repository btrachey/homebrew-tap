# btrachey/homebrew-tap

Homebrew tap for Brian's personal tools.

## Install

```sh
brew tap btrachey/tap
brew install tail-tones
```

`tail-tones` pipes log lines through while sonifying their health
(<https://github.com/btrachey/tail-tones-scala>):

```sh
yourapp 2>&1 | tail-tones
```

## Requirements

- The source repo (`btrachey/tail-tones-scala`) is **private**; cloning it
  needs GitHub credentials. If the [GitHub CLI](https://cli.github.com/) is
  logged in (`gh auth login`), Homebrew uses its token automatically.
- The formula builds from source with `sbt nativeLink` (Scala Native), so it
  pulls `sbt`, `openjdk`, and `llvm` as build deps. The first build downloads
  the Scala toolchain into a throwaway cache and takes a few minutes;
  reinstalls reuse Homebrew's download cache when the clone is still warm.

## Updating

The formula tracks `main`. `brew reinstall tail-tones` rebuilds against the
current tip. When the source repo grows real version tags, pin the formula
`url` to a `tag:` + `revision:` and bump `version` accordingly.
