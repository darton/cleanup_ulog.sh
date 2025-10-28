#!/bin/bash

# === CONFIGURATION ===
MIN_AGE_MONTHS=12         # <-- Change this to adjust retention period (e.g. 18 for 1.5 years)
BASE_DIR="/var/log/ulog"
SCRIPT_NAME="$(basename "$0")"

# === ARGUMENT PARSING ===
DRY_RUN="yes"             # Default is dry-run mode
if [[ "$1" == "--force" ]]; then
    DRY_RUN="no"          # Enable actual deletion
fi

# === DATE CALCULATIONS ===
CURRENT_YEAR=$(date +%Y)
CURRENT_MONTH=$(date +%m)
CURRENT_TOTAL_MONTHS=$((CURRENT_YEAR * 12 + CURRENT_MONTH))

# === LOGGING FUNCTION ===
log_action() {
    local level="$1"
    local message="$2"
    logger -p "user.${level}" -t "$SCRIPT_NAME" "$message"
}

# === DELETION FUNCTION ===
remove_dir() {
    local path="$1"
    if [[ "$DRY_RUN" == "yes" ]]; then
        log_action "info" "[DRY_RUN] Simulated deletion: $path"
    else
        rm -rf "$path" \
            && log_action "info" "Deleted: $path" \
            || log_action "err" "Error deleting: $path"
    fi
}

# === MAIN LOOP OVER YEAR/MONTH DIRECTORIES ===
for year_dir in "$BASE_DIR"/*; do
    year=$(basename "$year_dir")
    [[ "$year" =~ ^[0-9]{4}$ ]] || continue

    for month_dir in "$year_dir"/*; do
        month=$(basename "$month_dir")
        [[ "$month" =~ ^[0-9]{2}$ ]] || continue

        dir_total_months=$((10#$year * 12 + 10#$month))
        age_months=$((CURRENT_TOTAL_MONTHS - dir_total_months))

        if (( age_months >= MIN_AGE_MONTHS )); then
            remove_dir "$month_dir"
        fi
    done
done
