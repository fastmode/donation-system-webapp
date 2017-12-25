#!/bin/bash

if [ $(git remote | grep 'staging') != 'staging' ]; then
  git remote add staging https://git.heroku.com/donation-system-staging.git
fi

if [ $(git remote | grep 'production') != 'production' ]; then
  git remote add production https://git.heroku.com/donation-system-production.git
fi
