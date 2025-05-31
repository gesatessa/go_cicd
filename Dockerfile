# Build ====================================== #
FROM golang:1.23 AS builder

WORKDIR /app

COPY go*.mod ./
RUN go mod download

COPY . .

# Build a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# Prod ======================================= #
FROM gcr.io/distroless/static:nonroot

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/static ./static
COPY --from=builder /app/templates ./templates

EXPOSE 8080

CMD ["./main"]
