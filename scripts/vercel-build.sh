#!/usr/bin/env bash
set -euo pipefail

# Pin the SDK used to develop this app (Dart 3.12.2). Vercel's generic
# static-site build must provision Flutter before compiling Dart sources.
sdk_version="3.44.2"
sdk_commit="c9a6c484230f8b5e408ec57be1ef71dee1e77020"
sdk_dir="${PORTFOLIO_FLUTTER_SDK:-$PWD/.vercel/flutter-$sdk_version}"

if [[ ! -x "$sdk_dir/bin/flutter" ]]; then
  git clone --quiet --depth 1 --branch "$sdk_version" \
    https://github.com/flutter/flutter.git "$sdk_dir"
fi

if [[ "$(git -C "$sdk_dir" rev-parse HEAD)" != "$sdk_commit" ]]; then
  echo "Expected Flutter $sdk_version at commit $sdk_commit." >&2
  exit 1
fi

export PATH="$sdk_dir/bin:$PATH"
flutter config --no-analytics --enable-web
flutter --version
flutter pub get
flutter build web --release --no-web-resources-cdn --no-wasm-dry-run

# Prevent a successful deployment that has no compiled Flutter application.
test -s build/web/index.html
test -s build/web/flutter_bootstrap.js
test -s build/web/main.dart.js
