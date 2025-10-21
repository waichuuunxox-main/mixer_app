#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PBXPROJ="$ROOT_DIR/macos/Runner.xcodeproj/project.pbxproj"
FINALIZER="$ROOT_DIR/scripts/finalize_widget.sh"

if [ ! -x "$FINALIZER" ]; then
  echo "Error: finalize script missing or not executable: $FINALIZER" >&2
  exit 2
fi

echo "Running finalize script in --dry-run mode"
$FINALIZER --dry-run

# Use git to show any changes to pbxproj in working tree
# We expect no changes when finalize is run with --dry-run; if there are changes, print them

echo "Checking for pbxproj diffs in git"
# Ensure we're inside a git repo
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  DIFF=$(git --no-pager diff --unified=0 -- "$PBXPROJ" || true)
  if [ -z "$DIFF" ]; then
    echo "No diffs detected for $PBXPROJ"
    exit 0
  else
    echo "Found diffs for $PBXPROJ:" 
    echo "$DIFF"
    # Non-zero exit to fail CI
    exit 3
  fi
else
  # If not a git repo, fallback to comparing with latest backup
  echo "Not in a git repo; falling back to backup comparison"
  LATEST_BACKUP=$(ls -1t "$ROOT_DIR/.pbxproj_backups"/project.pbxproj.*.bak 2>/dev/null | head -n1 || true)
  if [ -z "$LATEST_BACKUP" ]; then
    echo "No backups found to compare against. Exiting with code 0 (nothing to check)."
    exit 0
  fi
  if diff -u "$LATEST_BACKUP" "$PBXPROJ" >/dev/null; then
    echo "No diffs between $PBXPROJ and latest backup"
    exit 0
  else
    echo "Diff between $LATEST_BACKUP and $PBXPROJ:" 
    diff -u "$LATEST_BACKUP" "$PBXPROJ" || true
    exit 3
  fi
fi
