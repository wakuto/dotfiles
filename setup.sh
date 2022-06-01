#!/bin/bash

DOT_FILES=(.vimrc)

for dotfile in ${DOT_FILES[@]}
do
  ln -s $HOME/dotfiles/$dotfile $HOME/$dotfile
done

ln -s $HOME/dotfiles/coc-settings.json $HOME/.config/nvim/coc-settings.json
ln -s $HOME/dotfiles/init.vim $HOME/.config/nvim/init.vim
