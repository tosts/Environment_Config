#!/bin/bash

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

if [ ! -f ~/.gitconfig ]; then
    cp gitconfig ~/.gitconfig
fi

for file in *rc; do
    if [ ! -f ~/\.$file ]; then
        ln -s Environment_Config/$file ../\.$file
    fi
done
