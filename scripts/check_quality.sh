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

if flutter analyze > /tmp/flutter_analyze_check.txt 2>&1; then
    ISSUE_COUNT=$(grep -E "issue.*found" /tmp/flutter_analyze_check.txt | grep -o '[0-9]\+' | head -1)

    if [ -z "$ISSUE_COUNT" ] || [ "$ISSUE_COUNT" -eq 0 ]; then
        echo -e "${GREEN}✅ No issues found${NC}"
    else
        echo -e "${RED}❌ Found $ISSUE_COUNT issues:${NC}"
        echo ""
        cat /tmp/flutter_analyze_check.txt
        echo ""
        TOTAL_ISSUES=$((TOTAL_ISSUES + ISSUE_COUNT))
    fi
else
    echo -e "${RED}❌ Flutter analyze failed${NC}"
    cat /tmp/flutter_analyze_check.txt
    TOTAL_ISSUES=$((TOTAL_ISSUES + 1))
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
done < <(find lib -name "*.dart" -type f)

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

TOTAL_FILES=$(find lib -name "*.dart" | wc -l | tr -d ' ')
TOTAL_LINES=$(find lib -name "*.dart" -exec wc -l {} + | tail -1 | awk '{print $1}')
AVG_LINES=$((TOTAL_LINES / TOTAL_FILES))

echo "📁 Total Dart Files: $TOTAL_FILES"
echo "📝 Total Lines: $TOTAL_LINES"
echo "📊 Average Lines per File: $AVG_LINES"

echo ""
echo "Top 10 Largest Files:"
find lib -name "*.dart" -exec wc -l {} + | sort -rn | head -11 | tail -10 | while read -r line count file; do
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
# CHECK 4: Clean Architecture Validation
# ============================================================
echo -e "${BLUE}🏗️  CHECK 4: Clean Architecture Validation${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

ARCHITECTURE_ISSUES=0

# Check for widgets not in proper folders
while IFS= read -r file; do
    if [[ "$file" == lib/*.dart ]] && [[ "$file" != lib/main.dart ]]; then
        # Check if it's in a proper subfolder
        if [[ "$file" != lib/models/* ]] && [[ "$file" != lib/services/* ]] && \
           [[ "$file" != lib/screens/* ]] && [[ "$file" != lib/constants/* ]] && \
           [[ "$file" != lib/utils/* ]]; then

            # Check if it's a widget
            if grep -q "class.*extends.*Widget" "$file"; then
                echo -e "${YELLOW}⚠️  Widget in root: $file${NC}"
                ARCHITECTURE_ISSUES=$((ARCHITECTURE_ISSUES + 1))
            fi
        fi
    fi
done < <(find lib -name "*.dart" -type f)

# Check for large screen files without widget subfolders
while IFS= read -r file; do
    LINE_COUNT=$(wc -l < "$file" | tr -d ' ')

    if [ "$LINE_COUNT" -gt 300 ]; then
        DIR=$(dirname "$file")
        BASENAME=$(basename "$file" .dart)
        WIDGET_DIR="$DIR/widgets"

        if [ ! -d "$WIDGET_DIR" ] && grep -q "StatefulWidget\|StatelessWidget" "$file"; then
            echo -e "${YELLOW}⚠️  Large screen without widgets/: $file ($LINE_COUNT lines)${NC}"
            ARCHITECTURE_ISSUES=$((ARCHITECTURE_ISSUES + 1))
        fi
    fi
done < <(find lib/screens -name "*.dart" -type f 2>/dev/null)

if [ "$ARCHITECTURE_ISSUES" -eq 0 ]; then
    echo -e "${GREEN}✅ Clean Architecture principles followed${NC}"
else
    echo ""
    echo -e "${YELLOW}💡 Suggestions:${NC}"
    echo "   - Move widgets to lib/screens/*/widgets/"
    echo "   - Extract large widgets into separate files"
    echo "   - Follow the folder structure in docs/CODING_GUIDELINES.md"
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
    echo "  ✅ Clean Architecture principles followed"
    echo ""
    echo "You can safely commit your changes!"
else
    echo -e "${RED}❌ FOUND $TOTAL_ISSUES ISSUES${NC}"
    echo ""
    echo "Please fix the issues above before committing."
    echo ""
    echo "Quick fixes:"
    echo "  1. Run: flutter analyze"
    echo "  2. Fix the warnings and split oversized files (see docs/CODING_GUIDELINES.md)"
    echo "  3. Re-run: ./check_quality.sh"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit $TOTAL_ISSUES
