# Labrinth Client Generation

The `labrinth` crate is a generated Rust client for Modrinth's Labrinth API. It is committed to this repository and is intended to be publishable to crates.io without requiring consumers to install Java, OpenAPI Generator, or any generation tooling.

## Source of truth

The pinned OpenAPI snapshot lives at the repository root:

```text
labrinth.yaml
```

Do not generate directly from Modrinth's live OpenAPI URL. Updating `labrinth.yaml` and regenerating `labrinth/` should be separate, reviewable changes.

To refresh the pinned snapshot manually:

```bash
wget https://github.com/modrinth/code/raw/refs/heads/main/apps/docs/public/openapi.yaml -O labrinth.yaml
```

## Generator

Use [OpenAPI Generator](https://openapi-generator.tech/) with the Rust generator and the repository-owned Cyper template set.

The generation script expects `openapi-generator-cli` version `7.22.0` on `PATH`. It does not download or install the generator automatically.

One installation option is the standalone JAR:

```bash
mkdir -p "$HOME/bin"
wget https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.22.0/openapi-generator-cli-7.22.0.jar \
  -O "$HOME/bin/openapi-generator-cli.jar"
```

Then create an executable wrapper on `PATH`:

```bash
cat >"$HOME/bin/openapi-generator-cli" <<'EOF'
#!/usr/bin/env bash
exec java -jar "$HOME/bin/openapi-generator-cli.jar" "$@"
EOF
chmod +x "$HOME/bin/openapi-generator-cli"
```

The script verifies the exact version before generating. If verification fails, it points back to this document. Install the documented version and rerun the script.

Expected inputs:

```text
labrinth.yaml
openapi-generator.yml
template/
```

Expected output:

```text
labrinth/
```

The generated client should use `cyper` on top of `compio`. The crate exposes async API calls and does not create or own a `compio` runtime.

## Regeneration command

First, **update `packageVersion`** in `openapi-generator.yml`, then run the regeneration script:

```bash
./scripts/generate-labrinth.sh
```

That script does the following:

1. Verifies that `openapi-generator-cli` version `7.22.0` is available on `PATH`, failing with a reference to this document otherwise.
2. Removes only known generated paths under `labrinth/` before generation:
    - `labrinth/src/`
    - `labrinth/Cargo.toml`
    - `labrinth/README.md`
3. Generates from `labrinth.yaml` using `openapi-generator.yml` and `template/`.
4. Removes `.openapi-generator/`, which OpenAPI Generator writes as internal metadata.
5. Runs `cargo fmt --all`.
6. Runs `cargo check -p labrinth`.

The script generates in place. If generation fails, use Git to inspect or restore the generated crate.

## Output hygiene

The generated crate should not include standalone OpenAPI Generator scaffolding:

- `.openapi-generator/`
- `.openapi-generator-ignore`
- generated `.gitignore`
- `.travis.yml`
- `git_push.sh`

The supporting-files whitelist passed by the generation script prevents the latter four files from being emitted. OpenAPI Generator always writes `.openapi-generator/`, so the script removes that metadata directory. Generated endpoint/model Markdown is disabled through the same global properties; API and model descriptions remain available through Rust documentation.

## Package metadata

Package identity should come from generator configuration and templates, not manual edits after generation.

The generated crate should be named `labrinth` and should use Yammm-owned Cargo metadata. The Labrinth OpenAPI version should be recorded separately from the client crate's Cargo version.

## Template boundary

`template/` should be a generic OpenAPI Rust client template set for `cyper`, not a Modrinth-specific template. Labrinth-specific URLs, authentication schemes, headers, and models must come from `labrinth.yaml` and generator configuration.

The optional `clientNamePrefix` generator property controls the root client type. This repository sets it to `Labrinth`, producing `LabrinthClient`; omitting it produces the generic name `Client`. The configured prefix must be a valid Rust type-name fragment.

The client's user agent is configured once as a default header on the underlying `cyper::Client`, which is reused by every operation.

The `library: reqwest` setting is only a compatibility selector required by the stock Rust generator. OpenAPI Generator resolves API templates through that library name, so the Cyper API overrides must live under `template/reqwest/` unless this repository adds a custom Java generator. The templates emit no `reqwest` dependency or code.
