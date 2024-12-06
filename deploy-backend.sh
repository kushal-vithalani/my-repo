#!/bin/bash
docker pull 533083429922.dkr.ecr.ap-south-1.amazonaws.com/backend-image:latest
docker stop backend-container || true
docker rm backend-container || true
docker run -d --name backend-container -p 5000:5000 533083429922.dkr.ecr.ap-south-1.amazonaws.com/backend-image:latest

