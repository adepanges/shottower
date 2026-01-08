FROM golang:1.18 AS build
WORKDIR /go/src

# Copy dependency files first for better caching
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source files
COPY go ./go
COPY main.go .

ENV CGO_ENABLED=0

# Build the application
RUN go build -a -installsuffix cgo -o openapi .

FROM scratch AS runtime
COPY --from=build /go/src/openapi ./
EXPOSE 4000/tcp
ENTRYPOINT ["./openapi"]
