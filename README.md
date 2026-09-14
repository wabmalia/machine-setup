# machine-setup

Personal macOS machine setup: clone this repo on a new machine and run one
script to get packages, dotfiles, and system defaults configured.

## Quick start

```sh
git clone <this-repo-url> ~/dev/machine-setup
cd ~/dev/machine-setup
./bootstrap.sh
```

Re-running `./bootstrap.sh` any time is safe — every step is idempotent, so
it's also how you sync a machine after pulling new changes.

## How it's organized

| Path              | Purpose                                                             |
|-------------------|----------------------------------------------------------------------|
| `bootstrap.sh`    | Entry point: installs Homebrew, runs the other three pieces below.   |
| `Brewfile`        | CLI tools, GUI apps (casks), and Mac App Store apps via `brew bundle`. |
| `home/`           | [chezmoi](https://www.chezmoi.io) source state — dotfiles.          |
| `macos/defaults.sh` | macOS system preferences (`defaults write` settings).              |
| `ssh/`            | SSH key generation (not run by `bootstrap.sh` — see below).          |
| `gpg/`            | GPG signing-key generation (not run by `bootstrap.sh` — see below).  |

`.chezmoiroot` points chezmoi at `home/`, so this single repo is both the
machine scaffold *and* the chezmoi source directory — no second repo needed.

## Customizing

- **Add/remove a package**: edit `Brewfile`, then run `brew bundle --file=./Brewfile`
  (or just re-run `bootstrap.sh`).
- **Add/edit a dotfile**: edit files under `home/` (chezmoi naming: `dot_foo` →
  `~/.foo`), then run `chezmoi apply`. See the
  [chezmoi docs](https://www.chezmoi.io/user-guide/manage-different-types-of-file/)
  for templating, machine-specific files, etc.
- **Change a macOS default**: edit `macos/defaults.sh`. Each block is
  independent — delete a block you don't want rather than commenting it out.
- **Personal info** (git name/email) is *not* hardcoded in the repo — chezmoi
  prompts for it once on first `chezmoi init` and caches the answer locally
  in `~/.config/chezmoi/chezmoi.toml`, so this repo is safe to make public.

## SSH keys

Private keys are never stored in this repo — they're generated straight into
`~/.ssh` on each machine and stay there.

```sh
./ssh/setup-ssh-keys.sh
```

This generates one ed25519 key per identity defined under `ssh/identities/`
(currently `github.sh` and `work-gitlab.sh`), loads each into the macOS
Keychain-backed `ssh-agent`, and tries to register the public key
automatically via `gh ssh-key add` / `glab ssh-key add` if you're already
authenticated with that CLI (`gh auth login` / `glab auth login`) — otherwise
it prints the public key for you to paste in manually. Re-running the script
is safe; it skips any identity whose key file already exists.

`home/private_dot_ssh/config` (→ `~/.ssh/config`) only contains host routing
(`IdentityFile` paths), never key material, so it's safe to commit.

## GPG (commit signing)

```sh
./gpg/setup-gpg-keys.sh
```

Same idea as SSH: generates one ed25519 signing key per identity under
`gpg/identities/` (currently just `work-gitlab.sh`), and tries to
register the public key via `glab gpg-key add` / `gh gpg-key add` if
authenticated, otherwise prints it for you to paste in manually.

Unlike SSH, the private key itself lives in GPG's own keyring
(`~/.gnupg`), not a predictable file path — so what the script generates
per-machine is a small git config file (e.g. `~/.gitconfig-gitlab.com`)
pointing `user.signingkey` at that machine's key fingerprint, with
`commit.gpgsign`/`tag.gpgsign` turned on. That file is **not** managed by
chezmoi (the fingerprint is different on every machine), only referenced —
`home/dot_gitconfig.tmpl` includes it conditionally, based on the repo's
remote URL (`includeIf "hasconfig:remote.*.url:...gitlab.com..."`), so
signing only kicks in for gitlab.com repos and every other repo is
unaffected. `home/private_dot_gnupg/gpg-agent.conf` wires up `pinentry-mac`
so the passphrase prompt is a native macOS dialog.

## Company/client-specific config

Some config only applies while you're at a given company — kept generic as
"work" rather than naming the employer, so this stays reusable across jobs.
Rather than mixing that into the shared defaults, it's isolated to a small
set of files so it can be added or removed as one unit:

| File                                          | Purpose                     |
|------------------------------------------------|------------------------------|
| `home/dot_zshrc.d/work.zsh`                     | work-specific aliases/exports |
| `home/private_dot_ssh/config.d/work.conf`       | work GitLab SSH host routing  |
| `ssh/identities/work-gitlab.sh`                 | work GitLab SSH key definition |
| `gpg/identities/work-gitlab.sh`                 | work GitLab GPG key definition |

`gh`/`glab`/`gnupg`/`pinentry-mac` themselves stay in the shared `Brewfile`
since they're generic tools, not company-specific — only the identity/config
wiring above is. Likewise, the `includeIf` blocks in `home/dot_gitconfig.tmpl`
and the `Include config.d/*.conf` line in `home/private_dot_ssh/config` are
routing by **host** (gitlab.com), not by company — they stay even after
changing jobs, they just won't match anything once the files below are gone.

**If you ever change jobs**: delete the four files above, then:
- `rm ~/.ssh/id_ed25519_gitlab_work* ~/.gitconfig-gitlab.com`
- remove the GPG key: `gpg --delete-secret-and-public-key <fingerprint>`
  (find it with `gpg --list-secret-keys`)
- run `chezmoi apply` to drop the generated SSH config block

Then add the new job's config following the same pattern: rename/recreate
`home/dot_zshrc.d/work.zsh`, `ssh/identities/work-gitlab.sh`, and
`gpg/identities/work-gitlab.sh` (or use a different name entirely if you
want to keep more than one "work" context around, e.g. for a side client).

## Explicitly out of scope (for now)

- **Other secrets** (API tokens, etc.): not handled here on purpose — these
  shouldn't live in a plain git repo. If/when needed, look at chezmoi's
  built-in integrations with a password manager (1Password, Bitwarden, etc.)
  rather than storing secrets as files.
- **Linux support**: this scaffold currently assumes macOS + Homebrew.
