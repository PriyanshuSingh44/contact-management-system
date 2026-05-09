#!/bin/sh
# entrypoint.sh — Seed /app/data/contacts.json if the named volume is empty on first start.

# Set defaults FIRST, then compute DATA_DIR from the final value
CONTACTS_FILE="${CONTACTS_FILE:-/app/data/contacts.json}"
DATA_DIR="${CONTACTS_FILE%/*}"   # strip filename → /app/data
PHOTOS_DIR="${PHOTOS_DIR:-/app/photos}"

# Ensure directories exist inside the mounted volumes
mkdir -p "$DATA_DIR"
mkdir -p "$PHOTOS_DIR"

# Seed contacts.json with an empty JSON array if not present yet
if [ ! -f "$CONTACTS_FILE" ]; then
    echo "[]" > "$CONTACTS_FILE"
    echo "[entrypoint] Initialized $CONTACTS_FILE with empty list."
fi

# Hand off to the real CMD (streamlit run ...)
exec "$@"
