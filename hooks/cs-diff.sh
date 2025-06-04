#!/usr/bin/env bash

cd php-lint

if ! lando info &>/dev/null; then
  echo "Starting Lando..."
  lando start
fi

FILES=$(git diff --cached --name-only --diff-filter=ACMRT | grep '\.php$' | xargs --no-run-if-empty vendor/bin/phpcs --standard=Drupal)

if [ -n "$FILES" ]; then
  echo "Running Code sniffer on changed files: $FILES"
  lando ssh -c $FILES
else
  echo "No changed PHP files to analyze."
fi
