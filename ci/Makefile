SHELL := /bin/bash

help: ## Help message
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

build: ## Build Docker CI image
	@docker build -t registry.gitlab.com/thorchain/devops/node-launcher:ci -f Dockerfile ../

push: ## Push Docker CI image
	@docker push registry.gitlab.com/thorchain/devops/node-launcher:ci
	@docker inspect --format='{{index .RepoDigests 0}}' registry.gitlab.com/thorchain/devops/node-launcher:ci
