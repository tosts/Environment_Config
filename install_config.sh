#!/bin/bash

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

for file in *rc; do
    ln -fs Environment_Config/$file ../\.$file
done
