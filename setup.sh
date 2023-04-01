#!/bin/bash

prefix=""

if (( $EUID != 0))
    then
        prefix="sudo"
fi

$prefix apt update

$prefix apt install -y build-essential \
                       gcc \
                       git \
                       wget \
                       xclip

# Download node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# Download neovim latest debian package
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb

# Install neovim
$prefix apt install -y ./nvim-linux64.deb

# Create config dir for neovim
mkdir -p ~/.config/nvim ; cd ~/.config/nvim

# Download and install Packer plugin manager.
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Get my configs.
git clone https://github.com/heloint/nvim_backup
cp ./nvim_backup/init.lua .
cp -r ./nvim_backup/lua .

# Install Fura Nerdfont
cp ./nvim_backup/fonts/fura-mono-regular-nerd-font-complete.otf ~/.local/share/fonts/
fc-cache -fv
setfont fura-mono-regular-nerd-font-complete.otf

# The command to fetch the script from Github and execute it.
# curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/new_setup_in_progress.sh | bash ; source ~/.bashrc; nvm install node ; nvm install-latest-npm
