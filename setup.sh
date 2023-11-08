#!/bin/bash

prefix=""

if (( $EUID != 0))
    then
        prefix="sudo"
fi

$prefix apt update

$prefix apt install -y build-essential \
                       git \
                       gcc \
                       g++ \
                       git \
                       wget \
                       xclip \
                       libstdc++6 \
                       python3.10-venv

# Download node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# Install neovim and tree-sitter-cli
mkdir -p ~/.local/bin/ && \
cd ~/.local/bin/ && \
wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage && \
wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.20.8/tree-sitter-linux-x64.gz && \
gunzip tree-sitter-linux-x64.gz && \
mv tree-sitter-linux-x64 tree-sitter && \
chmod +x tree-sitter && \
chmod +x nvim.appimage && \
./nvim.appimage --appimage-extract && \
ln -s $PWD/squashfs-root/AppRun $PWD/nvim && \
echo "export PATH=\"$HOME/.local/bin:$PATH\"" >> ~/.bashrc
. ~/.bashrc

# Create config dir for neovim and get my configs.
mkdir -p ~/.config/nvim && \
cd ~/.config/nvim && \
git clone https://github.com/heloint/nvim_backup && \
cp ./nvim_backup/init.lua . && \
cp -r ./nvim_backup/lua .

# Install Fura Nerdfont (optional, not all environment will have support for icons)
# mkdir -p ~/.local/share/fonts/
# cp ./nvim_backup/fonts/fura-mono-regular-nerd-font-complete.otf ~/.local/share/fonts/
# fc-cache -fv
# setfont fura-mono-regular-nerd-font-complete.otf

# Install pylsp 3th parties (Mypy, Black, etc..)
python3 -m venv $HOME/venv && \
echo "[ -f ~/venv/bin/activate ] && source ~/venv/bin/activate" >> ~/.bashrc
find $HOME/venv -type d -name site-packages -exec echo "export PYTHONPATH=$PYTHONPATH:{}" >> ~/.bashrc \;
. ~/.bashrc

# Install ripgrep
cd ~ && \
wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz && \
tar xvf ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz && \
cp ripgrep-13.0.0-x86_64-unknown-linux-musl/rg ~/.local/bin && \
rm -r ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz ripgrep-13.0.0-x86_64-unknown-linux-musl

# Install node and npm
. ~/.bashrc \
&& nvm install node \
&& nvm install-latest-npm \
&& ln -s $(which npm) ~/.local/bin/npm \
&& ln -s $(which node) ~/.local/bin/node \
&& . ~/.bashrc

