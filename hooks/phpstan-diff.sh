#!/bin/bash

function error_exit {
  echo "ERROR: $1" >&2
  exit 69
}

lando list | grep running &>/dev/null
if [ $? -ne 0 ]; then
  echo "No Lando apps are running — starting Lando..."
  lando start
fi

PATH="vendor/bin/"

#check if cs installed
$PHPSTAN_CHECK=$(lando ssh -c "./vendor/bin/phpstan --version")

if [[ ! "$PHPSTAN_CHECK" == *PHPStan* ]]; then
  error_exit "PHPStan is not installed!"
fi

echo "Running PHPStan on changed PHP files..."

echo "Files to analyse: $@"
lando php $PATH/phpstan analyse $@
