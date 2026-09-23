#!/usr/bin/env bash
# Entry point for setting up a new macOS machine from this repo.
#
# Usage:
#   git clone <your-repo-url> ~/dev/machine-setup
#   cd ~/dev/machine-setup && ./bootstrap.sh
#
# Safe to re-run any time (e.g. after adding a package to the Brewfile or
# editing a dotfile) — every step here is idempotent.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# --- 1. Homebrew ---
if ! command -v brew >/dev/null 2>&1; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- 2. Packages (CLI tools + casks) ---
echo "==> Installing packages from Brewfile..."
brew bundle --file=./Brewfile

# Work-specific packages, if present (see Brewfile.work).
if [ -f ./Brewfile.work ]; then
    echo "==> Installing packages from Brewfile.work..."
    brew bundle --file=./Brewfile.work
fi

# --- 3. Dotfiles via chezmoi ---
# .chezmoiroot in this repo points chezmoi at ./home, so this repo doubles as
# the chezmoi source directory — no separate dotfiles repo needed. This lays
# down the generic ~/.claude/settings.json before the two steps below touch it.
echo "==> Applying dotfiles with chezmoi..."
chezmoi init --apply --source="$(pwd)"

# Work-specific Claude settings, if present (see claude-settings.work.json).
# Deep-merges enabledPlugins/extraKnownMarketplaces on top of the generic
# settings.json chezmoi just wrote, same idea as Brewfile.work.
if [ -f ./claude-settings.work.json ]; then
    echo "==> Merging work-specific Claude settings..."
    jq -s '.[0] * .[1]' "$HOME/.claude/settings.json" ./claude-settings.work.json \
        > "$HOME/.claude/settings.json.tmp"
    mv "$HOME/.claude/settings.json.tmp" "$HOME/.claude/settings.json"
fi

# --- 4. rtk (token-optimized CLI proxy for Claude Code) ---
# Wires up the global hook + RTK.md so `rtk`-known commands get rewritten
# transparently inside Claude Code. Runs after claude-code is installed and
# after settings.json is in its final form above, since this patches that
# same file to add its own hook entry (idempotent — safe to re-run).
# --auto-patch skips the interactive confirmation prompt.
if command -v rtk >/dev/null 2>&1; then
    echo "==> Initializing rtk for Claude Code..."
    rtk init -g --auto-patch
fi

# --- 5. macOS system defaults (optional, comment out if unwanted) ---
echo "==> Applying macOS defaults..."
./macos/defaults.sh

echo "==> Done. Restart your shell (or open a new terminal tab) to pick up changes."
