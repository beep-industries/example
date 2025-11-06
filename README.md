# Rust Service Template Repository

This repository serves as a template for all future Rust services, with standardized CI/CD configuration and pre-commit hooks.

---

## GitHub Workflows

The repository uses two main workflows that reuse centralized workflows from the [beep-industries/actions](https://github.com/beep-industries/actions) repository:

### 1. CI on main branch

Triggers automatically on every push to `main`:

```yaml
on:
  push:
    branches:
      - main
```

**How it works**: This workflow calls the reusable `rust-build-push-main.yml` workflow from the central repository, which:
- Compiles the Rust application
- Builds the Docker image
- Pushes the image with the `latest` tag to the registry

**Reference**: See [build-push-main.yml](.github/workflows/build-push-main.yml)

### 2. Release on tag

Triggers automatically when creating a tag with semantic versioning format:

```yaml
on:
  push:
    tags:
      - "*.*.*"
```

**How it works**: This workflow calls the reusable `rust-build-push-tag.yml` workflow from the central repository, which:
- Compiles the Rust application
- Builds the Docker image
- Pushes the image with the corresponding version tag (e.g., `1.0.0`)

**Reference**: See [build-push-tag.yml](.github/workflows/build-push-tag.yml)

---

## How to Create and Push a Tag

To trigger a release build:

```bash
# 1. Create a tag locally (semantic versioning format)
git tag 1.0.0

# 2. Push the tag to the remote repository
git push origin 1.0.0

# Alternative: Create and push in a single command
git tag 1.0.0 && git push origin 1.0.0
```

**Important**: The tag format must follow the `*.*.*` pattern (semantic versioning) to trigger the workflow.

### Useful Tag Commands

```bash
# List all tags
git tag -l

# Delete a local tag
git tag -d 1.0.0

# Delete a remote tag
git push origin --delete 1.0.0

# Create an annotated tag with message
git tag -a 1.0.0 -m "Release version 1.0.0"
```

---

## Pre-commit Configuration

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file configures hooks that run automatically before each commit to ensure code quality.

### Configured Hooks

The hooks come from the central [beep-industries/actions](https://github.com/beep-industries/actions) repository (version `0.0.2`):

```yaml
repos:
- repo: https://github.com/beep-industries/actions
  rev: 0.0.2
  hooks:
    - id: fmt           # Rust code formatting (cargo fmt)
    - id: cargo-check   # Compilation check
    - id: clippy        # Rust linter to detect common errors
```

**Reference**: See [.pre-commit-config.yaml](.pre-commit-config.yaml)

### Installation

First, install pre-commit following the [official installation guide](https://pre-commit.com/#install).

Then, install the hooks in your repository:

```bash
pre-commit install
```

### Usage

The hooks run automatically before each `git commit`. To run them manually:

```bash
# Run on all files
pre-commit run --all-files

# Run on staged files only
pre-commit run

# Run a specific hook
pre-commit run fmt
pre-commit run clippy
```