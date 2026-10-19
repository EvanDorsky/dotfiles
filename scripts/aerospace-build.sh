#!/bin/zsh
# Build AeroSpace from ~/src/AeroSpace (BSP branch, upstream PR #2135) and install
# it to /Applications, replacing whatever is there. Upstream AeroSpace has no BSP
# layout, so this local build is what runs. Re-run after pulling the branch.
#
# Signs with "rift-local", a self-signed cert in the login keychain, so macOS keeps
# the Accessibility grant across rebuilds (ad-hoc signatures change every build).
set -euo pipefail

SRC="$HOME/src/AeroSpace"
IDENTITY="rift-local"
VERSION="$(git -C "$SRC" describe --tags --always 2>/dev/null || echo local)-bsp"
export PATH="/opt/homebrew/bin:$PATH"

cd "$SRC"
/opt/homebrew/bin/bash ./generate.sh --build-version "$VERSION" --codesign-identity "$IDENTITY" --generate-git-hash
rm -rf .xcode-build .release && mkdir -p .release
xcodebuild -scheme AeroSpace -destination "generic/platform=macOS" -configuration Release \
	-derivedDataPath .xcode-build build > .release/xcodebuild.log 2>&1 \
	|| { grep -E "error:" .release/xcodebuild.log | head; exit 1; }
swift build -c release --arch arm64 --product aerospace
git checkout -- Sources/Common/gitHashGenerated.swift Sources/Common/versionGenerated.swift Sources/Cli/subcommandDescriptionsGenerated.swift 2>/dev/null || true

cp -R ".xcode-build/Build/Products/Release/AeroSpace.app" .release/
# LaunchServices indexes every copy with this bundle id; leave only /Applications.
rm -rf ".xcode-build/Build/Products/Release/AeroSpace.app"
cp "$(ls .build/*/release/aerospace | head -1)" .release/aerospace
codesign --force --sign "$IDENTITY" .release/aerospace
codesign --force --deep --sign "$IDENTITY" .release/AeroSpace.app

pkill -x AeroSpace 2>/dev/null || true
rm -rf /Applications/AeroSpace.app
cp -R .release/AeroSpace.app /Applications/AeroSpace.app
install -m 755 .release/aerospace /opt/homebrew/bin/aerospace
echo "installed $(/opt/homebrew/bin/aerospace --version 2>/dev/null | head -1)"
open -a AeroSpace
