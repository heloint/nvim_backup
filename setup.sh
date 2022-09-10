#!/bin/bash

sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update -y
sudo apt-get install -y neovim
sudo apt install -y xclip

sudo apt install nodejs npm
sudo npm update npm -g
sudo npm install -g npm@latest
npm cache clean -f
sudo npm install -g n
sudo n stable
sudo npm i -g pyright
sudo npm i -g intelephense
sudo npm i -g vscode-langservers-extracted
sudo npm i -g typescript-language-server typescript


git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "stty -ixon" >> ~/.bashrc
echo "alias vim='nvim'" >> ~/.bashrc

mkdir -p ~/.config/nvim/
cp ./init.lua ~/.config/nvim/
