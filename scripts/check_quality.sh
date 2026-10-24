#!/bin/bash

# Code Quality Check Script for switchon_diet
# Run this manually anytime: ./scripts/check_quality.sh

cd "$(dirname "$0")/.." || exit 1

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}   🔍 Switch On Diet - Code Quality Check   ${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

TOTAL_ISSUES=0

# ============================================================
# CHECK 1: Flutter Analyze
# ============================================================
echo -e "${BLUE}📊 CHECK 1: Flutter Analyze${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ANALYZE_OUTPUT=$("${FLUTTER:-flutter}" analyze 2>&1)
ISSUE_COUNT=$(echo "$ANALYZE_OUTPUT" | grep -c " • ")

if [ "$ISSUE_COUNT" -eq 0 ] && echo "$ANALYZE_OUTPUT" | grep -q "No issues found"; then
    echo -e "${GREEN}✅ No issues found${NC}"
else
    echo -e "${RED}❌ flutter analyze reported issues:${NC}"
    echo ""
    echo "$ANALYZE_OUTPUT"
    echo ""
    TOTAL_ISSUES=$((TOTAL_ISSUES + (ISSUE_COUNT > 0 ? ISSUE_COUNT : 1)))
fi

echo ""

# ============================================================
# CHECK 2: File Size Analysis
# ============================================================
echo -e "${BLUE}📏 CHECK 2: File Size Analysis (500 line limit)${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

OVERSIZED_COUNT=0
LARGEST_FILES=""

# Find all Dart files and check their sizes
while IFS= read -r file; do
    LINE_COUNT=$(wc -l < "$file" | tr -d ' ')

    if [ "$LINE_COUNT" -gt 500 ]; then
        OVERSIZED_COUNT=$((OVERSIZED_COUNT + 1))
        LARGEST_FILES="$LARGEST_FILES\n  ${RED}❌${NC} $file: $LINE_COUNT lines"
    elif [ "$LINE_COUNT" -gt 400 ]; then
        LARGEST_FILES="$LARGEST_FILES\n  ${YELLOW}⚠️${NC}  $file: $LINE_COUNT lines (approaching limit)"
    fi
done < <(find lib -name "*.dart" ! -name "*.g.dart" ! -name "*.freezed.dart" -type f)

if [ "$OVERSIZED_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✅ All files under 500 lines${NC}"

    # Show largest files
    if [ -n "$LARGEST_FILES" ]; then
        echo ""
        echo -e "${YELLOW}Files approaching limit (400-500 lines):${NC}"
        echo -e "$LARGEST_FILES"
    fi
else
    echo -e "${RED}❌ $OVERSIZED_COUNT files exceed 500 lines:${NC}"
    echo -e "$LARGEST_FILES"
    TOTAL_ISSUES=$((TOTAL_ISSUES + OVERSIZED_COUNT))
fi

echo ""

# ============================================================
# CHECK 3: Project Statistics
# ============================================================
echo -e "${BLUE}📊 CHECK 3: Project Statistics${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

TOTAL_FILES=$(find lib -name "*.dart" ! -name "*.g.dart" ! -name "*.freezed.dart" | wc -l | tr -d ' ')
TOTAL_LINES=$(find lib -name "*.dart" ! -name "*.g.dart" ! -name "*.freezed.dart" -exec wc -l {} + | tail -1 | awk '{print $1}')
AVG_LINES=$((TOTAL_LINES / TOTAL_FILES))

echo "📁 Total Dart Files: $TOTAL_FILES"
echo "📝 Total Lines: $TOTAL_LINES"
echo "📊 Average Lines per File: $AVG_LINES"

echo ""
echo "Top 10 Largest Files:"
find lib -name "*.dart" ! -name "*.g.dart" ! -name "*.freezed.dart" -exec wc -l {} + | sort -rn | head -11 | tail -10 | while read -r line file; do
    if [ "$line" -gt 500 ]; then
        echo -e "  ${RED}$line${NC} lines: $file"
    elif [ "$line" -gt 400 ]; then
        echo -e "  ${YELLOW}$line${NC} lines: $file"
    else
        echo -e "  ${GREEN}$line${NC} lines: $file"
    fi
done

echo ""

# ============================================================
# CHECK 4: Layer dependency rule
# ============================================================
echo -e "${BLUE}🏗️  CHECK 4: Layer dependency rule${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ARCHITECTURE_ISSUES=0

# Prints the imports in $1 that match the pattern $2, and counts them.
check_imports() {
    local files="$1" pattern="$2" rule="$3"
    local hits
    hits=$(grep -nE "^import '.*($pattern)" $files 2>/dev/null)
    if [ -n "$hits" ]; then
        echo -e "${RED}❌ $rule${NC}"
        echo "$hits" | sed 's/^/    /'
        ARCHITECTURE_ISSUES=$((ARCHITECTURE_ISSUES + $(echo "$hits" | wc -l)))
    fi
}

DOMAIN_FILES=$(find lib/features -path "*/domain/*" -name "*.dart" ! -name "*.freezed.dart")
DATA_FILES=$(find lib/features -path "*/data/*" -name "*.dart" ! -name "*.g.dart" ! -name "*.freezed.dart")
CORE_FILES=$(find lib/core -name "*.dart")

check_imports "$DOMAIN_FILES" "package:flutter/|flutter_riverpod|package:hive|package:http|/data/|/presentation/" \
    "domain must stay pure Dart (no Flutter, Riverpod, Hive, HTTP, data or presentation)"
check_imports "$DATA_FILES" "/presentation/|flutter_riverpod" \
    "data must not depend on presentation or Riverpod"
check_imports "$CORE_FILES" "switchon_diet/features/|switchon_diet/app/" \
    "core must not depend on features or app"

if [ "$ARCHITECTURE_ISSUES" -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies point inwards${NC}"
else
    TOTAL_ISSUES=$((TOTAL_ISSUES + ARCHITECTURE_ISSUES))
fi

echo ""

# ============================================================
# CHECK 5: Code Complexity (Optional)
# ============================================================
echo -e "${BLUE}🔬 CHECK 5: Code Complexity Analysis${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Count classes and functions
TOTAL_CLASSES=$(grep -r "^class " lib --include="*.dart" | wc -l | tr -d ' ')
TOTAL_FUNCTIONS=$(grep -r "^\s*void\|^\s*Future\|^\s*int\|^\s*String\|^\s*bool\|^\s*double" lib --include="*.dart" | grep -c "()" | tr -d ' ')

echo "📦 Total Classes: $TOTAL_CLASSES"
echo "⚙️  Total Functions: $TOTAL_FUNCTIONS"

# Skip complex function analysis for now (AWK compatibility issues)

echo ""

# ============================================================
# SUMMARY
# ============================================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}   📋 SUMMARY   ${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$TOTAL_ISSUES" -eq 0 ]; then
    echo -e "${GREEN}✅ ALL CHECKS PASSED!${NC}"
    echo ""
    echo "Your code meets all quality standards:"
    echo "  ✅ No Flutter analyze issues"
    echo "  ✅ All files under 500 lines"
    echo "  ✅ Layer dependency rule respected"
    echo ""
    echo "You can safely commit your changes!"
else
    echo -e "${RED}❌ FOUND $TOTAL_ISSUES ISSUES${NC}"
    echo ""
    echo "Please fix the issues above before committing."
    echo ""
    echo "Quick fixes:"
    echo "  1. Run: flutter analyze"
    echo "  2. Fix the warnings and split oversized files"
    echo "  3. Re-run: ./scripts/check_quality.sh"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit $TOTAL_ISSUES
