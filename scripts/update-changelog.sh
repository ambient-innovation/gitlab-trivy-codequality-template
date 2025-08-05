#!/bin/bash

# Script to update both CHANGELOG.md and CHANGELOG-en.md after a release
# Usage: ./update-changelog.sh <version>

set -e

VERSION=${1:-""}

if [ -z "$VERSION" ]; then
    echo "❌ Error: Version parameter required"
    echo "Usage: $0 <version>"
    exit 1
fi

# Function to update a changelog file
update_changelog_file() {
    local changelog_file="$1"
    local temp_file="${changelog_file}.tmp"
    
    if [ ! -f "$changelog_file" ]; then
        echo "❌ Error: $changelog_file not found"
        return 1
    fi

    echo "📝 Updating $changelog_file for released version $VERSION..."

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
        done < "$changelog_file"
        
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
        done < "$changelog_file"
        
    } > "$temp_file"

    # Replace original file
    mv "$temp_file" "$changelog_file"

    echo "✅ $changelog_file updated successfully!"
    echo "📋 Added version [$VERSION] - $RELEASE_DATE"
}

# Update German changelog
update_changelog_file "CHANGELOG.md"

# Update English changelog
update_changelog_file "CHANGELOG-en.md"

echo "🔄 Reset [Unreleased] sections for next development cycle"
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
