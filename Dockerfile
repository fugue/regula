FROM golang:1.16-alpine as builder
ARG version
ARG gitcommit
WORKDIR /build
COPY . .
ENV ldflags "-X \"github.com/fugue/regula/cmd.Version=${version}\" -X \"github.com/fugue/regula/cmd.GitCommit=${gitcommit}\""
RUN go build -ldflags="${ldflags} -s -w"

FROM alpine:latest
COPY --from=builder /build/regula /usr/local/bin
ENTRYPOINT [ "regula" ]
