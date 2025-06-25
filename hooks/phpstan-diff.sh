#!/bin/bash

# Check if Lando is running
if ! lando info &>/dev/null; then
  echo "Lando is not running. Starting Lando..."
  lando start
fi

PATH="vendor/bin"

echo "Running PHPStan on changed PHP files..."

# Find changed PHP files in the commit
FILES=$(git diff --cached --name-only --diff-filter=ACMRT |  grep -E '\.(php|module|inc|install|theme|profile)$' | paste -sd " ")

if [ -n "$FILES" ]; then
  echo "Files to analyse: $FILES"
  cd "$(git rev-parse --show-toplevel)"
  lando php $PATH/phpstan analyse  $FILES
else
  echo "No changed PHP files found to analyse."
fi