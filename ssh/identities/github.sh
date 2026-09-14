# Personal GitHub identity. Read/sourced by ssh/setup-ssh-keys.sh.
COMPUTER_NAME="$(scutil --get ComputerName 2>/dev/null || hostname)"

IDENTITY_NAME="GitHub (personal)"
IDENTITY_KEY_FILE="$HOME/.ssh/id_ed25519_github"
IDENTITY_COMMENT="$(whoami)@${COMPUTER_NAME}-github"
IDENTITY_REGISTER_CMD='gh auth status >/dev/null 2>&1 && gh ssh-key add "${IDENTITY_KEY_FILE}.pub" --title "${COMPUTER_NAME} ($(date +%Y-%m-%d))"'
