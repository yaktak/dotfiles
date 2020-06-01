#!/bin/bash

set -ux
cd `dirname $0`

DOT_FILES="$HOME/dotfiles"
cd $DOT_FILES

shopt -s dotglob
for f in *; do
    [[ "$f" =~ ^\..+$ ]] || continue
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ".gitignore" ]] && continue
    ln -s "$DOT_FILES/$f" "$HOME/$f"
done

if [ -n "$(command -v yum)" ]; then
    sudo yum install -y epel-release
    sudo yum install -y git wget vim automake libevent-devel ncurses-devel
elif [ -n "$(command -v apt)" ]; then
    sudo apt update >/dev/null
    sudo apt install -y git wget vim automake libevent-dev libncurses5-dev
fi
