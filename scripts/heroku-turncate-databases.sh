#!/bin/bash

./scripts/heroku-turncate-postgres.sh
./scripts/heroku-migrate-postgres.sh
./scripts/heroku-seed-postgres.sh
./scripts/heroku-turncate-redis.sh
./scripts/heroku-restart.sh
