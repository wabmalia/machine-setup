#!/usr/bin/env bash
# Generates one SSH key per identity defined in ssh/identities/*.sh, loads it
# into the macOS Keychain-backed ssh-agent, and tries to register the public
# key with the matching CLI (gh/glab) if authenticated — otherwise prints it
# for you to paste in manually.
#
# Not run automatically by bootstrap.sh — generating new identity keys is
# deliberate, run it yourself:
#   ./ssh/setup-ssh-keys.sh
#
# Safe to re-run: any identity whose key file already exists is left alone.

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

for identity_file in ./identities/*.sh; do
    [ -e "$identity_file" ] || continue

    # Each identity file sets IDENTITY_NAME, IDENTITY_KEY_FILE, IDENTITY_COMMENT,
    # and optionally IDENTITY_REGISTER_CMD. Unset first so one identity can't
    # leak into the next if a file forgets to set something.
    unset IDENTITY_NAME IDENTITY_KEY_FILE IDENTITY_COMMENT IDENTITY_REGISTER_CMD 2>/dev/null || true
    # shellcheck source=/dev/null
    source "$identity_file"

    echo "==> ${IDENTITY_NAME}"

    if [ -f "$IDENTITY_KEY_FILE" ]; then
        echo "    key already exists at $IDENTITY_KEY_FILE, skipping generation."
    else
        ssh-keygen -t ed25519 -C "$IDENTITY_COMMENT" -f "$IDENTITY_KEY_FILE"
    fi

    # Load into the Keychain-backed ssh-agent so the passphrase isn't asked every session.
    ssh-add --apple-use-keychain "$IDENTITY_KEY_FILE" 2>/dev/null || ssh-add "$IDENTITY_KEY_FILE" || true

    if [ -n "${IDENTITY_REGISTER_CMD:-}" ] && eval "$IDENTITY_REGISTER_CMD"; then
        echo "    registered."
    else
        echo "    could not auto-register (CLI not installed/authenticated?). Add this manually:"
        echo ""
        cat "${IDENTITY_KEY_FILE}.pub"
        echo ""
    fi
done

echo "==> Done."
