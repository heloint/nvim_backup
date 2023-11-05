Quick install:

```bash
curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/setup.sh | bash \
&& source ~/.bashrc; nvm install node \
&& nvm install-latest-npm \
&& sudo ln -s $(which npm) /usr/local/bin/npm \
&& sudo ln -s $(which node) /usr/local/bin/node \
&& sudo npm install -g tree-sitter-cli
```

Minimal installation for remote servers (no sudo needed):

```bash
curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/setup-minimal/setup.sh | bash \
&& source ~/.bashrc
```
