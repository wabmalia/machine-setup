#!/usr/bin/env bash
# macOS system preferences, applied via `defaults write`.
# Safe to re-run. Comment out anything you don't want.
#
# Each block is independent — delete a block entirely if you disagree with it,
# rather than leaving a disabled setting around.

set -euo pipefail

echo "==> Applying macOS defaults..."

# --- Trackpad / input ---
defaults write NSGlobalDomain com.apple.mouse.scaling -1          # disable mouse acceleration
defaults write NSGlobalDomain com.apple.trackpad.scaling 1.5      # trackpad tracking speed
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true  # tap to click

# --- Keyboard ---
defaults write NSGlobalDomain KeyRepeat -int 2                    # fast key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false # hold key to repeat, not accent menu

# Option+Tab cycles windows of the current app (macOS "Move focus to next
# window", symbolic hotkey 27, default Cmd+`). Parameters are (char, keycode,
# modifiers): 65535 = no printable char, 48 = Tab, 524288 = Option.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 \
    "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array><key>type</key><string>standard</string></dict></dict>"
# Make keyboard-shortcut changes take effect without logging out.
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# --- Finder ---
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # list view by default

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 40

# --- Screenshots ---
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"

echo "==> Restarting affected apps..."
for app in Finder Dock; do
    killall "$app" >/dev/null 2>&1 || true
done

echo "==> Done. Some settings may require logout/restart to fully apply."
