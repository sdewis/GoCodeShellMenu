#!/usr/bin/env bash
# Setup git repo for gocode-shell/gomenu helpers
# Usage:
#   ./git-setup.sh GIT_REMOTE_URL
# where GIT_REMOTE_URL is something like:
#   git@github.com:USERNAME/gocode-shell.git
#   or
#   https://github.com/USERNAME/gocode-shell.git

set -euo pipefail

remote_url="${1:-}"
if [[ -z "$remote_url" ]]; then
  echo "Usage: $0 GIT_REMOTE_URL" >&2
  exit 1
fi

# Ensure we are in the project root
cd "$(dirname "${BASH_SOURCE[0]}")"

# Init repo if not already
if [[ ! -d .git ]]; then
  echo "Initializing git repo..."
  git init
fi

# Add files
echo "Adding project files..."
git add README.md gomenu.bash

# Commit if there is anything to commit
if ! git diff --cached --quiet; then
  echo "Creating initial commit..."
  git commit -m "Initial commit: gocode/gomenu helpers"
else
  echo "No changes to commit."
fi

# Set branch name to main
current_branch="$(git symbolic-ref --short HEAD 2>/dev/null || echo master)"
if [[ "$current_branch" != "main" ]]; then
  echo "Renaming branch $current_branch -> main..."
  git branch -M main
fi

# Configure remote
if git remote get-url origin >/dev/null 2>&1; then
  echo "Updating existing origin remote..."
  git remote set-url origin "$remote_url"
else
  echo "Adding origin remote..."
  git remote add origin "$remote_url"
fi

# Push
echo "Pushing to origin main..."
git push -u origin main

echo "Done."
