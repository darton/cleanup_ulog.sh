Świetnie, Dariusz — oto pełny listing `README.md` w czystym **Markdown**, zawierający wszystko: opis, konfigurację, użycie, cron, Makefile, logikę działania, licencję i teraz także sekcję `Options` z opisem argumentów CLI.

````markdown
# 🧹 cleanup_ulog.sh

Modular Bash script for cleaning up structured log directories (`/var/log/ulog/YYYY/MM`) older than a configurable number of months.  
Supports dry-run mode, syslog logging, and cron integration. Designed for ISPs and sysadmins managing long-term log retention.

---

## 📦 Features

- Deletes monthly log directories older than `MIN_AGE_MONTHS`
- Default dry-run mode (safe testing)
- `--force` flag for actual deletion
- Syslog logging via `logger`
- Cron-friendly and Makefile-ready
- Easy to extend or integrate with existing frameworks

---

## ⚙️ Configuration

Edit the script header to set retention policy:

```bash
MIN_AGE_MONTHS=12       # Retention threshold (e.g. 18 for 1.5 years)
BASE_DIR="/var/log/ulog"
```

Or override via environment:

```bash
export MIN_AGE_MONTHS=18
./cleanup_ulog.sh --force
```

---

## 🚀 Usage

### Dry-run (default behavior)
Runs in simulation mode — no directories are deleted, only logged.

```bash
./cleanup_ulog.sh
```

### Force deletion
Deletes all eligible directories older than `MIN_AGE_MONTHS`.

```bash
./cleanup_ulog.sh --force
```

### Custom retention period
Override the default threshold via environment:

```bash
export MIN_AGE_MONTHS=6
./cleanup_ulog.sh --force
```

---

## 🧾 Options

| Argument       | Description                                      |
|----------------|--------------------------------------------------|
| `--force`      | Enables actual deletion (default is dry-run)     |
| `MIN_AGE_MONTHS` | Environment variable to set retention threshold |

---

## 🕓 Cron Integration

Run automatically on the first day of each month at 03:00:

```cron
0 3 1 * * /path/to/cleanup_ulog.sh --force
```

---

## 🧪 Sample Output (dry-run)

```text
Oct 28 03:00 cleanup_ulog.sh: [DRY_RUN] Simulated deletion: /var/log/ulog/2023/09
Oct 28 03:00 cleanup_ulog.sh: [DRY_RUN] Simulated deletion: /var/log/ulog/2023/10
```

---

## 🧠 Logic Overview

- Calculates current month as `YEAR × 12 + MONTH`
- Iterates over `/var/log/ulog/YYYY/MM` directories
- Compares each directory’s age in months
- Deletes if age ≥ `MIN_AGE_MONTHS`
- Logs actions via `logger`

---

