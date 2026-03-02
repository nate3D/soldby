#!/bin/bash
# Simple validation script for the SoldBy userscript

echo "=== SoldBy Userscript Validation ==="
echo ""

# Check if the main userscript exists
if [ ! -f "userscript/soldby.user.js" ]; then
    echo "❌ Error: userscript/soldby.user.js not found"
    exit 1
fi

echo "✅ Userscript file found"

# Check JavaScript syntax
echo "Checking JavaScript syntax..."
if command -v node &> /dev/null; then
    if node -c userscript/soldby.user.js 2>&1; then
        echo "✅ JavaScript syntax is valid"
    else
        echo "❌ JavaScript syntax error found"
        exit 1
    fi
else
    echo "⚠️  Node.js not found, skipping syntax check"
fi

# Check for required metadata
echo ""
echo "Checking userscript metadata..."

required_fields=(
    "@name"
    "@version"
    "@description"
    "@match"
    "@grant"
)

for field in "${required_fields[@]}"; do
    if grep -q "// $field" userscript/soldby.user.js; then
        version=$(grep "// $field" userscript/soldby.user.js | head -1)
        echo "✅ $field: $version"
    else
        echo "❌ Missing required field: $field"
        exit 1
    fi
done

# Check version consistency
echo ""
echo "Checking version consistency..."
script_version=$(grep "// @version" userscript/soldby.user.js | head -1 | awk '{print $3}')
changelog_version=$(grep "## \[" CHANGELOG.md | head -1 | sed 's/## \[\([0-9.]*\)\].*/\1/')

if [ "$script_version" == "$changelog_version" ]; then
    echo "✅ Version numbers match: $script_version"
else
    echo "⚠️  Version mismatch - Script: $script_version, Changelog: $changelog_version"
fi

# Check for security issues
echo ""
echo "Checking for potential security issues..."

security_checks=(
    "eval("
    "Function("
    "innerHTML.*="
)

found_issues=0
for check in "${security_checks[@]}"; do
    if grep -q "$check" userscript/soldby.user.js 2>/dev/null; then
        echo "⚠️  Found potentially unsafe pattern: $check"
        found_issues=$((found_issues + 1))
    fi
done

if [ $found_issues -eq 0 ]; then
    echo "✅ No obvious security issues found"
fi

# Summary
echo ""
echo "=== Validation Complete ==="
echo "The userscript appears to be valid and ready for use."
echo ""
echo "To install:"
echo "1. Install Violentmonkey or Tampermonkey browser extension"
echo "2. Visit: https://greasyfork.org/scripts/402064/code/script.user.js"
echo "3. Or load userscript/soldby.user.js directly from file"
