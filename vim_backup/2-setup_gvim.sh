#!/bin/bash

# Move files to the home dir. -------------------------
# -----------------------------------------------------------------
mv -vi vim ~/.vim ; mv -vi vimrc ~/.vimrc ; mv -vi pdbrc ~/.pdbrc
cd ~/.vim

# Install ALE LINTING ---------------------------------------------
# -----------------------------------------------------------------
mkdir -vp ~/.vim/pack/git-plugins/start
git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.vim/pack/git-plugins/start/ale

# Install INDENTLINE ----------------------------------------------
# -----------------------------------------------------------------
git clone https://github.com/Yggdroot/indentLine.git ~/.vim/pack/vendor/start/indentLine
vim -u NONE -c "helptags  ~/.vim/pack/vendor/start/indentLine/doc" -c "q"

# Install VIM-CLOSETAG --------------------------------------------
# -----------------------------------------------------------------
git clone https://github.com/alvan/vim-closetag 
mv -vi ~/.vim/vim-closetag/plugin ~/.vim ; rm -vfr vim-closetag

# Install FUGITIVE (GIT PLUGIN)-------------------------------------
# ------------------------------------------------------------------
mkdir -p ~/.vim/pack/tpope/start
cd ~/.vim/pack/tpope/start
git clone https://tpope.io/vim/fugitive.git
vim -u NONE -c "helptags fugitive/doc" -c q
