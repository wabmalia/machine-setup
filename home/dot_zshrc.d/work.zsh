# Work-specific zsh config — auto-sourced by dot_zshrc from ~/.zshrc.d/.
# Keep anything company-specific here, never in the shared dot_zshrc defaults.

# --- Aliases ---
# alias work-deploy="..."

# --- Exports ---
# export WORK_TENANT="..."

# --- AWS SSO ---
# Loads aws-sso-profile/aws-sso-clear and completions. Sourced at startup
# instead of `aws-sso setup completions --install`, which appends to ~/.zshrc
# (chezmoi would wipe it). Its `complete` call is bash-style, so it needs
# bashcompinit, which must run after compinit (done in dot_zshrc).
if command -v aws-sso >/dev/null; then
    autoload -Uz bashcompinit && bashcompinit
    source <(aws-sso setup completions --source --shell zsh)
fi

# --- Functions ---
# Pick an AWS SSO profile with fzf and switch to it.
aws-sso-select() {
    local selection
    selection=$(aws-sso | awk 'NR>3 && !/^=/{print $7}' | fzf)
    if [[ -n "$selection" ]]; then
        echo "Selected: $selection"
        aws-sso-profile "$selection"
    else
        echo "No selection made."
        return 1
    fi
}
