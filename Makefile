SERVICE_NAME = $(shell basename $(shell pwd))

info:
    @echo "SERVICE_NAME: $(SERVICE_NAME)"

proto-lint:
    @buf lint

proto-breaking:
    @buf breaking --against 'main'

proto-gen: proto-lint
    @buf generate

proto-push: proto-lint proto-breaking
    @buf push

update:
    go get -u

.PHONY: help info
.PHONY: proto-lint proto-gen proto-push