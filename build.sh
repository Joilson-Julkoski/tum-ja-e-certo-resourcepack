#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

SRC="sounds-src"
OUT="pack/assets/minecraft/sounds/custom"
DIST="dist"
ZIP="$DIST/tum-ja-e-certo.zip"

mkdir -p "$OUT" "$DIST"

# WAV -> mono OGG Vorbis @ 44.1 kHz.
# Mono is required for Minecraft to position block sounds in 3D space.
encode() {
  ffmpeg -y -loglevel error -i "$1" -ac 1 -ar 44100 -c:a libvorbis -q:a 6 "$2"
}

encode "$SRC/tum-1.wav"          "$OUT/tum_1.ogg"
encode "$SRC/tum-2.wav"          "$OUT/tum_2.ogg"
encode "$SRC/tum-ja-e-certo.wav" "$OUT/tum_ja_e_certo.ogg"

# Zip the *contents* of pack/ so pack.mcmeta sits at the archive root.
rm -f "$ZIP"
(cd pack && zip -qrX "../$ZIP" pack.mcmeta assets)

echo "built $ZIP"
