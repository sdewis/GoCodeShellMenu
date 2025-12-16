#!/usr/bin/env bash
# Installer for gocode/gomenu helpers
# This script lets the user pick a base folder for code projects and
# installs the gocode + gomenu functions into their shell rc.

set -euo pipefail

# Detect shell and rc file
shell_name="${SHELL##*/}"
case "$shell_name" in
  zsh)  rc_file="$HOME/.zshrc" ;;
  bash) rc_file="$HOME/.bashrc" ;;
  *)    rc_file="$HOME/.bashrc" ;;
esac

echo "Detected shell: $shell_name"
echo "Shell config file: $rc_file"

# Ask for base folder
default_root="$HOME/Documents/CodeFolder"
read -r -p "Code projects root [$default_root]: " root
root="${root:-$default_root}"

# Expand ~ if present
case "$root" in
  ~*) root="$HOME${root#~}" ;;
esac

# Normalize to absolute path
if [[ "$root" != /* ]]; then
  root="$PWD/$root"
fi

mkdir -p "$root"
echo "Using code root: $root"

# Load gomenu function body from local file
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -f "$script_dir/gomenu.bash" ]]; then
  echo "Error: gomenu.bash not found next to installer." >&2
  exit 1
fi

gomenu_src="$(<"$script_dir/gomenu.bash")"

# Escape forward slashes for sed
esc_root="${root//\//\/}"

# Replace the hard-coded root in gomenu.bash
gomenu_src="${gomenu_src//\$HOME\/Documents\/CodeFolder/$esc_root}"

echo
echo "Installing functions into: $rc_file"
echo

{
  echo ""
  echo "# >>> gocode/gomenu (installed by GoCodeShellMenu) >>>"
  echo "gocode() {"
  echo "  cd \"$root\" || { printf 'gocode: cannot cd to %s\\n' \"$root\" >&2; return 1; }"
  echo "}"
  echo ""
  printf '%s\n' "$gomenu_src"
  echo "# <<< gocode/gomenu (installed by GoCodeShellMenu) <<<"
} >>"$rc_file"

echo "Done. Restart your shell or run:"
echo "  source \"$rc_file\""
echo "Then use:"
echo "  gocode"
echo "  gomenu"
