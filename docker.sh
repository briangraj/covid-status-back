#!/bin/bash
# build
docker build -t

# postgres
docker run -d \
	--name dev-postgres \
	-e POSTGRES_PASSWORD=Pass2020 \
	-v ~/postgres-volume/:/var/lib/postgresql/data \
	-p 5432:5432 \
	--network cs-net \
  postgres

# csb
docker run -d \
  --name dev-csb \
  --env-file .env.development \
	-v ~/csb-dataset/:/myapp/dataset \
  -p 8080:8080 \
	--network cs-net \
  briangraj/csb:latest
