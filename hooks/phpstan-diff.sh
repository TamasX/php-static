#!/bin/bash

# Check if Lando is running
if ! lando info &>/dev/null; then
  echo "Lando is not running. Starting Lando..."
  lando start
fi

echo "Running PHPStan on changed PHP files..."

# Find changed PHP files in the commit
FILES=$(git diff --cached --name-only --diff-filter=ACMRT | grep '\.php$' | paste -sd " ")

if [ -n "$FILES" ]; then
  echo "Files to analyse: $FILES"
  lando phpstan analyse $FILES
else
  echo "No changed PHP files found to analyse."
fi
