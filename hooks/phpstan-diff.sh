#!/bin/bash

# Check if Lando is running
if ! lando info &>/dev/null; then
  echo "Lando is not running. Starting Lando..."
  lando start
fi

PATH="vendor/bin/"

#check if cs installed
$PHPSTAN_CHECK=$(lando ssh -c "./vendor/bin/phpstan --version")

if [[ ! "$PHPSTAN_CHECK" == *PHPStan* ]]; then
  echo "Installing PHPSTAN (without modifying composer.json)..."
  lando composer global require phpstan/phpstan
  PATH=$(lando composer global config bin-dir --absolute)
fi

echo "Running PHPStan on changed PHP files..."

# Find changed PHP files in the commit
FILES=$(git diff --cached --name-only --diff-filter=ACMRT | grep '\.php$' | paste -sd " ")

if [ -n "$FILES" ]; then
  echo "Files to analyse: $FILES"
  lando php $PATH/phpstan analyse $FILES
else
  echo "No changed PHP files found to analyse."
fi
