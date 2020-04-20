DOCKER ?= docker
DOCKER_COMPOSE_STACKS ?= kerberos
DOCKER_COMPOSE_FILES := $(foreach stack, $(DOCKER_COMPOSE_STACKS), -f docker-compose.$(stack).yml)
DOCKER_COMPOSE := docker-compose $(DOCKER_COMPOSE_FILES)

-include ./.env
export

-include ./mk.d/docker.mk
-include ./mk.d/kerberos.mk
