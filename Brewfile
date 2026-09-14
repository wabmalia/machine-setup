# Package manifest for `brew bundle`.
# Add/remove lines here to customize what gets installed on a new machine.
# Re-run `brew bundle --file=./Brewfile` any time to sync a machine to this file.

# --- Taps ---
# tap "someorg/sometap"

# --- CLI tools ---
brew "chezmoi"      # dotfile manager, required by bootstrap.sh
brew "git"
brew "gh"           # GitHub CLI, used by ssh/identities/github.sh to register keys
brew "glab"         # GitLab CLI, used by ssh/identities/work-gitlab.sh to register keys
                    # (generic package — the work-specific bits live under ssh/, not here)
brew "gnupg"        # GPG, used by gpg/setup-gpg-keys.sh for commit signing
brew "pinentry-mac" # native macOS passphrase prompt for gpg-agent
brew "zsh"
brew "fzf"
brew "ripgrep"
brew "fd"
brew "bat"
brew "eza"
brew "jq"
brew "tmux"
brew "neovim"
brew "htop"
brew "mise"         # runtime version manager (node, python, ruby, etc.)

# --- Zsh completion/autosuggestion plugins (sourced directly in dot_zshrc, no framework) ---
brew "zsh-completions"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# --- GUI apps (casks) ---
cask "visual-studio-code"
cask "ghostty"
cask "brave-browser"
cask "rectangle"     # window management
cask "1password"
cask "1password-cli"
cask "claude-code"

# --- Mac App Store apps (requires `mas` + being signed in to the App Store) ---
# brew "mas"
# mas "Xcode", id: 497799835
