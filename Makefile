#############
# Variables #
#############

GO_SOURCE = $(shell find cmd pkg -type f -name '*.go') $(shell find cmd pkg -type f -name '*.tmpl')
CLI_SOURCE = $(GO_SOURCE) $(wildcard cmd/*.txt) go.mod go.sum
MOCKS = $(wildcard pkg/mocks/*.go)
REGO_LIB_SOURCE = $(shell find rego/lib -type f -name '*.rego')
REGO_RULES_SOURCE = $(shell find rego/rules -type f -name '*.rego')
GITCOMMIT = $(shell git rev-parse --short HEAD 2> /dev/null || true)
BUILD_TYPE ?= dev
define LDFLAGS
    -X \"github.com/fugue/regula/pkg/version.Version=$(VERSION)-$(BUILD_TYPE)\" \
    -X \"github.com/fugue/regula/pkg/version.GitCommit=$(GITCOMMIT)\"
endef
CLI_BUILD = go build -ldflags="$(LDFLAGS) -s -w"
GO_BIN_DIR= $(shell go env GOPATH)/bin
NEXT_MAJOR = $(shell $(CHANGIE) next major)
NEXT_MINOR = $(shell $(CHANGIE) next minor)
NEXT_PATCH = $(shell $(CHANGIE) next patch)
VERSION = $(shell $(CHANGIE) latest)

# Executables
GO ?= go
DOCKER ?= docker
GOLINT ?= $(GO_BIN_DIR)/golint
MOCKGEN ?= $(GO_BIN_DIR)/mockgen
CHANGIE ?= $(GO_BIN_DIR)/changie
GORELEASER ?= $(GO_BIN_DIR)/goreleaser

# Internal targets
BINARY = bin/regula
INSTALLED_BINARY = /usr/local/bin/regula
REMEDIATION_LINKS = rego/remediation.yaml

YQ = $(DOCKER) run --rm -v $(shell pwd):/workdir mikefarah/yq:4

.PHONY: binary
binary: ## Build regula binary
binary: $(BINARY)

# https://gist.github.com/prwhite/8168133#gistcomment-3456785
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##############
#   Swagger  #
##############

SWAGGER_URL=https://api.riskmanager.fugue.co/v0/swagger
SWAGGER=swagger.yaml

$(SWAGGER):
	wget -q -O $@ $(SWAGGER_URL)

.PHONY: swagger_gen
swagger_gen: ## Regenerate go-swagger bindings
swagger_gen: $(SWAGGER)
	mkdir -p pkg/swagger
	$(DOCKER) run --rm -it \
    	--volume $(shell pwd):/regula \
    	--user $(shell id -u):$(shell id -g) \
    	--workdir /regula \
    	quay.io/goswagger/swagger:v0.23.0 \
    	generate client -t pkg/swagger -f "$(SWAGGER)"

#############
#   Tools   #
#############

$(GOLINT):
	$(GO) install golang.org/x/lint/golint

$(MOCKGEN):
	$(GO) install github.com/golang/mock/mockgen@v1.5.0

$(CHANGIE):
	$(GO) install github.com/miniscruff/changie@v0.5.0

$(GORELEASER):
	$(GO) install github.com/goreleaser/goreleaser@v0.164.0

.PHONY: install_tools
install_tools: ## Download and install golint, mockgen, changie, and goreleaser
install_tools: $(GOLINT) $(MOCKGEN) $(CHANGIE) $(GORELEASER)

##############
# Dev builds #
##############

$(BINARY): $(CLI_SOURCE) $(REGO_LIB_SOURCE) $(REGO_RULES_SOURCE) $(REMEDIATION_LINKS)
	$(CLI_BUILD) -v -o $@

$(INSTALLED_BINARY): $(BINARY)
	install -m 0655 $(BINARY) $(INSTALLED_BINARY)

.PHONY: install
install: ## Install regula
install: $(INSTALLED_BINARY)

.PHONY: clean
clean: ## Delete generated files
	rm -f coverage.out
	rm -f $(BINARY)

.PHONY: test
test: ## Run test suite
test:
	$(GO) test -v -cover ./...

.PHONY: coverage
coverage: ## Run coverage analysis
	$(GO) test ./... -coverprofile=coverage.out
	$(GO) tool cover -html=coverage.out

.PHONY: lint
lint: ## Run the `go vet` linter
	$(GOLINT) ./...
	$(GO) vet ./...

.PHONY: docker
docker: ## Build Docker container
docker: $(CLI_SOURCE) $(REGO_LIB_SOURCE) $(REGO_RULES_SOURCE)
	rm -rf dist
	mkdir -p dist
	GOOS=linux GOARCH=amd64 $(CLI_BUILD) -v -o dist/regula
	cp Dockerfile dist
	cd dist && $(DOCKER) build --tag fugue/regula:dev .

################################
#   Remediation documentation  #
################################

.PHONY: remediation
remediation: ## Regenerate remediation links
remediation: rules/remediation.yaml

$(REMEDIATION_LINKS):
	curl -s "https://docs.fugue.co/remediation.html" | grep -Eo 'FG_R[0-9]+' | sort -u | awk '{ print $$1 ":\n  url: https://docs.fugue.co/" $$1 ".html" }' > "$@"

#####################
# Release processes #
#####################

.PHONY: change
change: $(CHANGIE)
	$(CHANGIE) new

define bump_rule
.PHONY: bump_$(1)_version
bump_$(1)_version: $$(CHANGIE)
	$$(CHANGIE) batch $(2)
	$$(CHANGIE) merge
	$$(YQ) eval --inplace '.extra.version = "$(2)"' ./mkdocs.yml
	git add changes CHANGELOG.md mkdocs.yml
	@echo "Run the following to complete the release:"
	@echo "    git commit -m 'Bump version to $(2)'"
	@echo "    git tag -a -F changes/$(2).md $(2)"
	@echo "    git push origin master $(2)"
endef

$(eval $(call bump_rule,major,$(NEXT_MAJOR)))
$(eval $(call bump_rule,minor,$(NEXT_MINOR)))
$(eval $(call bump_rule,patch,$(NEXT_PATCH)))

.PHONY: list_next_versions
list_next_versions:
	@echo "The current version is: $(VERSION)"
	@echo "The next patch version would be: $(NEXT_PATCH)"
	@echo "The next minor version would be: $(NEXT_MINOR)"
	@echo "The next major version would be: $(NEXT_MAJOR)"

# Only intended to be run as part of release automations to accommodate release
# candidates. Use the bump_* targets to prepare for an official release.
changes/%.md:
	$(CHANGIE) batch $*
