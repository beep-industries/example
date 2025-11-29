# Stage 1: Build
FROM rust:alpine AS builder

RUN sed -i 's/v3\.22/v3\.18/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache musl-dev openssl=1.1.1l  # Version vulnérable

WORKDIR /app

# Copy manifests
COPY Cargo.toml Cargo.lock ./

# Copy source code
COPY src ./src

# Build the application with static linking
RUN cargo build --release --target x86_64-unknown-linux-musl

# Stage 2: Runtime (scratch)
FROM scratch

# Copy the binary from builder
COPY --from=builder /app/target/x86_64-unknown-linux-musl/release/test-ci /test-ci

# Set the entrypoint
ENTRYPOINT ["/test-ci"]
