#!/bin/bash

DOT_FILES=(.vimrc)

for dotfile in ${DOT_FILES[@]}
do
  ln -s $HOME/dotfiles/$dotfile $HOME/$dotfile
done
