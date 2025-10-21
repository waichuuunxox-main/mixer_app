#!/usr/bin/env bash
set -euo pipefail
echo "Running flutter pub get"
flutter pub get
echo "Running flutter analyze"
flutter analyze
echo "Running flutter test"
flutter test
