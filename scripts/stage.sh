#!/usr/bin/env bash
# Stage the files that ship in the mod into dist/, ready for `tcli build`.
# README.md and icon.png are added by tcli itself (see thunderstore.toml).
#
# If this repo is symlinked into the Balatro Mods folder, delete dist/ before
# starting the game: it holds a second copy of the mod and Steamodded would
# find both.
set -euo pipefail
cd "$(dirname "$0")/.."

rm -rf dist
mkdir dist
cp -R MortemChipX.json MortemChipX.lua LICENSE CHANGELOG.md src assets localization dist/
find dist -name .DS_Store -delete
