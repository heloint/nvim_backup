#!/bin/bash

sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update -y
sudo apt-get install -y neovim
sudo apt install -y xclip

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "stty -ixon" >> ~/.bashrc
echo "alias vim='nvim'" >> ~/.bashrc

mkdir -p ~/.config/nvim/
cp ./init.lua ~/.config/nvim/


