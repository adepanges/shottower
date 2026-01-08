FROM golang:1.18 AS build
WORKDIR /app

# Copy all project files
COPY . .

# Download dependencies
RUN go mod download

# Build the application
ENV CGO_ENABLED=0
RUN go build -a -installsuffix cgo -o openapi .

FROM scratch AS runtime
COPY --from=build /app/openapi ./
EXPOSE 4000/tcp
ENTRYPOINT ["./openapi"]
