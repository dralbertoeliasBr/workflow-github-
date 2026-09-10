#!/usr/bin/env bash
set -euo pipefail

# verify.sh - gera checksums SHA256 para arquivos Markdown do manifesto
FILES=(docs/manifesto-GaIA.md docs/R43-D-Commerce-GaIA-Coin.md docs/registro.md)
sha256sum "${FILES[@]}" > checksums.sha256
echo "Checksums gerados em checksums.sha256"
