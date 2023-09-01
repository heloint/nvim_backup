#!/bin/bash

# Download neovim latest debian package
wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage

# Install neovim
mkdir -p ~/.local/bin/
chmod +x nvim.appimage
mv nvim.appimage ~/.local/bin/; cd ~/.local/bin/
echo "export PATH=\"$HOME/.local/bin:$PATH\"" >> ~/.bashrc

# Create config dir for neovim
mkdir -p ~/.config/nvim ; cd ~/.config/nvim

# Get my configs.
git clone https://github.com/heloint/nvim_backup
cp ./nvim_backup/setup-minimal/init.lua .
cp -r ./nvim_backup/setup-minimal/lua .

# Install Fura Nerdfont
mkdir -p ~/.local/share/fonts/
cp ./nvim_backup/fonts/fura-mono-regular-nerd-font-complete.otf ~/.local/share/fonts/
fc-cache -fv
setfont fura-mono-regular-nerd-font-complete.otf

cd ~
wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
tar xvf ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
cp ripgrep-13.0.0-x86_64-unknown-linux-musl/rg ~/.local/bin
rm -r ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz ripgrep-13.0.0-x86_64-unknown-linux-musl

# The command to fetch the script from Github and execute it.
# curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/setup-minimal/setup.sh | bash ; source ~/.bashrc
