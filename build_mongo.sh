#! /bin/bash

cd /home/web/classifAI/resources # area with dockerfile and docker-compose for mongo

# Build the Docker image using the Dockerfile in the current directory
# Giving it a tag name "mongo_custom" for reference
docker build -t mongo_custom .

# Now, using docker-compose to run the containers as defined in your docker-compose.yml file
# This assumes you have a docker-compose.yml in the same directory
docker-compose up -d
