FROM --platform=${BUILDPLATFORM} golang:alpine AS base 
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* .
RUN go mod download
COPY . .

FROM base AS build
ARG TARGETOS
ARG TARGETARCH
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/example .

FROM base AS unit-test
RUN go test -v .

FROM golangci/golangci-lint AS lint-base

FROM base AS lint
COPY --from=lint-base /usr/bin/golangci-lint /usr/bin/golangci-lint
RUN golangci-lint run --timeout 10m0s ./...

FROM scratch AS bin-unix
COPY --from=build /out/example /

FROM bin-unix AS bin-linux
FROM bin-unix AS bin-darwin

FROM scratch AS bin-windows
COPY --from=build /out/example /example.exe

FROM bin-${TARGETOS} AS bin
