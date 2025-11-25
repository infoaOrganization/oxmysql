#!/bin/sh

set -e

cd "$(dirname "$0")"

pnpm install --frozen-lockfile
pnpm build
