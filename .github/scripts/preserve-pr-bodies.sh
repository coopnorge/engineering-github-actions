#!/usr/bin/env bash
set -eu -o pipefail
set -x

# Expected environment variables:
# - GH_TOKEN
# - REPO
# - CURRENT_PR_NUMBER
# - SERVICE
# - ENVIRONMENT

# Only run when a real service name is set
if [[ -z "${SERVICE}" || "${SERVICE}" == "service" ]]; then
    echo "No explicit service set, skipping append of prior PR bodies."
    exit 0
fi

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

BODY_LIMIT=65000 # hard cap to stay under GitHub's PR body limit

# Fetch current PR body
gh pr view "$CURRENT_PR_NUMBER" --repo "$REPO" --json body --jq .body > "$workdir/current_body.md" || echo "" > "$workdir/current_body.md"

# Find prior PRs for same service/env (open, labeled, excluding current)
gh pr list \
    --label "service:${SERVICE}" \
    --label "environment:${ENVIRONMENT}" \
    --label "deployment" \
    --state open \
    --app 'writebackinpr' \
    --repo "$REPO" \
    --json number,createdAt \
> "$workdir/open_prs.json"

# Filter out current PR and sort oldest->newest so bodies read chronologically
jq -c '[ .[] | select(.number != '"$CURRENT_PR_NUMBER"') ] | sort_by(.createdAt)' "$workdir/open_prs.json" > "$workdir/old_prs_sorted.json"

if [[ "$(jq 'length' "$workdir/old_prs_sorted.json")" -eq 0 ]]; then
    echo "No prior open PRs found for this service/environment. Nothing to append."
    exit 0
fi

# Build a plain concatenation of prior bodies with blank-line separators
: > "$workdir/prior_bodies.md"
jq -r '.[].number' "$workdir/old_prs_sorted.json" | while read -r prn; do
body="$(gh pr view "$prn" --repo "$REPO" --json body --jq .body || echo "")"

# Skip empty/null bodies
if [[ -n "$body" && "$body" != "null" ]]; then
    # Ensure we always put a blank line between bodies (no extra markup)
    if [[ -s "$workdir/prior_bodies.md" ]]; then
        printf "\n\n" >> "$workdir/prior_bodies.md"
    fi
    printf "%s" "$body" >> "$workdir/prior_bodies.md"
fi
done

# If nothing to append (all empty), bail
if [[ ! -s "$workdir/prior_bodies.md" ]]; then
    echo "Prior PRs had no bodies. Nothing to append."
    exit 0
fi

# Combine: current body + blank lines + appended bodies
# Keep under GitHub's PR body size limit without adding any extra text/markers
current_len=$(wc -c < "$workdir/current_body.md" || echo 0)
sep=$'\n\n'
sep_len=${#sep}
prior_len=$(wc -c < "$workdir/prior_bodies.md" || echo 0)

# If everything fits, append all
if (( current_len + sep_len + prior_len <= BODY_LIMIT )); then
    printf "%s" "$(cat "$workdir/current_body.md")" > "$workdir/new_body.md"
    printf "%s" "$sep" >> "$workdir/new_body.md"
    cat "$workdir/prior_bodies.md" >> "$workdir/new_body.md"
else
# Append as much as fits (may cut mid-body; no extra notes/markers)
    printf "%s" "$(cat "$workdir/current_body.md")" > "$workdir/new_body.md"
    if (( current_len + sep_len < BODY_LIMIT )); then
        printf "%s" "$sep" >> "$workdir/new_body.md"
        budget=$(( BODY_LIMIT - current_len - sep_len ))
        head -c "$budget" "$workdir/prior_bodies.md" >> "$workdir/new_body.md" || true
    fi
fi

# Update the PR body
gh pr edit "$CURRENT_PR_NUMBER" --repo "$REPO" --body-file "$workdir/new_body.md"