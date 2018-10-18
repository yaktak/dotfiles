#!/bin/bash

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

if !(type "git" > /dev/null 2>&1); then
    echo "git not found"
fi

git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
