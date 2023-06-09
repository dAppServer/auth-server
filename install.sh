#!/usr/bin/env bash

docker run --name keycloak_dev -p 8080:8080 \                                                                             ✘ INT  7m 47s  base  16:06:43
        -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin --rm \
        quay.io/keycloak/keycloak:latest \
        start-dev
