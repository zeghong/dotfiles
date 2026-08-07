#!/bin/sh

# Manage versioned Go toolchains in the user data directory.

set -f

die()
{
    printf '%s\n' "go-toolchain: error: $*" >&2
    exit 1
}

warn()
{
    printf '%s\n' "go-toolchain: warning: $*" >&2
}

usage()
{
    cat >&2 <<'EOF'
Usage:
  toolchain.sh install VERSION
  toolchain.sh activate VERSION
  toolchain.sh uninstall VERSION
EOF
    exit 2
}

require_command()
{
    command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

validate_version()
{
    _version_value=$1

    case "$_version_value" in
        ""|.*|*.|*..*|*[!0-9.]*) return 1 ;;
    esac

    _version_ifs=$IFS
    IFS=.
    set -- $_version_value
    IFS=$_version_ifs

    [ "$#" -eq 3 ] || return 1

    for _version_part do
        case "$_version_part" in
            ""|*[!0-9]*) return 1 ;;
        esac
    done

    unset _version_value _version_ifs _version_part
    return 0
}

resolve_data_home()
{
    case "${XDG_DATA_HOME:-}" in
        /*) data_home=$XDG_DATA_HOME ;;
        "")
            case "${HOME:-}" in
                /*) data_home=$HOME/.local/share ;;
                *) die 'XDG_DATA_HOME or an absolute HOME is required' ;;
            esac
            ;;
        *) die 'XDG_DATA_HOME must be an absolute path' ;;
    esac
}

require_home()
{
    case "${HOME:-}" in
        /*) ;;
        *) die 'HOME must be an absolute path for this operation' ;;
    esac
}

detect_platform()
{
    require_command uname

    host_os=$(uname -s) || die 'cannot detect operating system'
    host_arch=$(uname -m) || die 'cannot detect architecture'

    case "$host_os-$host_arch" in
        Linux-x86_64|Linux-amd64)
            go_os=linux
            go_arch=amd64
            ;;
        Linux-aarch64|Linux-arm64)
            go_os=linux
            go_arch=arm64
            ;;
        Darwin-arm64)
            go_os=darwin
            go_arch=arm64
            ;;
        Darwin-*)
            die "unsupported macOS architecture: $host_arch"
            ;;
        *)
            die "unsupported platform: $host_os/$host_arch"
            ;;
    esac

    unset host_os host_arch
}

resolve_script_dir()
{
    case "$0" in
        /*) _script_path=$0 ;;
        *) _script_path=$PWD/$0 ;;
    esac

    require_command dirname
    script_dir=$(CDPATH= cd "$(dirname "$_script_path")" && pwd -P) ||
        die 'cannot determine script directory'
    unset _script_path
}

read_checksum()
{
    archive_name=$1
    manifest=$script_dir/SHA256SUMS

    [ -f "$manifest" ] || die "checksum manifest not found: $manifest"

    expected_sha256=$(awk -v wanted="$archive_name" '
        BEGIN { matches = 0; invalid = 0 }
        {
            if (NF != 2 || length($1) != 64 || $1 ~ /[^[:xdigit:]]/ ||
                    $0 != $1 "  " $2) {
                invalid = 1
                next
            }
            if ($2 == wanted) {
                matches++
                digest = tolower($1)
            }
        }
        END {
            if (invalid || matches != 1) {
                exit 1
            }
            print digest
        }
    ' "$manifest") || die "missing, duplicate, or invalid checksum entry: $archive_name"
}

cleanup_stage()
{
    if [ -n "${stage_dir:-}" ] && [ -d "$stage_dir" ]; then
        rm -rf -- "$stage_dir"
    fi
}

install_toolchain()
{
    version=$1

    require_command awk
    require_command curl
    require_command mkdir
    require_command mktemp
    require_command mv
    require_command rm
    require_command tar

    if command -v sha256sum >/dev/null 2>&1; then
        checksum_command=sha256sum
    elif command -v shasum >/dev/null 2>&1; then
        checksum_command=shasum
    else
        die 'required checksum command not found: sha256sum or shasum'
    fi

    resolve_data_home
    detect_platform
    resolve_script_dir

    archive_name=go$version.$go_os-$go_arch.tar.gz
    install_dir=$data_home/go$version
    read_checksum "$archive_name"

    if [ -e "$install_dir" ] || [ -L "$install_dir" ]; then
        die "installation directory already exists: $install_dir"
    fi

    mkdir -p "$data_home" || die "cannot create data directory: $data_home"
    stage_dir=$(mktemp -d "$data_home/.go$version.XXXXXX") ||
        die "cannot create staging directory in: $data_home"
    trap cleanup_stage 0
    trap 'exit 1' 1 2 15

    archive_path=$stage_dir/$archive_name
    extract_dir=$stage_dir/extract
    mkdir "$extract_dir" || die 'cannot create extraction directory'

    printf '%s\n' "Downloading https://go.dev/dl/$archive_name"
    curl --fail --location --show-error \
        --output "$archive_path" "https://go.dev/dl/$archive_name" ||
        die 'download failed'

    if [ "$checksum_command" = sha256sum ]; then
        actual_sha256=$(sha256sum "$archive_path" | awk '{print tolower($1)}') ||
            die 'cannot compute archive checksum'
    else
        actual_sha256=$(shasum -a 256 "$archive_path" | awk '{print tolower($1)}') ||
            die 'cannot compute archive checksum'
    fi

    [ "$actual_sha256" = "$expected_sha256" ] || die 'archive checksum mismatch'

    tar -xzf "$archive_path" -C "$extract_dir" || die 'cannot extract archive'

    [ -d "$extract_dir/go" ] && [ ! -L "$extract_dir/go" ] ||
        die 'archive does not contain a real go directory'
    [ -x "$extract_dir/go/bin/go" ] || die 'archive does not contain an executable go command'
    [ -x "$extract_dir/go/bin/gofmt" ] || die 'archive does not contain an executable gofmt command'

    version_output=$(GOTOOLCHAIN=local "$extract_dir/go/bin/go" version) ||
        die 'new Go command failed its version check'
    case "$version_output" in
        "go version go$version $go_os/$go_arch") ;;
        *) die "unexpected Go version output: $version_output" ;;
    esac

    if [ -e "$install_dir" ] || [ -L "$install_dir" ]; then
        die "installation directory appeared during install: $install_dir"
    fi

    mv "$extract_dir/go" "$install_dir" || die "cannot install toolchain at: $install_dir"
    printf '%s\n' "Installed Go $version at $install_dir"
    printf '%s\n' "Run: $0 activate $version"
}

activate_toolchain()
{
    version=$1

    require_command ln
    require_command mkdir
    require_command readlink

    require_home
    resolve_data_home

    install_dir=$data_home/go$version
    bin_dir=$HOME/.local/bin

    [ -d "$install_dir" ] && [ ! -L "$install_dir" ] ||
        die "toolchain is not a real directory: $install_dir"
    [ -x "$install_dir/bin/go" ] || die "Go command not found in: $install_dir"
    [ -x "$install_dir/bin/gofmt" ] || die "gofmt command not found in: $install_dir"

    for command_name in go gofmt; do
        link_path=$bin_dir/$command_name
        if [ -e "$link_path" ] && [ ! -L "$link_path" ]; then
            die "refusing to replace a non-symlink: $link_path"
        fi
    done

    mkdir -p "$bin_dir" || die "cannot create binary directory: $bin_dir"
    ln -sfn "$install_dir/bin/go" "$bin_dir/go" || die 'cannot activate go'
    ln -sfn "$install_dir/bin/gofmt" "$bin_dir/gofmt" || die 'cannot activate gofmt'

    [ "$(readlink "$bin_dir/go")" = "$install_dir/bin/go" ] || die 'go symlink verification failed'
    [ "$(readlink "$bin_dir/gofmt")" = "$install_dir/bin/gofmt" ] || die 'gofmt symlink verification failed'

    GOTOOLCHAIN=local "$install_dir/bin/go" version ||
        die 'activated Go command failed its version check'

    case ":${PATH:-}:" in
        *":$bin_dir:"*) ;;
        *) warn "$bin_dir is not in PATH; load the repository shell configuration" ;;
    esac

    printf '%s\n' "Activated Go $version"
    printf '%s\n' "Run 'hash -r' in the current shell before invoking go"
}

uninstall_toolchain()
{
    version=$1

    require_command readlink
    require_command rm

    require_home
    resolve_data_home

    install_dir=$data_home/go$version
    bin_dir=$HOME/.local/bin

    [ -d "$install_dir" ] && [ ! -L "$install_dir" ] ||
        die "toolchain is not a real directory: $install_dir"

    for command_name in go gofmt; do
        link_path=$bin_dir/$command_name
        if [ -L "$link_path" ] &&
                [ "$(readlink "$link_path")" = "$install_dir/bin/$command_name" ]; then
            die "toolchain is active through: $link_path"
        fi
    done

    rm -rf -- "$install_dir" || die "cannot remove toolchain: $install_dir"
    printf '%s\n' "Uninstalled Go $version from $install_dir"
}

[ "$#" -eq 2 ] || usage

subcommand=$1
version=$2
validate_version "$version" || die "invalid stable Go version: $version"

case "$subcommand" in
    install) install_toolchain "$version" ;;
    activate) activate_toolchain "$version" ;;
    uninstall) uninstall_toolchain "$version" ;;
    *) usage ;;
esac
