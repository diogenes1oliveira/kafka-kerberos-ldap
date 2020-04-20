KERBEROS_CMD_PREFIX := $(DOCKER_COMPOSE) exec kerberos-client
export

.PHONY: keytab/create
keytab/create:
	@test -n $(SERVICE)
	@./scripts/create-keytab.sh \
		-s $(SERVICE) \
		-P $(KADMIN_PASSWORD) \
		-p $(KADMIN_PASSWORD)
