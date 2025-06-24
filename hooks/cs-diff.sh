#!/usr/bin/env bash

if ! lando info &>/dev/null; then
  echo "Starting Lando..."
  lando start
fi

#check if cs installed
$PHPCS_CHECK=$(lando ssh -c "./vendor/bin/phpcs --version")
if [[ ! "$PHPCS_CHECK" == *PHP_CodeSniffer* ]]; then
lando ssh -c "
  composer require --dev squizlabs/php_codesniffer &&
  composer config --no-interaction allow-plugins.dealerdirect/phpcodesniffer-composer-installer true &&
  composer require --dev drupal/coder
"
fi


# Step 1: Get the list of changed files
FILES=$(git diff --cached --name-only --diff-filter=ACMRT | grep -E '\.(php|module|inc|install|theme|profile)$')

# Step 2: Debug — show what files we found
echo "Files to check: $FILES"

# Step 3: If we have any files, run PHPCS
if [ -n "$FILES" ]; then
  echo "Running Code Sniffer on changed files:"
  lando ssh -c "vendor/bin/phpcs --standard=Drupal $FILES"
else
  echo "No changed PHP files to analyze."
fi