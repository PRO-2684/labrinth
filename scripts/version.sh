#!/bin/bash

# If no arguments are passed, print the version
if [ $# -eq 0 ]; then
    # Exit with git's exit code
    git describe --tags --abbrev=0
    exit $?
fi

# If more than one argument is passed, print an error message
if [ $# -gt 1 ]; then
    echo "Error: Too many arguments"
    exit 1
fi

# Otherwise, set the version
version=$1
# Check if the version is valid
if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format. Use X.Y.Z"
    exit 1
fi
# Check if the version already exists
if git tag | grep -q "v$version"; then
    echo "Error: Version $version already exists"
    exit 1
fi
# Check if the version matches Cargo.toml (version = "...")
if ! grep -q "version = \"$version\"" labrinth/Cargo.toml; then
    echo "Error: Version $version does not match Cargo.toml"
    echo "Consider updating openapi-generator.yml and regenerating first"
    echo "See docs/DEV-NOTES.md for more information"
    exit 1
fi
# Create a new tag
git tag -s v$version -m "Version $version"
echo "Tag created: v$version"
