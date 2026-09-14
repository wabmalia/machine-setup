# machine_scaffold

Personal macOS machine setup: clone this repo on a new machine and run one
script to get packages, dotfiles, and system defaults configured.

## Quick start

```sh
git clone <this-repo-url> ~/dev/machine_scaffold
cd ~/dev/machine_scaffold
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

## Explicitly out of scope (for now)

- **Secrets / SSH / GPG keys**: not handled here on purpose — these shouldn't
  live in a plain git repo. If/when needed, look at chezmoi's built-in
  integrations with a password manager (1Password, Bitwarden, etc.) rather
  than storing secrets as files.
- **Linux support**: this scaffold currently assumes macOS + Homebrew.
