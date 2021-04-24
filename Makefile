BINARY = regula
INSTALLED_BINARY = /usr/local/bin/$(BINARY)
CLI_SOURCE = $(call rwildcard,./pkg,*.go)
REGO_SOURCE = $(call rwildcard,./rego/lib,*.rego) $(call rwildcard,./rego/rules,*.rego)
GO = GO111MODULE=on go
VERSION = $(shell cat VERSION)
GITCOMMIT = $(shell git rev-parse --short HEAD 2> /dev/null || true)
define LDFLAGS
    -X \"github.com/fugue/regula/cmd.Version=$(VERSION)\" \
    -X \"github.com/fugue/regula/cmd.GitCommit=$(GITCOMMIT)\"
endef
CLI_BUILD = $(GO) build -ldflags="$(LDFLAGS) -s -w"
GOLINT = $(shell go env GOPATH)/bin/golint

$(GOLINT):
	$(GO) get -u golang.org/x/lint/golint

$(BINARY): $(REGO_SOURCE) $(CLI_SOURCE)
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

# https://stackoverflow.com/questions/2483182/recursive-wildcards-in-gnu-make
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))
