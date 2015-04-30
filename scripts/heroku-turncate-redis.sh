#!/bin/bash

heroku addons:remove rediscloud:25 --confirm ducksuite-staging
heroku addons:add rediscloud:25
