#!/bin/bash

CONFIG_DIR="$HOME/.config"
if [ ! -e $CONFIG_DIR ]; then
    mkdir $CONFIG_DIR
    echo ".config directory created"
fi

DOT_FILES="$HOME/dotfiles"
cd $DOT_FILES

for f in .??*; do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == "init.vim" ]] && ln -s "$DOT_FILES/$f" "$CONFIG_DIR/init.vim" && continue

    ln -s "$DOT_FILES/$f" "$HOME/$f"
done
