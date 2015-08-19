#!/usr/bin/env bash
# Stop on error
set -e

if [[ -e /firstrun ]]; then
  source /scripts/first_run.sh
else
  source /scripts/normal_run.sh
fi

run_post_start_action() {
  post_start_action
}

pre_start_action

run_post_start_action &

service hiawatha start

