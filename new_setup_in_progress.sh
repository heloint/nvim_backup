prefix=""

if (( $EUID != 0))
    then
        prefix="sudo"
fi

$prefix apt update

$prefix apt install -y gcc \
                       perl \
                       make \
                       build-essential \
                       linux-headers-$(uname-r) \
                       git \
                       curl \
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

# Download and install packer plugin manager.
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install node version manager.
source ~/.bashrc
nvm install node
nvim install-latest-npm

# Get my configs.
git clone https://github.com/heloint/nvim_backup
cp ./nvim_backup/init.lua .

# Install plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Remove comments from the plugin config lines.
sed -i '56,184s/^-- //g' init.lua
