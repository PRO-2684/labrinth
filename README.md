# labrinth

[![GitHub License](https://img.shields.io/github/license/PRO-2684/labrinth?logo=opensourceinitiative)](https://github.com/PRO-2684/labrinth/blob/main/LICENSE)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/PRO-2684/labrinth/release.yml?logo=githubactions)](https://github.com/PRO-2684/labrinth/blob/main/.github/workflows/release.yml)
[![GitHub Release](https://img.shields.io/github/v/release/PRO-2684/labrinth?logo=githubactions)](https://github.com/PRO-2684/labrinth/releases)
[![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/PRO-2684/labrinth/total?logo=github)](https://github.com/PRO-2684/labrinth/releases)
[![Crates.io Version](https://img.shields.io/crates/v/labrinth?logo=rust)](https://crates.io/crates/labrinth)
[![Crates.io Total Downloads](https://img.shields.io/crates/d/labrinth?logo=rust)](https://crates.io/crates/labrinth)
[![docs.rs](https://img.shields.io/docsrs/labrinth?logo=rust)](https://docs.rs/labrinth)

Generated Rust client for the Labrinth API

## ⚙️ Automatic Releases Setup

1. [Create a new GitHub repository](https://github.com/new) with the name `labrinth` and push this generated project to it.
2. Enable Actions for the repository, and grant "Read and write permissions" to the workflow [here](https://github.com/PRO-2684/labrinth/settings/actions).
3. [Generate an API token on crates.io](https://crates.io/settings/tokens/new), with the following setup:
    - `Name`: `labrinth`
    - `Expiration`: `No expiration`
    - `Scopes`: `publish-new`, `publish-update`
    - `Crates`: `labrinth`

4. [Add a repository secret](https://github.com/PRO-2684/labrinth/settings/secrets/actions/new) named `CARGO_TOKEN` with the generated token as its value.
5. Consider removing this section and updating this README with your own project information.

[Trusted Publishing](https://crates.io/docs/trusted-publishing) is a recent feature added to crates.io. To utilize it, first make sure you've already successfully published the crate to crates.io. Then, follow these steps:

1. [Add a new trusted publisher](https://crates.io/crates/labrinth/settings/new-trusted-publisher) to your crate.
    - Set "Workflow filename" to `release.yml`.
    - Keep other fields intact.
    - Click "Add".
2. Modify [`release.yml`](.github/workflows/release.yml).
    1. Comment out or remove the `publish-release` job.
    2. Un-comment the `trusted-publishing` job.
3. Remove the `CARGO_TOKEN` [repository secret](https://github.com/PRO-2684/labrinth/settings/secrets/actions).
4. Revoke the API token on [crates.io](https://crates.io/settings/tokens).

## 💡 Examples

TODO

## 📖 Usage

TODO

## 🎉 Credits

TODO
