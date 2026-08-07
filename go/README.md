# Go Development Environment

## Directory layout

Toolchains, GOPATH, and installed commands use the same paths on Linux and
macOS:

| Purpose | Variable | Path |
| --- | --- | --- |
| Versioned toolchain | `GOROOT` | `${XDG_DATA_HOME:-$HOME/.local/share}/go<VERSION>` |
| GOPATH compatibility root | `GOPATH` | `${XDG_DATA_HOME:-$HOME/.local/share}/go` |
| Installed commands | `GOBIN` | `$HOME/.local/bin` |

Configuration and cache paths differ by platform:

| Purpose | Variable | Linux | macOS |
| --- | --- | --- | --- |
| Module cache | `GOMODCACHE` | `${XDG_CACHE_HOME:-$HOME/.cache}/go-mod` | `$HOME/Library/Caches/go-mod` |
| Build cache | `GOCACHE` | `${XDG_CACHE_HOME:-$HOME/.cache}/go-build` | `$HOME/Library/Caches/go-build` |
| Go environment file | `GOENV` | `${XDG_CONFIG_HOME:-$HOME/.config}/go/env` | `$HOME/Library/Application Support/go/env` |
| `gopls` cache | `GOPLSCACHE` | `${XDG_CACHE_HOME:-$HOME/.cache}/gopls` | `$HOME/Library/Caches/gopls` |

`shell/go.sh` sets `GOPATH`, `GOBIN`, and `GOMODCACHE`. Go and `gopls`
determine the remaining paths.

## Install a toolchain

The installer supports stable releases listed in `SHA256SUMS` for Linux
(amd64 and arm64) and macOS (arm64). It requires `curl`, `tar`, `awk`, and
either `sha256sum` or `shasum`.

From the `go` directory:

```sh
./toolchain.sh install 1.26.5
```

The script downloads and verifies the
[official Go archive](https://go.dev/dl/), then installs it under the user data
directory without activating it or overwriting an existing version.

To add a version, add verified checksums for each supported archive to
`SHA256SUMS` using the `<digest>  <filename>` format.

## Activate or switch versions

Activate or switch to an installed version:

```sh
./toolchain.sh activate 1.26.5
hash -r
```

This updates the `go` and `gofmt` symlinks in `$HOME/.local/bin`. The
`hash -r` command makes the current shell resolve the newly activated commands.

## Install gopls

Install the latest [`gopls`](https://go.dev/gopls/) release with the active
toolchain:

```sh
go install golang.org/x/tools/gopls@latest
```

See the [Vim configuration guide](../vim/README.md) for editor integration.

## Verify the environment

Inspect the active commands and effective Go directories:

```sh
command -v go
go version
go env GOROOT GOPATH GOBIN GOMODCACHE GOCACHE GOENV
command -v gopls
gopls version
```

## Uninstall a toolchain

Switch to another installed version before uninstalling:

```sh
./toolchain.sh activate 1.26.5
./toolchain.sh uninstall 1.25.6
```

Only the selected toolchain directory is removed. GOPATH, caches, and commands
installed with `go install` are preserved.
