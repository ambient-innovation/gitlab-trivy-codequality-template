# Contributing Guide

## 📝 Release Notes Management

This project uses an automated release notes system based on `CHANGELOG.md`.

### How to Document Changes

1. **All changes** are documented in the `[Unreleased]` section of `CHANGELOG.md`
2. **During release** the `[Unreleased]` section automatically becomes the new version
3. **Release notes** are automatically generated from the changelog

### Changelog Categories

- **Added** - New features
- **Changed** - Changes to existing features
- **Fixed** - Bug fixes
- **Deprecated** - Deprecated features (still available)
- **Removed** - Removed features
- **Security** - Security updates

### Example Workflow

```bash
# 1. Develop new feature
git checkout -b feature/config-merging

# 2. Document changes in CHANGELOG.md
# Add to [Unreleased] > Added:
# - Trivy configuration merging functionality

# 3. Commit code
git commit -m "feat: add trivy configuration merging"

# 4. Commit CHANGELOG update
git commit -m "docs: update CHANGELOG.md for config merging feature"

# 5. Create pull request
# 6. After merge, automatically triggers a release
```

### Release Process

1. **Push to main/master** → Triggers GitHub Action
2. **CalVer version** is automatically generated (YY.MM.DD.MICRO)
3. **Release notes** are extracted from `[Unreleased]`
4. **Templates** are prepared with version-specific URLs
5. **GitHub release** is created
6. **CHANGELOG.md** is prepared for next version

### Manual Release Notes

If the automatic system fails, fallback release notes are created based on Git commits.

### Scripts

- `scripts/extract-release-notes.sh` - Extracts release notes from CHANGELOG.md
- `scripts/update-changelog.sh` - Updates CHANGELOG.md after a release

### Best Practices

- ✅ **Always** document changes in CHANGELOG.md
- ✅ **Use clear** and user-friendly descriptions
- ✅ **Clearly mark** breaking changes
- ❌ **No** technical details in release notes
- ❌ **No** internal code changes documentation (unless they affect users)

### Example CHANGELOG.md Entry

```markdown
## [Unreleased]

### Added
- Automatic merging of Trivy configuration files
- New environment variable `TRIVY_CONFIG_MERGE` for config control
- Version-specific template URLs in releases

### Changed
- Templates now show deprecation warnings when used

### Deprecated
- `config-checks.template.yaml` - Use `trivy-scanning.template.yaml` instead
```
