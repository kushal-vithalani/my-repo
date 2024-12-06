#!/bin/bash
docker pull 533083429922.dkr.ecr.ap-south-1.amazonaws.com/frontend-image:latest
docker stop frontend-container || true
docker rm frontend-container || true
docker run -d --name frontend-container -p 80:80 533083429922.dkr.ecr.ap-south-1.amazonaws.com/frontend-image:latest

