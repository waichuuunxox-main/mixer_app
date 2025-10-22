#!/usr/bin/env bash
# Post a comment to a GitHub PR using the REST API.
# Usage: GITHUB_TOKEN=<token> ./scripts/post_pr_comment.sh <owner> <repo> <pr_number> "Comment body"

set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "Usage: GITHUB_TOKEN=<token> $0 <owner> <repo> <pr_number> \"Comment body\""
  exit 1
fi

OWNER="$1"
REPO="$2"
PR_NUMBER="$3"
BODY="$4"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_TOKEN is required in environment"
  exit 1
fi

API_URL="https://api.github.com/repos/$OWNER/$REPO/issues/$PR_NUMBER/comments"

curl -sS -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" \
  -d "{\"body\": \"${BODY//"/\"}\"}" \
  "$API_URL"
