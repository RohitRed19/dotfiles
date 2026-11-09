#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# Clean filter for .gitattributes: keeps work plugins in the live Claude settings
# out of commits. Git config is not versioned, so set it on every rebuild.
git -C "$DIR" config filter.claude-settings.clean "jq -f git-filters/claude-settings.jq"
git -C "$DIR" config filter.claude-settings.smudge cat
git -C "$DIR" config filter.claude-settings.required true
exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac
