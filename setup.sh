#!/usr/bin/env bash
# Symlinks dotfiles from this repo into $HOME, backing up anything already
# there that isn't already the correct symlink.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

files=(
  .bashrc
  .bash_aliases
  .tmux.conf
)

for file in "${files[@]}"; do
  src="$repo_dir/$file"
  dest="$HOME/$file"

  if [ ! -e "$src" ]; then
    echo "skip $file: not found in repo" >&2
    continue
  fi

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok   $file: already linked"
    continue
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    echo "back $file: existing file moved to $backup"
  fi

  ln -s "$src" "$dest"
  echo "link $file: $dest -> $src"
done
