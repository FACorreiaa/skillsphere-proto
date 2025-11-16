.PHONY: lint generate push ontology

GO ?= go
GOFLAGS ?= -mod=mod
ONTOLOGY_TTL ?= ontology/generated.ttl
ONTOLOGY_CONTEXT ?= ontology/generated.context.jsonld

lint: ## Run proto lint checks
	buf lint

generate: ## Generate Go + Connect code
	buf generate

push: ## Push module to Buf Schema Registry
	buf push

ontology: ## Generate ontology artifacts from the latest proto descriptors
	GOFLAGS="$(GOFLAGS)" $(GO) run ./ontology/cmd/generate \
		--module-path=. \
		--out="$(ONTOLOGY_TTL)" \
		--context-out="$(ONTOLOGY_CONTEXT)"
