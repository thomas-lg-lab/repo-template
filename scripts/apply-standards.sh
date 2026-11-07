#!/bin/sh
# Applies the repository settings a template cannot carry: merge options, security features and
# the main ruleset (.github/rulesets/main.json). Idempotent: run it once after "Use this
# template", and again after editing the ruleset file.
#
# Usage: scripts/apply-standards.sh owner/repo
# Needs: gh, logged in as the repository owner (admin rights on the repository).
#
# Then, by hand (the API cannot do it for a personal account):
#   - install the thomas-lg-renovate App on the repository (Settings > GitHub Apps), which enrols
#     it in the central Renovate runner of thomas-lg/renovate-config;
#   - add the project's own CI job names to required_status_checks in the ruleset file.

set -eu

REPO="${1:?usage: scripts/apply-standards.sh owner/repo}"
RULESET_FILE="$(dirname "$0")/../.github/rulesets/main.json"

echo "Settings: squash only, branches deleted on merge, auto-merge allowed"
gh api -X PATCH "repos/$REPO" \
    -F allow_squash_merge=true -F allow_merge_commit=false -F allow_rebase_merge=false \
    -F delete_branch_on_merge=true -F allow_auto_merge=true \
    -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=PR_BODY \
    -F has_wiki=false -F has_projects=false >/dev/null

echo "Security: secret scanning and push protection"
gh api -X PATCH "repos/$REPO" --input - >/dev/null <<'EOF'
{"security_and_analysis": {"secret_scanning": {"status": "enabled"}, "secret_scanning_push_protection": {"status": "enabled"}}}
EOF

NAME="$(sed -n 's/.*"name": *"\([^"]*\)".*/\1/p' "$RULESET_FILE" | head -n 1)"
ID="$(gh api "repos/$REPO/rulesets" --jq ".[] | select(.name == \"$NAME\") | .id")"
if [ -n "$ID" ]; then
    echo "Ruleset '$NAME': updating ($ID)"
    gh api -X PUT "repos/$REPO/rulesets/$ID" --input "$RULESET_FILE" >/dev/null
else
    echo "Ruleset '$NAME': creating"
    gh api -X POST "repos/$REPO/rulesets" --input "$RULESET_FILE" >/dev/null
fi

echo "Done. Left by hand: install the thomas-lg-renovate App on $REPO."
