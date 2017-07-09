#!/bin/bash

DOT_FILES="$HOME/dotfiles"
cd $DOT_FILES

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -s "$DOT_FILES/$f" "$HOME/$f"
done
