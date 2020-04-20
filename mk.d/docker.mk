DOCKER_NETWORK_NAME ?= local-cluster-kafka
DOCKER_KEYTAB_VOLUME ?= local-keytabs-volume

.PHONY: compose/up
compose/up:
	@$(DOCKER) network ls --format '{{ .Name }}' | grep $(DOCKER_NETWORK_NAME) \
	  || $(DOCKER) network create $(DOCKER_NETWORK_NAME)
	@$(DOCKER) network ls --format '{{ .Name }}' | grep $(DOCKER_KEYTAB_VOLUME) \
	  || $(DOCKER) volume create $(DOCKER_KEYTAB_VOLUME)
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
