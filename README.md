# Dotfiles

Personal dotfiles managed with Git, following the Atlassian bare-repo workflow.

## What is currently tracked

- `.bashrc`
- Neovim config in `.config/nvim/` (LazyVim-based setup, custom `lua/config/*`, and `lua/plugins/colorscheme.lua`)

## Setup on a new machine

1. Clone this repo as a bare repo:
   ```bash
   git clone --bare https://github.com/lionlion37/dotfiles "$HOME/.cfg"
   ```
2. Create a helper command:
   ```bash
   alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
   ```
3. Avoid showing untracked files from `$HOME`:
   ```bash
   config config --local status.showUntrackedFiles no
   ```
4. Checkout dotfiles into `$HOME`:
   ```bash
   config checkout
   ```
5. If checkout fails because files already exist, back them up and retry:
   ```bash
   mkdir -p "$HOME/.dotfiles-backup"
   config checkout 2>&1 | grep -E '^\s+\.' | awk '{print $1}' | xargs -I{} mv {} "$HOME/.dotfiles-backup/{}"
   config checkout
   ```

## Daily usage

- Show changes: `config status`
- Review diffs: `config diff`
- Track a file: `config add <path>`
- Commit: `config commit -m "message"`
- Push: `config push`

Optional: add the alias permanently in your shell config.
