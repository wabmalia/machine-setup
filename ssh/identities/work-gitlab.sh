# Work GitLab (gitlab.com) identity. Read/sourced by ssh/setup-ssh-keys.sh.
#
# Safe to delete this whole file if you leave the company — along with
# home/private_dot_ssh/config.d/work.conf and the generated key under
# ~/.ssh — nothing else depends on it. See README.md for the full checklist.
COMPUTER_NAME="$(scutil --get ComputerName 2>/dev/null || hostname)"

IDENTITY_NAME="GitLab (Work)"
IDENTITY_KEY_FILE="$HOME/.ssh/id_ed25519_gitlab_work"
IDENTITY_COMMENT="$(whoami)@${COMPUTER_NAME}-work"
IDENTITY_REGISTER_CMD='glab auth status >/dev/null 2>&1 && glab ssh-key add "${IDENTITY_KEY_FILE}.pub" --title "${COMPUTER_NAME} ($(date +%Y-%m-%d))"'
