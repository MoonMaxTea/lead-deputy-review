#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:?Usage: $0 <project-root> [skills-source-root]}"
SKILLS_SOURCE_OVERRIDE="${2:-}"

BUNDLE_SKILLS=(
  executing-plans
  test-driven-development
  finishing-a-development-branch
  verification-before-completion
  systematic-debugging
)

resolve_superpowers_skills_root() {
  if [[ -n "$SKILLS_SOURCE_OVERRIDE" && -d "$SKILLS_SOURCE_OVERRIDE" ]]; then
    echo "$SKILLS_SOURCE_OVERRIDE"
    return
  fi

  local cache_base="${HOME}/.cursor/plugins/cache/cursor-public/superpowers"
  if [[ ! -d "$cache_base" ]]; then
    echo "Superpowers plugin cache not found at $cache_base" >&2
    exit 1
  fi

  local dir
  while IFS= read -r -d '' dir; do
    if [[ -d "${dir}/skills" ]]; then
      echo "${dir}/skills"
      return
    fi
  done < <(find "$cache_base" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  echo "No skills folder under $cache_base" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="$(resolve_superpowers_skills_root)"
DEST_ROOT="$(cd "$PROJECT_ROOT" && pwd)/.cursor/skills/superpowers"

mkdir -p "$DEST_ROOT"

for skill in "${BUNDLE_SKILLS[@]}"; do
  src="${SOURCE_ROOT}/${skill}"
  dst="${DEST_ROOT}/${skill}"
  if [[ ! -f "${src}/SKILL.md" ]]; then
    echo "Missing SKILL.md for ${skill} at ${src}" >&2
    exit 1
  fi
  rm -rf "$dst"
  cp -R "$src" "$dst"
  echo "Copied ${skill} -> ${dst}"
done

cp "${SCRIPT_DIR}/../deputy-superpowers-bundle/MANIFEST.md" "${DEST_ROOT}/MANIFEST.md"
echo "synced_at: $(date +%Y-%m-%d)" >> "${DEST_ROOT}/MANIFEST.md"
echo "source_skills_root: ${SOURCE_ROOT}" >> "${DEST_ROOT}/MANIFEST.md"

echo "Deputy Superpowers bundle ready at ${DEST_ROOT}"
