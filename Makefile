SHELL := /bin/sh

DOCKER ?= docker
DOCKER_COMPOSE_STACKS ?= kerberos
DOCKER_COMPOSE_FILES := $(foreach stack, $(DOCKER_COMPOSE_STACKS), -f docker-compose.$(stack).yml)
DOCKER_COMPOSE := docker-compose $(DOCKER_COMPOSE_FILES)
DOCKER_NETWORK_NAME ?= local-cluster-kafka

-include ./.env
export

.PHONY: compose/up
compose/up:
	@$(DOCKER) network ls --format '{{ .Name }}' | grep $(DOCKER_NETWORK_NAME) \
	  || $(DOCKER) network create $(DOCKER_NETWORK_NAME)
	@$(DOCKER_COMPOSE) up --remove-orphans --renew-anon-volumes -d --build

.PHONY: compose/rm
compose/rm:
	@$(DOCKER_COMPOSE) rm -fsv
	@$(DOCKER) network rm $(DOCKER_NETWORK_NAME)

.PHONY: compose/logs
compose/logs:
	@$(DOCKER_COMPOSE) logs -f

.PHONY: docker/prune
docker/prune:
	@$(DOCKER) network prune -f
	@$(DOCKER) volume prune -f
