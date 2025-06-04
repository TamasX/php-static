#!/usr/bin/env bash

cd php-quality

if ! lando info &>/dev/null; then
  echo "Starting Lando..."
  lando start
fi

FILES=$(git diff --cached --name-only --diff-filter=ACMRT | grep '\.php$' | paste -sd " ")

if [ -n "$FILES" ]; then
  echo "Running Psalm (with security plugin) on changed files: $FILES"
  lando psalm --plugin=psalm/plugin-security $FILES
else
  echo "No changed PHP files to analyze."
fi
