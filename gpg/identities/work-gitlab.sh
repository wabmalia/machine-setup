# Work GitLab (gitlab.com) commit-signing identity. Read/sourced by
# gpg/setup-gpg-keys.sh.
#
# Safe to delete this whole file if you leave the company — along with
# ~/.gitconfig-gitlab.com (regenerated, not chezmoi-managed) and the GPG key
# itself (`gpg --delete-secret-and-public-key <fingerprint>`). The generic
# includeIf routing in home/dot_gitconfig.tmpl stays — it just won't match
# anything once ~/.gitconfig-gitlab.com no longer exists. See README.md for
# the full checklist.
#
# The email comes from your GitLab account (its commit email) at run time,
# via glab. GitLab only marks a commit Verified when the key's email, the
# commit's email, and a verified address on your account all match, so this
# keeps them in sync without ever writing the work email into this repo.
# Needs `glab auth login` first. It deliberately does NOT fall back to the
# global (personal) email: that would produce a key whose commits always show
# Unverified.
GIT_NAME="$(git config --global user.name)"
GIT_EMAIL="$(glab api user 2>/dev/null | jq -r '.commit_email // .email // empty' || true)"
if [ -z "$GIT_EMAIL" ]; then
    echo "    can't read your GitLab commit email. Run \`glab auth login --hostname gitlab.com\` first." >&2
    exit 1
fi

IDENTITY_NAME="GitLab (Work) commit signing"
IDENTITY_EMAIL="$GIT_EMAIL"
IDENTITY_UID="${GIT_NAME} <${GIT_EMAIL}>"
IDENTITY_GITCONFIG_PATH="$HOME/.gitconfig-gitlab.com"
IDENTITY_REGISTER_CMD='glab auth status >/dev/null 2>&1 && gpg --armor --export "$IDENTITY_EMAIL" | glab gpg-key add -'
