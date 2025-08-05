#!/bin/bash

# Script to extract release notes from CHANGELOG.md
# Usage: ./extract-release-notes.sh <version>

set -e

VERSION=${1:-""}
CHANGELOG_FILE="CHANGELOG.md"
OUTPUT_FILE="release_notes.md"

if [ -z "$VERSION" ]; then
    echo "❌ Error: Version parameter required"
    echo "Usage: $0 <version>"
    exit 1
fi

if [ ! -f "$CHANGELOG_FILE" ]; then
    echo "❌ Error: $CHANGELOG_FILE not found"
    exit 1
fi

echo "📝 Extracting release notes for version $VERSION from $CHANGELOG_FILE..."

# Create release notes header
cat > "$OUTPUT_FILE" << EOF
# Release v$VERSION

## What's New

EOF

# Extract the [Unreleased] section from CHANGELOG.md
# This assumes the changelog follows the Keep a Changelog format
in_unreleased_section=false
in_content=false

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
    
    # Skip until we find content after the Unreleased header
    if [ "$in_unreleased_section" = true ]; then
        # Skip empty lines right after the header
        if [[ -z "$line" ]] && [ "$in_content" = false ]; then
            continue
        fi
        
        # We found content
        if [[ -n "$line" ]]; then
            in_content=true
        fi
        
        # Add content to release notes
        if [ "$in_content" = true ]; then
            echo "$line" >> "$OUTPUT_FILE"
        fi
    fi
done < "$CHANGELOG_FILE"

# Add template files section
cat >> "$OUTPUT_FILE" << EOF

## 📦 Template Files

This release includes the following template files:

- \`trivy-scanning.template.yaml\` (✅ **Recommended**)
- \`trivy.template.yaml\` (📋 **Configuration template**)
- \`config-checks.template.yaml\` (⚠️ **Deprecated** - migrate to trivy-scanning.template.yaml)
- \`license-checks.template.yaml\` (⚠️ **Deprecated** - migrate to trivy-scanning.template.yaml)
- \`security-checks.template.yaml\` (⚠️ **Deprecated** - migrate to trivy-scanning.template.yaml)

## 🎯 Version Consistency

This release ensures **version consistency** by:
- The \`trivy-scanning.template.yaml\` in this release references the \`trivy.template.yaml\` from **this same release**
- No dependency on main branch files when using released templates
- Guaranteed compatibility between template and configuration files

## 🚀 Usage

Include these templates in your GitLab CI/CD pipeline:

\`\`\`yaml
include:
  - remote: 'https://github.com/\${GITHUB_REPOSITORY}/releases/download/v$VERSION/trivy-scanning.template.yaml'

# Optional: Download trivy configuration template
# curl -o trivy.yaml https://github.com/\${GITHUB_REPOSITORY}/releases/download/v$VERSION/trivy.template.yaml
\`\`\`

## 🔗 Direct Download Links

- [trivy-scanning.template.yaml](https://github.com/\${GITHUB_REPOSITORY}/releases/download/v$VERSION/trivy-scanning.template.yaml) (✅ Recommended)
- [trivy.template.yaml](https://github.com/\${GITHUB_REPOSITORY}/releases/download/v$VERSION/trivy.template.yaml) (📋 Configuration)
- [config-checks.template.yaml](https://github.com/\${GITHUB_REPOSITORY}/releases/download/v$VERSION/config-checks.template.yaml) (⚠️ Deprecated)
- [license-checks.template.yaml](https://github.com/\${GITHUB_REPOSITORY}/releases/download/v$VERSION/license-checks.template.yaml) (⚠️ Deprecated)
- [security-checks.template.yaml](https://github.com/\${GITHUB_REPOSITORY}/releases/download/v$VERSION/security-checks.template.yaml) (⚠️ Deprecated)
EOF

echo "✅ Release notes generated: $OUTPUT_FILE"
echo ""
echo "📋 Preview:"
echo "----------------------------------------"
head -20 "$OUTPUT_FILE"
echo "..."
echo "----------------------------------------"
