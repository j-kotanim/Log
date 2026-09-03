#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <input.md> [output.pdf]" >&2
  exit 1
fi

input_md="$1"
if [[ ! -f "$input_md" ]]; then
  echo "Input file not found: $input_md" >&2
  exit 1
fi

if [[ "$input_md" != *.md ]]; then
  echo "Input must be a .md file: $input_md" >&2
  exit 1
fi

input_abs="$(realpath "$input_md")"
default_output="${input_abs%.md}.pdf"
output_pdf="${2:-$default_output}"
output_abs="$(realpath -m "$output_pdf")"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
stylesheet="$script_dir/md2pdf.css"

if ! command -v npx >/dev/null 2>&1; then
  echo "npx is required but not found." >&2
  exit 1
fi

npx --yes md-to-pdf "$input_abs" \
  --stylesheet "$stylesheet" \
  --marked-options '{"gfm":true,"headerIds":false,"mangle":false}' \
  --launch-options '{"args":["--no-sandbox","--disable-setuid-sandbox"]}' \
  --pdf-options "$(cat <<'JSON'
{"format":"A4","printBackground":true,"displayHeaderFooter":true,"margin":{"top":"20mm","right":"15mm","bottom":"18mm","left":"15mm"},"headerTemplate":"<div></div>","footerTemplate":"<div style=\"font-size:9px;width:100%;text-align:center;color:#666;\"><span class=\"pageNumber\"></span> / <span class=\"totalPages\"></span></div>"}
JSON
)"

if [[ "$output_abs" != "$default_output" ]]; then
  mv "$default_output" "$output_abs"
fi

echo "Generated: $output_abs"
