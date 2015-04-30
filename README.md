# Ducksuite

[![Circle CI](https://circleci.com/gh/woumedia/ducksuite-project.svg?style=svg&circle-token=ce068fdd2eff9474c7862ff4f589665c6aa8281e)](https://circleci.com/gh/woumedia/ducksuite-project)

## Installation

This part is created for mac users. First step is to install postgres:

    brew install postgres
    initdb /usr/local/var/postgres

If postgres DB is installed now you can create databases for project:

    createdb ducksuite_development
    createdb ducksuite_test

Install and run redis DB:

    brew install redis
    redis-server

## Setup

Run migrations and insert initial data:

    bundle exec rake db:setup RAILS_ENV=development
    bundle exec rake db:setup RAILS_ENV=test
    bundle exec rake db:seed

Prepare config file:

    cp config/application.yml.example config/application.yml

## Run

Run rails server:

    bundle exec rails s

Enjoy ducksuite in dev mode (Important don't use 0.0.0.0 as localhost):

    http://localhost:3000

## Deploy

Deploy is done automatically, however if you want to do it manually:

    cap production deploy

You need to have `CAPISTRANO_DUCKSUITE_IP` in your environmental variables.

## Merging

We now have two branches:

    * master
    * staging

If you want to merge your staging changes into master and push them, you can use:

    ./scripts/merge-and-push.sh

Be sure you have no uncommited changes in `staging` branch.

## Heroku

If you want to connect this application with heroku run:

    heroku git:remote -a ducksuite-staging

And then you can use script for resetting databases on heroku:

    ./scripts/heroku-turncate-databases.sh
