# NewStore GitLab (gitlab.com) commit-signing identity. Read/sourced by
# gpg/setup-gpg-keys.sh.
#
# Safe to delete this whole file if you leave the company — along with
# ~/.gitconfig-gitlab.com (regenerated, not chezmoi-managed) and the GPG key
# itself (`gpg --delete-secret-and-public-key <fingerprint>`). The generic
# includeIf routing in home/dot_gitconfig.tmpl stays — it just won't match
# anything once ~/.gitconfig-gitlab.com no longer exists. See README.md for
# the full checklist.
#
# Uses the same name/email already configured globally via chezmoi. If you
# want NewStore commits signed under a different email, hardcode it below —
# this file never leaves your machine's copy of the repo... but remember it
# WILL be committed if you push this repo, so only do that if you're fine
# with that email being public.
GIT_NAME="$(git config --global user.name)"
GIT_EMAIL="$(git config --global user.email)"

IDENTITY_NAME="GitLab (NewStore) commit signing"
IDENTITY_EMAIL="$GIT_EMAIL"
IDENTITY_UID="${GIT_NAME} <${GIT_EMAIL}>"
IDENTITY_GITCONFIG_PATH="$HOME/.gitconfig-gitlab.com"
IDENTITY_REGISTER_CMD='glab auth status >/dev/null 2>&1 && gpg --armor --export "$IDENTITY_EMAIL" | glab gpg-key add -'
