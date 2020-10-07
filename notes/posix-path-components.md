# POSIX path components

```bash

                             ┌─── basename "$0"
               ┌─────────────┴┐
               │              │

 / some / dir / some-script.sh

│                             │
└────────────────────────────┬┘
                             └─── realpath "$0"
```

```bash

            ┌──────────────────── basename "$(dirname "$(realpath "$0")")"
         ┌──┴┐
         │   │

 / some / dir / some-script.sh

│            │
└───────────┬┘
            ├─ relative ───────── dirname "$0"
            └─ absolute ───────── dirname "$(realpath "$0")"
```
