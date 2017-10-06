#!/bin/bash

# ディレクトリ作成
for d in tmp undo plugins colors dicts sessions
do mkdir $HOME/.vim/$d; done

# カラースキームを移動
find $HOME/.vim/plugins/dein/ -type d -name colors | xargs -I{} find {} -type f -name *.vim | xargs -I{} -t sh -c 'ln -s {} $HOME/.vim/colors/$(basename {})'
