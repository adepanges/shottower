FROM golang:1.21 AS build
WORKDIR /app

# Copy all project files
COPY . .

# Download dependencies
RUN go mod download

# Build the application
ENV CGO_ENABLED=0
RUN go build -a -installsuffix cgo -o openapi .

FROM alpine:3.18
RUN apk add --no-cache ffmpeg gifski
WORKDIR /root/

# Copy the compiled binary from build stage
COPY --from=build /app/openapi .

EXPOSE 4000/tcp
ENTRYPOINT ["./openapi"]
