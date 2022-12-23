sudo apt update

sudo apt install -y gcc perl make build-essential linux-headers-$(uname-r) git curl wget xclip

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

source ~/.bashrc

nvm install node

nvim install-latest-npm

wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb

sudo apt install -y ./nvim-linux64.deb

mkdir -p ~/.config/nvim ; cd !$

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone https://github.com/heloint/nvim_backup

cp ./nvim_backup/init.lua .

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

sed -i '56,184s/^-- //g' init.lua

