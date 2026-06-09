#!/usr/bin/env bash
set -euo pipefail

EXPECTED_OPENAPI_GENERATOR_VERSION="7.22.0"
DOC_PATH="docs/LABRINTH.md"

fail() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

require_openapi_generator() {
  if ! command -v openapi-generator-cli >/dev/null 2>&1; then
    fail "openapi-generator-cli ${EXPECTED_OPENAPI_GENERATOR_VERSION} must be on PATH. See ${DOC_PATH}."
  fi

  local version
  if ! version="$(openapi-generator-cli version 2>/dev/null)"; then
    fail "could not determine openapi-generator-cli version. Expected ${EXPECTED_OPENAPI_GENERATOR_VERSION}. See ${DOC_PATH}."
  fi

  version="${version//$'\r'/}"

  if [[ "${version}" != "${EXPECTED_OPENAPI_GENERATOR_VERSION}" ]]; then
    fail "openapi-generator-cli version ${version:-unknown} found, expected ${EXPECTED_OPENAPI_GENERATOR_VERSION}. See ${DOC_PATH}."
  fi
}

remove_generated_paths() {
  local path

  for path in "$@"; do
    case "${path}" in
      labrinth/*) ;;
      *) fail "refusing to remove path outside labrinth/: ${path}" ;;
    esac

    if [[ -e "${path}" || -L "${path}" ]]; then
      rm -rf -- "${path}"
    else
      printf 'warning: path does not exist, skipping: %s\n' "${path}" >&2
    fi
  done
}

require_openapi_generator

remove_generated_paths \
  labrinth/src \
  labrinth/Cargo.toml \
  labrinth/README.md

openapi-generator-cli generate \
  --config openapi-generator.yml \
  --global-property 'apis,models,apiDocs=false,modelDocs=false,apiTests=false,modelTests=false,supportingFiles=README.md:Cargo.toml:lib.rs:mod.rs'

remove_generated_paths \
  labrinth/.openapi-generator

cd labrinth
cargo fmt --all
cargo check -p labrinth
