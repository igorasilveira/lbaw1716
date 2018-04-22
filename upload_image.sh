#!/bin/bash

# Stop execution if a step fails
set -e

DOCKER_USERNAME=nadiacarvalho # Replace by your docker hub username
IMAGE_NAME=lbaw1716

# Ensure that dependencies are available
composer install
php artisan clear-compiled
php artisan optimize

docker build -t $DOCKER_USERNAME/$IMAGE_NAME .
# docker run -it -p 8000:80 -e DB_DATABASE=lbaw1716 -e DB_USERNAME=lbaw1716 -e DB_PASSWORD=kr26rq13 --name=lbaw1716 nadiacarvalho/lbaw1716
docker push $DOCKER_USERNAME/$IMAGE_NAME
