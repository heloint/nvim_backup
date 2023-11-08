Quick install:

```bash
curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/setup.sh | bash \
&& source ~/.bashrc \
&& nvm install node \
&& nvm install-latest-npm \
&& ln -s $(which npm) ~/.local/bin/npm \
&& ln -s $(which node) ~/.local/bin/node \
&& sudo npm install -g tree-sitter-cli
```

```bash
source /dev/stdin <<< "$(curl --insecure https://raw.githubusercontent.com/heloint/nvim_backup/main/setup.sh)"; echo done
```

Minimal installation for remote servers (no sudo needed):

```bash
curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/setup-minimal/setup.sh | bash \
&& source ~/.bashrc
```
