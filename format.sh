#!/usr/bin/env bash

# Make script stop when an error happens
set -e

python -m black src setup.py main.py clean.py update_readme.py tests examples
