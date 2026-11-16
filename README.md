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

- No credentials needed: this tap and the source repo
  (`btrachey/tail-tones-scala`) are public. (If you cloned them back when
  they were private, `rm -rf "$(brew --cache)/tail-tones--git"` once to
  refresh the cached clone.)
- The formula builds from source with `sbt nativeLink` (Scala Native), so it
  pulls `sbt`, `openjdk`, and `llvm` as build deps. The first build downloads
  the Scala toolchain into a throwaway cache and takes a few minutes;
  reinstalls reuse Homebrew's download cache when the clone is still warm.

## Updating

The stable formula is pinned to the `v0.1.0` tag (+ full `revision:`).
To run the repo's `main` tip instead (brew 7 has no `brew switch`, and
`reinstall` has no `--HEAD` option):

```sh
brew unlink tail-tones && brew install --HEAD tail-tones   # switch to main
brew uninstall tail-tones && brew install tail-tones       # switch back
```

To ship a new version: tag upstream (`vX.Y.Z`), then update `tag:`/`revision:`
in the formula. `livecheck` reads the upstream git tags, so
`brew livecheck tail-tones` reports when they drift.
