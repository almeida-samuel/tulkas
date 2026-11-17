#!/usr/bin/env bash
# Deploy the framework and its contexts from this repository to ~/.claude.
#
# Usage: scripts/deploy.sh [-n] [context...]
#   -n         dry run: list what would be deployed, change nothing
#   context    contexts to deploy (default: every folder in contexts/)
#
# Set CLAUDE_HOME to deploy somewhere other than ~/.claude (e.g. for a test).
#
# What goes where (under CLAUDE_HOME):
#   skills/{case-protocol,run-case,close-case,orchestrator-turn,tulkas-init}/   framework protocol and setup
#   agents/<context>-*.md                                 roles
#   skills/<context>-*/                                   guides
#   rules/<context>/                                      rules (paths resolve against the repo you work in)
#   tulkas/contexts/<context>/                  shared context files
#   tulkas/{VERSION,manifest.txt}               deployed version and file list
#
# Repo-relative links (contexts/..., .claude/agents/..., ../../contexts/...) are rewritten
# to absolute paths in the deployed copies. On redeploy, files from the previous deploy are
# removed first, so deleted or renamed definitions don't linger. Files the script did not
# deploy are never touched: if one is in the way, the script stops.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${CLAUDE_HOME:-$HOME/.claude}"
FW="$TARGET/tulkas"
MANIFEST="$FW/manifest.txt"
FRAMEWORK_SKILLS=(case-protocol run-case close-case orchestrator-turn tulkas-init)

DRY_RUN=0
if [ "${1:-}" = "-n" ]; then DRY_RUN=1; shift; fi

if [ $# -gt 0 ]; then
  CONTEXTS=("$@")
else
  CONTEXTS=()
  for d in "$REPO"/contexts/*/; do CONTEXTS+=("$(basename "$d")"); done
fi
for ctx in "${CONTEXTS[@]}"; do
  [ -d "$REPO/contexts/$ctx" ] || { echo "Unknown context: $ctx" >&2; exit 1; }
done

VERSION="$(tr -d '[:space:]' < "$REPO/VERSION")"
COMMIT="$(git -C "$REPO" rev-parse --short HEAD 2>/dev/null || echo unknown)"
if [ -n "$(git -C "$REPO" status --porcelain -- .claude contexts VERSION 2>/dev/null)" ]; then
  COMMIT="$COMMIT-dirty"
fi

# 1. Stage everything in the target layout.
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/skills" "$STAGE/agents" "$STAGE/rules" "$STAGE/tulkas/contexts"

for s in "${FRAMEWORK_SKILLS[@]}"; do cp -R "$REPO/.claude/skills/$s" "$STAGE/skills/"; done
for ctx in "${CONTEXTS[@]}"; do
  for f in "$REPO"/.claude/agents/"$ctx"-*.md; do [ -e "$f" ] && cp "$f" "$STAGE/agents/"; done
  for d in "$REPO"/.claude/skills/"$ctx"-*/; do [ -e "$d" ] && cp -R "${d%/}" "$STAGE/skills/"; done
  [ -d "$REPO/.claude/rules/$ctx" ] && cp -R "$REPO/.claude/rules/$ctx" "$STAGE/rules/"
  cp -R "$REPO/contexts/$ctx" "$STAGE/tulkas/contexts/"
done
echo "$VERSION ($COMMIT)" > "$STAGE/tulkas/VERSION"

# 2. Rewrite repo-relative links to absolute paths in the deployed copies.
#    First, links that cross between contexts/ and .claude/ (their layout changes);
#    then any remaining relative Markdown link, resolved against the file's own folder
#    (the staged layout matches the deployed one).
find "$STAGE" -name '*.md' -print0 | xargs -0 perl -pi -e "
  s#(?<![\w/.-])(?:\.\./)*contexts/#$FW/contexts/#g;
  s#(?<![\w/.-])(?:\.\./)*\.claude/(agents|skills|rules)/#$TARGET/\$1/#g;
"
find "$STAGE" -name '*.md' -print0 | STAGE="$STAGE" TARGET="$TARGET" xargs -0 perl -pi -e '
  BEGIN { use File::Basename; }
  sub resolve {
    my ($dir, $rel) = @_;
    my @parts = split m{/}, "$dir/$rel";
    my @out;
    for (@parts) { next if $_ eq "." || $_ eq ""; if ($_ eq "..") { pop @out } else { push @out, $_ } }
    my $abs = "/" . join("/", @out);
    $abs =~ s{^\Q$ENV{STAGE}\E}{$ENV{TARGET}};
    return $abs;
  }
  my $dir = dirname($ARGV);
  s{\]\((?![a-z]+:|/|#)([^)\s]+)\)}{"](" . resolve($dir, $1) . ")"}ge;
'

( cd "$STAGE" && find . -type f | sed 's#^\./##' | sort ) > "$STAGE/new-manifest.txt"
grep -v '^new-manifest.txt$' "$STAGE/new-manifest.txt" > "$STAGE/files.txt"
echo "tulkas/manifest.txt" >> "$STAGE/files.txt"

# 3. Refuse to overwrite files that a previous deploy didn't create.
touch "$STAGE/old-manifest.txt"
[ -f "$MANIFEST" ] && cp "$MANIFEST" "$STAGE/old-manifest.txt"
CONFLICTS=0
while IFS= read -r rel; do
  if [ -e "$TARGET/$rel" ] && ! grep -qxF "$rel" "$STAGE/old-manifest.txt"; then
    echo "Conflict: $TARGET/$rel exists and was not deployed by this script" >&2
    CONFLICTS=1
  fi
done < "$STAGE/files.txt"
[ "$CONFLICTS" -eq 0 ] || { echo "Nothing deployed. Move those files away and retry." >&2; exit 1; }

if [ "$DRY_RUN" -eq 1 ]; then
  echo "Dry run: would deploy framework $VERSION ($COMMIT), contexts: ${CONTEXTS[*]}, to $TARGET"
  echo "Files: $(wc -l < "$STAGE/files.txt" | tr -d ' ') (previous deploy: $(wc -l < "$STAGE/old-manifest.txt" | tr -d ' '))"
  exit 0
fi

# 4. Remove the previous deploy, then copy the new one.
while IFS= read -r rel; do
  [ -n "$rel" ] && rm -f "$TARGET/$rel"
done < "$STAGE/old-manifest.txt"
while IFS= read -r rel; do
  dir="$(dirname "$TARGET/$rel")"
  while [ "$dir" != "$TARGET" ] && [ -d "$dir" ] && rmdir "$dir" 2>/dev/null; do dir="$(dirname "$dir")"; done
done < "$STAGE/old-manifest.txt"

mkdir -p "$TARGET"
while IFS= read -r rel; do
  [ "$rel" = "tulkas/manifest.txt" ] && continue
  mkdir -p "$(dirname "$TARGET/$rel")"
  cp "$STAGE/$rel" "$TARGET/$rel"
done < "$STAGE/files.txt"
cp "$STAGE/files.txt" "$MANIFEST"

echo "Deployed framework $VERSION ($COMMIT) to $TARGET"
echo "Contexts: ${CONTEXTS[*]}"
echo "Files: $(wc -l < "$MANIFEST" | tr -d ' ')"
