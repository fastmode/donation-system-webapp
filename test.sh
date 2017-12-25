#!/bin/bash

. credentials/.deploy
. credentials/.email_server
. credentials/.env_test
bundle exec rake
