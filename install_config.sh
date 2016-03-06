#!/bin/bash
set -x

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

for folder in \
  ~/.vim/vimswp \
  ~/.vim/vimundo \
; do
    if [ ! -d $folder ]; then
      mkdir -p $folder
    fi
done

if [ ! -f ~/.gitconfig ]; then
    cp gitconfig ~/.gitconfig
fi

for file in *rc bash_aliases; do
    if [ ! -f ~/\.$file ]; then
        ln -s Environment_Config/$file ../\.$file
    fi
done
