#!/usr/bin/env bash
set -euo pipefail

# Enforce ADR 0012 SVG companion checks. See ../docs/adr/0012-svg-companions-for-diagrams.md.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

missing_companions=()
orphaned_companions=()

has_diagram_mermaid_block() {
  awk '
    $0 ~ /^## Diagram[[:space:]]*$/ { window=6; next }
    window > 0 {
      if ($0 ~ /^```mermaid[[:space:]]*$/) { found=1; exit }
      if ($0 ~ /^##[[:space:]]+/) { window=0 }
      window--
    }
    END { exit(found ? 0 : 1) }
  ' "$1"
}

while IFS= read -r markdown_file; do
  if has_diagram_mermaid_block "$markdown_file"; then
    slug="$(basename "$markdown_file" .md)"
    expected_svg="docs/diagrams/${slug}.svg"
    if [ ! -f "$expected_svg" ]; then
      missing_companions+=("${markdown_file#./} -> ${expected_svg}")
    fi
  fi
done < <(
  find . \
    \( -type d \( -name .git -o -name node_modules \) -prune \) -o \
    \( -type f -name "*.md" ! -path "./docs/adr/*" -print \) | sort
)

while IFS= read -r svg_file; do
  slug="$(basename "$svg_file" .svg)"
  mapfile -t source_candidates < <(
    find . \
      \( -type d \( -name .git -o -name node_modules \) -prune \) -o \
      \( -type f -name "${slug}.md" ! -path "./docs/adr/*" -print \) | sort
  )

  if [ "${#source_candidates[@]}" -eq 0 ]; then
    orphaned_companions+=("${svg_file#./} -> no source markdown named ${slug}.md")
    continue
  fi

  linked=0
  for source_file in "${source_candidates[@]}"; do
    if grep -Eq "Hi-res view:[[:space:]]*\\[SVG\\]\\([^)]*${slug}\\.svg\\)" "$source_file"; then
      linked=1
      break
    fi
  done

  if [ "$linked" -eq 0 ]; then
    orphaned_companions+=("${svg_file#./} -> no matching Hi-res view link in ${source_candidates[*]}")
  fi
done < <(find docs/diagrams -maxdepth 1 -type f -name "*.svg" -print | sort)

if [ "${#missing_companions[@]}" -gt 0 ] || [ "${#orphaned_companions[@]}" -gt 0 ]; then
  echo "SVG companion check failed."
  if [ "${#missing_companions[@]}" -gt 0 ]; then
    echo "Missing SVG companions for docs with ## Diagram Mermaid blocks:"
    printf '  - %s\n' "${missing_companions[@]}"
  fi
  if [ "${#orphaned_companions[@]}" -gt 0 ]; then
    echo "Orphaned SVG companions (no source doc Hi-res view link):"
    printf '  - %s\n' "${orphaned_companions[@]}"
  fi
  exit 1
fi

echo "SVG companion check passed: all ## Diagram Mermaid blocks have companions and no SVG companions are orphaned."
