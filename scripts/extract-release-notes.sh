#!/bin/bash

# Script to extract bilingual release notes from CHANGELOG.md and CHANGELOG-en.md
# Usage: ./extract-release-notes.sh <version> [repository]

set -e

VERSION=${1:-""}
REPOSITORY=${2:-""}
CHANGELOG_DE="CHANGELOG.md"
CHANGELOG_EN="CHANGELOG-en.md"
OUTPUT_FILE="release_notes.md"

if [ -z "$VERSION" ]; then
    echo "❌ Error: Version parameter required"
    echo "Usage: $0 <version> [repository]"
    exit 1
fi

if [ -z "$REPOSITORY" ]; then
    echo "❌ Error: Repository parameter required"
    echo "Usage: $0 <version> [repository]"
    echo "Example: $0 25.08.05.0 mastacheata/gitlab-codequality-trivy"
    exit 1
fi

if [ ! -f "$CHANGELOG_DE" ]; then
    echo "❌ Error: $CHANGELOG_DE not found"
    exit 1
fi

if [ ! -f "$CHANGELOG_EN" ]; then
    echo "❌ Error: $CHANGELOG_EN not found"
    exit 1
fi

echo "📝 Extracting bilingual release notes for version $VERSION..."
echo "🔗 Repository: $REPOSITORY"

# Function to extract unreleased content from a changelog
extract_unreleased_content() {
    local changelog_file="$1"
    local temp_file="$2"
    
    in_unreleased_section=false
    found_content=false
    
    while IFS= read -r line; do
        # Start of Unreleased section
        if [[ "$line" =~ ^\#\#[[:space:]]*\[Unreleased\] ]]; then
            in_unreleased_section=true
            continue
        fi
        
        # Start of next version section (end of Unreleased)
        if [[ "$line" =~ ^\#\#[[:space:]]*\[.*\] ]] && [ "$in_unreleased_section" = true ]; then
            break
        fi
        
        # Stop at Usage, How to Update, or similar documentation sections
        if [[ "$line" =~ ^\#\#[[:space:]]*(Usage|Verwendung|How[[:space:]]to[[:space:]]Update|Wie[[:space:]]man[[:space:]]das[[:space:]]Changelog) ]] && [ "$in_unreleased_section" = true ]; then
            break
        fi
        
        # If we're in the unreleased section, capture content
        if [ "$in_unreleased_section" = true ]; then
            # Skip empty lines at the beginning
            if [ "$found_content" = false ] && [ -z "$(echo "$line" | xargs)" ]; then
                continue
            fi
            
            found_content=true
            echo "$line" >> "$temp_file"
        fi
    done < "$changelog_file"
    
    return 0
}

# Create release notes header
cat > "$OUTPUT_FILE" << EOF
# Release v$VERSION

EOF

# Extract German content
echo "🇩🇪 Extracting German release notes..."
TEMP_DE="temp_de.md"
extract_unreleased_content "$CHANGELOG_DE" "$TEMP_DE"

# Extract English content  
echo "🇬🇧 Extracting English release notes..."
TEMP_EN="temp_en.md"
extract_unreleased_content "$CHANGELOG_EN" "$TEMP_EN"

# Check if we have content in both files
if [ -s "$TEMP_DE" ] && [ -s "$TEMP_EN" ]; then
    echo "📝 Creating bilingual release notes..."
    
    # Add German section
    cat >> "$OUTPUT_FILE" << EOF
## 🇩🇪 Was ist neu (Deutsch)

EOF
    cat "$TEMP_DE" >> "$OUTPUT_FILE"
    
    # Add English section
    cat >> "$OUTPUT_FILE" << EOF

## 🇬🇧 What's New (English)

EOF
    cat "$TEMP_EN" >> "$OUTPUT_FILE"
    
elif [ -s "$TEMP_DE" ]; then
    echo "📝 Creating German-only release notes..."
    cat "$TEMP_DE" >> "$OUTPUT_FILE"
    
elif [ -s "$TEMP_EN" ]; then
    echo "📝 Creating English-only release notes..."
    cat "$TEMP_EN" >> "$OUTPUT_FILE"
    
else
    echo "⚠️ No content found in either changelog, creating minimal release notes..."
    cat >> "$OUTPUT_FILE" << EOF
## Changes

- Updated Trivy scanning templates

EOF
fi

# Add template files section
cat >> "$OUTPUT_FILE" << EOF

## 📦 Template Files

This release includes the following template files:

- \`trivy-scanning.template.yaml\` (🔍 **Scanning workflow template**)
- \`trivy.template.yaml\` (📋 **Configuration template**)

## 🚀 Usage

\`\`\`yaml
include:
  - remote: 'https://github.com/$REPOSITORY/releases/download/v$VERSION/trivy-scanning.template.yaml'
\`\`\`

## 🔗 Direct Download Links

- [trivy-scanning.template.yaml](https://github.com/$REPOSITORY/releases/download/v$VERSION/trivy-scanning.template.yaml) (🔍 **Recommended**)
- [trivy.template.yaml](https://github.com/$REPOSITORY/releases/download/v$VERSION/trivy.template.yaml) (📋 **Configuration**)
- [config-checks.template.yaml](https://github.com/$REPOSITORY/releases/download/v$VERSION/config-checks.template.yaml) (⚠️ **Deprecated**)
- [license-checks.template.yaml](https://github.com/$REPOSITORY/releases/download/v$VERSION/license-checks.template.yaml) (⚠️ **Deprecated**)
- [security-checks.template.yaml](https://github.com/$REPOSITORY/releases/download/v$VERSION/security-checks.template.yaml) (⚠️ **Deprecated**)

EOF

# Clean up temporary files
rm -f "$TEMP_DE" "$TEMP_EN"

echo "✅ Release notes created: $OUTPUT_FILE"

# Show preview
echo ""
echo "📋 Release Notes Preview:"
echo "========================"
cat "$OUTPUT_FILE"
