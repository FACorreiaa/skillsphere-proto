.PHONY: lint generate push

lint: ## Run proto lint checks
	buf lint

generate: ## Generate Go + Connect code
	buf generate

push: ## Push module to Buf Schema Registry
	buf push
