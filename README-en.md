# Trivy Scanner Templates

This repository contains reusable GitLab CI/CD templates for Trivy security scanning.

## 📦 Available Templates

- **`trivy-scanning.template.yaml`** - ✅ **Recommended** Main template for Trivy scans (Image + Filesystem + all scanner types)
- **`config-checks.template.yaml`** - ⚠️ **DEPRECATED** - Use `trivy-scanning.template.yaml` instead
- **`license-checks.template.yaml`** - ⚠️ **DEPRECATED** - Use `trivy-scanning.template.yaml` instead
- **`security-checks.template.yaml`** - ⚠️ **DEPRECATED** - Use `trivy-scanning.template.yaml` instead

### ⚠️ Migration Notice

**IMPORTANT**: The individual template files (`config-checks`, `license-checks`, `security-checks`) are now **DEPRECATED**.

Please migrate to the new unified `trivy-scanning.template.yaml`, which provides:
- Better plugin architecture
- More flexible configuration options  
- Unified scanning approach
- Future-proof design

The deprecated templates will show migration instructions when used.

## 🚀 Usage

### GitLab CI/CD Integration

Include the templates in your `.gitlab-ci.yml`:

```yaml
include:
  - remote: 'https://github.com/mambient-innovation/gitlab-trivy-codequality-template/releases/download/v25.08.05.0/trivy-scanning.template.yaml'

stages:
  - test

# Use the template
trivy-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    PLUGIN_SEVERITY: "HIGH,CRITICAL"
```

### Template Configuration

The main template `trivy-scanning.template.yaml` supports the following variables:

#### Basic Configuration
- `IMAGE`: Docker image to scan (optional)
- `DIRECTORY`: Directory for filesystem scan (default: "./")
- `FILENAME`: Name of the CodeQuality output file (default: "gl-codeclimate-$CI_JOB_NAME_SLUG.json")

#### Trivy Configuration (NEW! 🎉)
- `TRIVY_CONFIG_MERGE`: Enable/disable configuration file merging (default: "true")
- `TRIVY_TEMPLATE_CONFIG_URL`: URL to template configuration file (default: GitHub Repository)
- `LOCAL_TRIVY_CONFIG`: Path to local Trivy configuration (default: "trivy.yaml")
- `MERGED_TRIVY_CONFIG`: Path to merged configuration file

The template automatically downloads a `trivy.template.yaml` from the repository and combines it with a local `trivy.yaml` if present. Local configuration overrides template settings.

#### Plugin Options
- `PLUGIN_SEVERITY`: Severity levels (e.g., "HIGH,CRITICAL")
- `PLUGIN_SEVERITY_LICENSE`: Severity for license issues
- `PLUGIN_SEVERITY_VULN`: Severity for vulnerabilities
- `PLUGIN_SEVERITY_MISCONFIG`: Severity for misconfigurations
- `PLUGIN_SEVERITY_SECRET`: Severity for secrets
- `PLUGIN_PKG_TYPES`: Package types to scan
- `PLUGIN_DEBUG`: Enable debug mode
- `PLUGIN_TABLE`: Show table output for results

### Example Configurations

#### With Custom Trivy Configuration (🎯 Recommended)
```yaml
# 1. Download trivy.template.yaml (one-time):
# curl -o trivy.yaml https://github.com/mambient-innovation/gitlab-trivy-codequality-template/releases/download/v25.08.05.0/trivy.template.yaml

# 2. Customize trivy.yaml according to your needs

# 3. Use the template:
trivy-full-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    # Local trivy.yaml will be automatically merged with template configuration
```

#### Simple Scan Without Local Configuration
```yaml
trivy-simple-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    PLUGIN_SEVERITY: "HIGH,CRITICAL"
```

#### Disable Configuration Merging
```yaml
trivy-no-merge:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    TRIVY_CONFIG_MERGE: "false"  # Disables config merging
    PLUGIN_SEVERITY: "HIGH,CRITICAL"
```

#### Image-Only Scan
```yaml
trivy-image-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "registry.example.com/my-app:$CI_COMMIT_SHA"
    PLUGIN_SEVERITY: "HIGH,CRITICAL"
```

