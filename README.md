Quick install:
```bash
source /dev/stdin <<< "$(curl --insecure https://raw.githubusercontent.com/heloint/nvim_backup/main/setup.sh)"; echo done
```

Minimal installation for remote servers (no sudo needed):
```bash
curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/setup-minimal/setup.sh | bash \
&& source ~/.bashrc
```
