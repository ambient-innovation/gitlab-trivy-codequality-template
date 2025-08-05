#!/bin/bash

# Script to update CHANGELOG.md after a release
# Usage: ./update-changelog.sh <version>

set -e

VERSION=${1:-""}
CHANGELOG_FILE="CHANGELOG.md"
TEMP_FILE="changelog_temp.md"

if [ -z "$VERSION" ]; then
    echo "❌ Error: Version parameter required"
    echo "Usage: $0 <version>"
    exit 1
fi

if [ ! -f "$CHANGELOG_FILE" ]; then
    echo "❌ Error: $CHANGELOG_FILE not found"
    exit 1
fi

echo "📝 Updating $CHANGELOG_FILE for released version $VERSION..."

# Get current date in ISO format
RELEASE_DATE=$(date +%Y-%m-%d)

# Create temporary file with updated changelog
{
    # Copy everything until [Unreleased] section
    while IFS= read -r line; do
        echo "$line"
        if [[ "$line" =~ ^\#\#[[:space:]]*\[Unreleased\] ]]; then
            break
        fi
    done < "$CHANGELOG_FILE"
    
    # Add empty Unreleased section
    echo ""
    echo "### Added"
    echo ""
    echo "### Changed"
    echo ""
    echo "### Fixed"
    echo ""
    echo "### Deprecated"
    echo ""
    echo "### Removed"
    echo ""
    echo "### Security"
    echo ""
    echo "## [$VERSION] - $RELEASE_DATE"
    
    # Copy the old [Unreleased] content as the new version
    in_unreleased_section=false
    found_content=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^\#\#[[:space:]]*\[Unreleased\] ]]; then
            in_unreleased_section=true
            continue
        fi
        
        # Start of next version section
        if [[ "$line" =~ ^\#\#[[:space:]]*\[.*\] ]] && [ "$in_unreleased_section" = true ]; then
            in_unreleased_section=false
            found_content=true
            echo "$line"
            continue
        fi
        
        if [ "$in_unreleased_section" = true ]; then
            echo "$line"
        elif [ "$found_content" = true ]; then
            echo "$line"
        fi
    done < "$CHANGELOG_FILE"
    
} > "$TEMP_FILE"

# Replace original file
mv "$TEMP_FILE" "$CHANGELOG_FILE"

echo "✅ Changelog updated successfully!"
echo "📋 Added version [$VERSION] - $RELEASE_DATE"
echo "🔄 Reset [Unreleased] section for next development cycle"
