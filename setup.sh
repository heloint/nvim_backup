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
                       git \
                       wget \
                       xclip \
                       python3.10-venv

# Download node version manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

# Download neovim latest debian package
wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage

# Install neovim
mkdir -p ~/.local/bin/ && \
chmod +x nvim.appimage && \
mv nvim.appimage ~/.local/bin/; cd ~/.local/bin/ && \
./nvim.appimage --appimage-extract && \
ln -s $PWD/squashfs-root/AppRun $PWD/nvim && \
echo "export PATH=\"$HOME/.local/bin:$PATH\"" >> ~/.bashrc

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
find $HOME/venv -type d -name site-packages -exec echo "export PYTHONPATH=$PYTHONPATH:{}" >> ~/.bashrc \;
. $HOME/venv/bin/activate
pip install "python-lsp-server[all]"
pip install pylsp-mypy

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
&& . ~/.bashrc \
&& $prefix npm install -g tree-sitter-cli

