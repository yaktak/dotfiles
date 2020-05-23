#!/bin/bash

set -ux
cd `dirname $0`

CONFIG_DIR="$HOME/.config"
if [ ! -e $CONFIG_DIR ]; then
    mkdir $CONFIG_DIR
    echo ".config directory created"
fi

if [ ! -e "$CONFIG_DIR/nvim" ]; then
    mkdir "$CONFIG_DIR/nvim"
    echo ".config/nvim directory created"
fi

DOT_FILES="$HOME/dotfiles"
cd $DOT_FILES

shopt -s dotglob
for f in *; do
    [[ "$f" == "init.vim" ]] && ln -s "$DOT_FILES/$f" "$CONFIG_DIR/nvim/init.vim" && continue
    [[ "$f" =~ ^\..+$ ]] || continue
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    ln -s "$DOT_FILES/$f" "$HOME/$f"
done

if [ -n "$(command -v yum)" ]; then
    sudo yum install -y epel-release
    sudo yum install -y git wget vim automake libevent-devel ncurses-devel
elif [ -n "$(command -v apt)" ]; then
    sudo apt update >/dev/null
    sudo apt install -y git wget vim automake libevent-dev libncurses5-dev
fi
