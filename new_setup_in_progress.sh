#!/usr/bin/env bash

prefix=""

if (( $EUID != 0))
    then
        prefix="sudo"
fi

$prefix apt update

$prefix apt install -y gcc \
                       # perl \
                       # make \
                       # build-essential \
                       # linux-headers-$(uname-r) \
                       git \
                       # curl \
                       # wget \
                       xclip

# Download node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# Install node version manager.
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# nvm install node
# nvm install-latest-npm

# Download neovim latest debian package
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb

# Install neovim
$prefix apt install -y ./nvim-linux64.deb

# Create config dir for neovim
mkdir -p ~/.config/nvim ; cd ~/.config/nvim

# Download and install packer plugin manager.
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Get my configs.
git clone https://github.com/heloint/nvim_backup
cp ./nvim_backup/init.lua .

# Install plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Remove comments from the plugin config lines.
sed -i '56,184s/^-- //g' init.lua

# Remove trailing white spaces.
sed -i 's/\s\+$//g' init.lua

# curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/new_setup_in_progress.sh | bash ; source ~/.bashrc; nvm install node ; nvm install-latest-npm
