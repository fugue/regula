BINARY = regula
INSTALLED_BINARY = /usr/local/bin/$(BINARY)
CLI_SOURCE = $(shell find pkg -type f -name '*.go')
REGO_LIB_SOURCE = $(shell find rego/lib -type f -name '*.rego')
REGO_RULES_SOURCE = $(shell find rego/rules -type f -name '*.rego')
GO = GO111MODULE=on go
VERSION = $(shell cat VERSION)
GITCOMMIT = $(shell git rev-parse --short HEAD 2> /dev/null || true)
define LDFLAGS
    -X \"github.com/fugue/regula/cmd.Version=$(VERSION)\" \
    -X \"github.com/fugue/regula/cmd.GitCommit=$(GITCOMMIT)\"
endef
CLI_BUILD = $(GO) build -ldflags="$(LDFLAGS) -s -w"
GOLINT = $(shell go env GOPATH)/bin/golint
COPIED_REGO_LIB = pkg/rego/lib
COPIED_REGO_RULES = pkg/rego/rules

$(COPIED_REGO_LIB): $(REGO_LIB_SOURCE)
	cp -R rego/lib $(COPIED_REGO_LIB)

$(COPIED_REGO_RULES): $(REGO_RULES_SOURCE)
	cp -R rego/rules $(COPIED_REGO_RULES)

$(GOLINT):
	$(GO) get -u golang.org/x/lint/golint

$(BINARY): $(CLI_SOURCE) $(COPIED_REGO_LIB) $(COPIED_REGO_RULES)
	$(CLI_BUILD) -v -o $@

$(BINARY)-linux-amd64: $(SOURCE)
	GOOS=linux GOARCH=amd64 $(CLI_BUILD) -o $@

$(BINARY)-darwin-amd64: $(SOURCE)
	GOOS=darwin GOARCH=amd64 $(CLI_BUILD) -o $@

release: $(BINARY)-linux-amd64 $(BINARY)-darwin-amd64

.PHONY: install
install: $(INSTALLED_BINARY)

.PHONY: clean
clean:
	rm -f coverage.out
	rm -f $(BINARY) $(BINARY)-linux-amd64 $(BINARY)-darwin-amd64

.PHONY: test
test:
	$(GO) test -v -cover ./...

.PHONY: coverage
coverage:
	$(GO) test ./... -coverprofile=coverage.out
	$(GO) tool cover -html=coverage.out

.PHONY: lint
lint:
	$(GOLINT) ./...
	$(GO) vet ./...

.PHONY: printsrc
printsrc:
	@echo $(CLI_SOURCE)
