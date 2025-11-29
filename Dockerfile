# Stage 1: Build avec Debian
FROM debian:bullseye AS builder
# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    musl-tools \
    libssl-dev=1.1.1n-0+deb11u4  # Version vulnérable à CVE-2022-0778
WORKDIR /app
# Installer Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
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
