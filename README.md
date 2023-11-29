Quick install:
```bash
source /dev/stdin <<< "$(curl --insecure https://raw.githubusercontent.com/heloint/nvim_backup/main/setup.sh)"; echo done
```

**NOTE:**

Don't forget that for the Python plugins you will need to set $PYTHONPATH,
which is not done automatically (by 2023) with the "venv" module. So you will
need to add ...

```bash
    export PYTHONPATH=$VIRTUAL_ENV/lib/python<python_version>/site-packages
```

to your "~/venv/bin/activate" file! Otherwise they won't work (but they don't
throw an error. It's shit, but it is what it is... ...

Minimal installation for remote servers (no sudo needed):
```bash
curl -o- https://raw.githubusercontent.com/heloint/nvim_backup/main/setup-minimal/setup.sh | bash \
&& source ~/.bashrc
```