#### Filesystem-Only Scan
```yaml
trivy-fs-scan:
  extends: .trivy_scanning
  variables:
    DIRECTORY: "./src"
    PLUGIN_SEVERITY: "MEDIUM,HIGH,CRITICAL"
```

#### Configuration Checks Only (⚠️formerly config-checks - not recommended⚠️)
```yaml
trivy-config-scan:
  extends: .trivy_scanning
  variables:
    DIRECTORY: "./"
    PLUGIN_SEVERITY_MISCONFIG: "MEDIUM,HIGH,CRITICAL,UNKNOWN"
    PLUGIN_PKG_TYPES_MISCONFIG: "all"
```

#### License Checks Only (⚠️formerly license-checks - not recommended⚠️)
```yaml
trivy-license-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    PLUGIN_SEVERITY_LICENSE: "HIGH,CRITICAL,UNKNOWN"
    PLUGIN_PKG_TYPES_LICENSE: "library,os"
```

#### Security Checks Only (⚠️formerly security-checks - not recommended⚠️)
```yaml
trivy-security-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    PLUGIN_SEVERITY_VULN: "HIGH,CRITICAL"
    PLUGIN_SEVERITY_MISCONFIG: "HIGH,CRITICAL"
    PLUGIN_PKG_TYPES_VULN: "os,library"
```

## 🔄 Versioning

This project uses Calendar Versioning (CalVer) in the format `YY.MM.DD.MICRO`:

- **YY**: Year (e.g., 24 for 2024)
- **MM**: Month (01-12)
- **DD**: Day (01-31)
- **MICRO**: Daily version (0, 1, 2, ...)

### 🎯 Version Consistency

**Important**: Each release ensures that all template files are consistent:

- The `trivy-scanning.template.yaml` of a release **always** references the `trivy.template.yaml` from **the same release**
- No dependencies on `main` branch files in released templates
- Guaranteed compatibility between template and configuration files

```yaml
# ✅ Recommended: Use specific version
include:
  - remote: 'https://github.com/mambient-innovation/gitlab-trivy-codequality-template/releases/download/v25.08.05.0/trivy-scanning.template.yaml'

# ⚠️ Caution: Latest may contain breaking changes
include:
  - remote: 'https://github.com/mambient-innovation/gitlab-trivy-codequality-template/releases/download/v25.08.05.0/trivy-scanning.template.yaml'
```

### Automatic Releases

Releases are automatically created when:
- Changes to template files are pushed
- Manually triggered via GitHub Actions

### Using the Latest Version

Find the latest version under [Releases](../../releases/latest).

Example for using the latest version:
```yaml
include:
  - remote: 'https://github.com/mambient-innovation/gitlab-trivy-codequality-template/releases/download/v25.08.05.0/trivy-scanning.template.yaml'
```

## 🛠️ Development

### Release Notes System

This project uses an automated release notes system:

- **📝 CHANGELOG.md** - All changes are documented in the `[Unreleased]` section
- **🤖 Automatic Extraction** - Release notes are automatically generated from the changelog
- **🔄 Auto-Update** - After a release, the changelog is prepared for the next version

See [CONTRIBUTING-en.md](CONTRIBUTING-en.md) for workflow details.

### Local Testing

1. Clone repository
2. Make changes to templates
3. **Important**: Document changes in `CHANGELOG.md`
4. Commit and push triggers automatic release

### Manual Release

A release can be manually triggered via GitHub Actions:

1. Go to "Actions" → "Create Release with CalVer"
2. Click "Run workflow"
3. Select branch and set "Force create release" if needed

## 📋 Requirements

- GitLab CI/CD
- Trivy Scanner (automatically installed)
- `jq` for JSON processing (automatically installed)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Create a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see [LICENSE](LICENSE) for details.

## 🔗 Links

- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [GitLab CI/CD Templates](https://docs.gitlab.com/ee/ci/yaml/includes.html)
- [Trivy GitLab CodeQuality Plugin](https://github.com/ambient-innovation/trivy-plugin-gitlab-codequality)
