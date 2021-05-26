#############
# Variables #
#############

BINARY = bin/regula
INSTALLED_BINARY = /usr/local/bin/regula
GO_SOURCE = $(shell find cmd pkg -type f -name '*.go') $(shell find cmd pkg -type f -name '*.tpl')
CLI_SOURCE = $(GO_SOURCE) $(wildcard cmd/*.txt) go.mod go.sum
MOCKS = $(wildcard pkg/mocks/*.go)
REGO_LIB_SOURCE = $(shell find rego/lib -type f -name '*.rego')
REGO_RULES_SOURCE = $(shell find rego/rules -type f -name '*.rego')
GITCOMMIT = $(shell git rev-parse --short HEAD 2> /dev/null || true)
define LDFLAGS
    -X \"github.com/fugue/regula/pkg/version.Version=$(VERSION)-dev\" \
    -X \"github.com/fugue/regula/pkg/version.GitCommit=$(GITCOMMIT)\"
endef
CLI_BUILD = go build -ldflags="$(LDFLAGS) -s -w"
GO_BIN_DIR= $(shell go env GOPATH)/bin
NEXT_MAJOR = $(shell $(CHANGIE) next major)
NEXT_MINOR = $(shell $(CHANGIE) next minor)
NEXT_PATCH = $(shell $(CHANGIE) next patch)
VERSION = $(shell $(CHANGIE) latest)

#############
#   Tools   #
#############

GOLINT = $(GO_BIN_DIR)/golint
MOCKGEN = $(GO_BIN_DIR)/mockgen
CHANGIE = $(GO_BIN_DIR)/changie
GORELEASER = $(GO_BIN_DIR)/goreleaser

$(GOLINT):
	go install golang.org/x/lint/golint

$(MOCKGEN):
	go install github.com/golang/mock/mockgen@v1.5.0

$(CHANGIE):
	go install github.com/miniscruff/changie@v0.5.0

$(GORELEASER):
	go install github.com/goreleaser/goreleaser@v0.164.0

.PHONY: install_tools
install_tools: $(GOLINT) $(MOCKGEN) $(CHANGIE) $(GORELEASER)

##############
# Dev builds #
##############

$(BINARY): $(CLI_SOURCE) $(REGO_LIB_SOURCE) $(REGO_RULES_SOURCE)
	$(CLI_BUILD) -v -o $@

$(INSTALLED_BINARY): $(BINARY)
	cp $(BINARY) $(INSTALLED_BINARY)

.PHONY: install
install: $(INSTALLED_BINARY)

.PHONY: clean
clean:
	rm -f coverage.out
	rm -f $(BINARY)

.PHONY: test
test:
	go test -v -cover ./...

.PHONY: coverage
coverage:
	go test ./... -coverprofile=coverage.out
	go tool cover -html=coverage.out

.PHONY: lint
lint:
	$(GOLINT) ./...
	go vet ./...

.PHONY: docker
docker: $(CLI_SOURCE) $(REGO_LIB_SOURCE) $(REGO_RULES_SOURCE)
	rm -rf dist
	mkdir -p dist
	GOOS=linux GOARCH=amd64 $(CLI_BUILD) -v -o dist/regula
	cp Dockerfile dist
	cd dist && docker build --tag fugue/regula:dev .

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
	git add changes CHANGELOG.md
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
