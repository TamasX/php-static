#!/usr/bin/env bash

lando list | grep running &>/dev/null
if [ $? -ne 0 ]; then
  echo "No Lando apps are running — starting Lando..."
  lando start
fi

COMPOSER_GLOBAL_PATH=$(lando composer global config bin-dir --absolute)

#check if cs installed (only check global installation)
PHPCS_GLOBAL_CHECK=$(lando ssh -c "$COMPOSER_GLOBAL_PATH/phpcs --version")

if [[ ! "$PHPCS_GLOBAL_CHECK" == *"PHP_CodeSniffer"* ]]; then
  echo "Installing PHPCS (without modifying composer.json)..."
  lando composer global require squizlabs/php_codesniffer
  lando composer global config --no-interaction allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
  lando composer global require drupal/coder

fi

echo "Running Code Sniffer on changed files:"
lando php $COMPOSER_GLOBAL_PATH/phpcs --standard=Drupal $@
