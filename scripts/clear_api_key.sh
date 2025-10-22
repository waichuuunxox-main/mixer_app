#!/usr/bin/env bash
# Attempt to clear the stored API key for the Mixzer app on macOS by
# deleting the SharedPreferences entry. This is a best-effort helper and
# may require adjusting the bundle id for your app.
#
# Usage:
#   ./scripts/clear_api_key.sh --bundle-id com.example.mixzerApp --dry-run

set -euo pipefail
BUNDLE_ID="com.example.mixzerApp"
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --bundle-id) BUNDLE_ID="$2"; shift 2;;
    --dry-run) DRY_RUN=true; shift;;
    *) echo "Unknown arg: $1"; exit 1;;
  esac
done

PLIST_PATH="$HOME/Library/Containers/${BUNDLE_ID}/Data/Library/Preferences/${BUNDLE_ID}.plist"

echo "Target plist: $PLIST_PATH"
if [[ "$DRY_RUN" == "true" ]]; then
  echo "Dry run: will not modify files. Use without --dry-run to delete the API key entry if present."
  exit 0
fi

if [[ ! -f "$PLIST_PATH" ]]; then
  echo "Plist not found at $PLIST_PATH. The app may not have created SharedPreferences yet or uses a different bundle id."
  exit 1
fi

# Use /usr/libexec/PlistBuddy to delete key if present (best-effort)
KEY="mixzer_api_key"
if /usr/libexec/PlistBuddy -c "Print :$KEY" "$PLIST_PATH" &>/dev/null; then
  echo "Found key $KEY — deleting..."
  /usr/libexec/PlistBuddy -c "Delete :$KEY" "$PLIST_PATH"
  echo "Deleted $KEY from $PLIST_PATH"
else
  echo "Key $KEY not present in plist."
fi

# Touch container so macOS updates sandboxed preferences
touch "$PLIST_PATH"

echo "Done. Restart the app to pick up changes."
