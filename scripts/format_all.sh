#!/bin/bash

# Formats every Dart file under lib/ (80-column limit).

cd "$(dirname "$0")/.." || exit 1

echo "🎨 Formatting all Dart files (80 character line limit)..."

# dart format with 80 character line length
dart format --line-length 80 lib/

echo "✅ Formatting complete!"
echo ""
echo "Files formatted to 80 characters per line."
echo "Run 'flutter analyze' to check for any remaining issues."
