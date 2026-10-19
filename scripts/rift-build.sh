#!/bin/zsh
# Build rift from source with local patches and install it over the brew binary.
#
# Why: rift 0.5.x drops re-hide requests for windows that escape their off-screen
# position (see rift/patches/). Until that's upstream, we run a patched build.
# brew upgrade rift replaces the binary, so re-run this after upgrading.
#
# Usage: rift-build.sh [tag]     (default: the brew-installed version)
set -euo pipefail

SRC="$HOME/src/rift"
PATCHES="$HOME/.dotfiles/rift/patches"
TAG="${1:-v$(brew list --versions rift | awk '{print $2}')}"
CELLAR="$(brew --prefix)/Cellar/rift/${TAG#v}/bin/rift"

if [[ ! -d "$SRC/.git" ]]; then
	git clone https://github.com/acsandmann/rift.git "$SRC"
fi
git -C "$SRC" fetch --tags --quiet
git -C "$SRC" checkout --quiet --force "$TAG"
git -C "$SRC" clean -fdq -e target

for p in "$PATCHES"/*.patch; do
	echo "applying $(basename "$p")"
	git -C "$SRC" apply --3way "$p"
done

(cd "$SRC" && cargo build --release --bin rift)

BIN="$SRC/target/release/rift"
# "rift-local" is a self-signed cert in the login keychain (see rift/patches/README);
# a stable identity keeps the Accessibility grant valid across rebuilds.
codesign --force --sign rift-local --identifier git.acsandmann.rift "$BIN"

[[ -f "$CELLAR" ]] || { echo "brew binary not found at $CELLAR (brew install rift first)"; exit 1; }
[[ -f "$CELLAR.upstream" ]] || cp "$CELLAR" "$CELLAR.upstream"
install -m 555 "$BIN" "$CELLAR"
echo "installed $("$CELLAR" --version) -> $CELLAR"

if launchctl print "gui/$(id -u)/git.acsandmann.rift" >/dev/null 2>&1; then
	launchctl kickstart -k "gui/$(id -u)/git.acsandmann.rift"
	echo "rift restarted"
fi
echo "NOTE: the binary's ad-hoc signature changed; re-grant rift in System Settings > Privacy & Security > Accessibility if hotkeys are dead."
