BINARY = regula
INSTALLED_BINARY = /usr/local/bin/$(BINARY)
GO_SOURCE = $(shell find cmd pkg -type f -name '*.go')
CLI_SOURCE = $(GO_SOURCE) $(wildcard cmd/*.txt) go.mod go.sum
# MOCKS_SOURCE = $(shell grep -L 'go:generate mockgen' $(GO_SOURCE))
MOCKS = $(wildcard pkg/mocks/*.go)
REGO_LIB_SOURCE = $(shell find rego/lib -type f -name '*.rego')
REGO_RULES_SOURCE = $(shell find rego/rules -type f -name '*.rego')
VERSION = $(shell cat VERSION)
GITCOMMIT = $(shell git rev-parse --short HEAD 2> /dev/null || true)
define LDFLAGS
    -X \"github.com/fugue/regula/cmd.Version=$(VERSION)\" \
    -X \"github.com/fugue/regula/cmd.GitCommit=$(GITCOMMIT)\"
endef
CLI_BUILD = go build -ldflags="$(LDFLAGS) -s -w"
GO_BIN_DIR= $(shell go env GOPATH)/bin
GOLINT = $(GO_BIN_DIR)/golint
MOCKGEN = $(GO_BIN_DIR)/mockgen
COPIED_REGO_LIB = pkg/rego/lib
COPIED_REGO_RULES = pkg/rego/rules

$(COPIED_REGO_LIB): $(REGO_LIB_SOURCE)
	cp -R rego/lib $(COPIED_REGO_LIB)

$(COPIED_REGO_RULES): $(REGO_RULES_SOURCE)
	cp -R rego/rules $(COPIED_REGO_RULES)

$(GOLINT):
	go install golang.org/x/lint/golint

$(MOCKGEN):
	go install github.com/golang/mock/mockgen@v1.5.0

$(BINARY): $(CLI_SOURCE) $(COPIED_REGO_LIB) $(COPIED_REGO_RULES)
	$(CLI_BUILD) -v -o $@

$(BINARY)-linux-amd64: $(SOURCE)
	GOOS=linux GOARCH=amd64 $(CLI_BUILD) -o $@

$(BINARY)-darwin-amd64: $(SOURCE)
	GOOS=darwin GOARCH=amd64 $(CLI_BUILD) -o $@

$(INSTALLED_BINARY): $(BINARY)
	cp $(BINARY) $(INSTALLED_BINARY)

# $(MOCKS): $(MOCKGEN) $(MOCKS_SOURCE)
# 	PATH=$(GO_BIN_DIR):$(PATH) go generate ./...

release: $(BINARY)-linux-amd64 $(BINARY)-darwin-amd64

.PHONY: install
install: $(INSTALLED_BINARY)

# .PHONY: mocks
# mocks: $(MOCKS)

.PHONY: clean
clean:
	rm -f coverage.out
	rm -f $(BINARY) $(BINARY)-linux-amd64 $(BINARY)-darwin-amd64

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

.PHONY: printsrc
printsrc:
	@echo $(CLI_SOURCE)
