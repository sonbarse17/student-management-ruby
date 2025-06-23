#!/bin/bash
set -e

# Run database migrations
bundle exec rails db:migrate

# Start the Rails server
exec "$@"
