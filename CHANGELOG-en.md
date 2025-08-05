# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Calendar Versioning](https://calver.org/) (YY.MM.DD.MICRO).

## [Unreleased]

### Added

### Changed

### Fixed

### Deprecated

### Removed

### Security

## [25.08.05.1] - 2025-08-05

### Added
- Trivy configuration merging: Automatic combination of template configuration with local `trivy.yaml`
- Version consistency: Release templates always reference the correct version of configuration files
- New configuration variables: `TRIVY_CONFIG_MERGE`, `TRIVY_TEMPLATE_CONFIG_URL`, `LOCAL_TRIVY_CONFIG`

### Changed
- All individual templates (`config-checks`, `license-checks`, `security-checks`) are now DEPRECATED
- Templates now show migration warnings when used
- GitHub Action now creates version-specific template files for releases

### Fixed
- Release templates now use correct URLs to their own version instead of `main` branch

### Deprecated
- `config-checks.template.yaml` - Use `trivy-scanning.template.yaml` with `PLUGIN_SEVERITY_MISCONFIG` instead
- `license-checks.template.yaml` - Use `trivy-scanning.template.yaml` with `PLUGIN_SEVERITY_LICENSE` instead  
- `security-checks.template.yaml` - Use `trivy-scanning.template.yaml` with `PLUGIN_SEVERITY_VULN` instead

## Usage

### Using New Features

```yaml
# Simple usage with automatic config merging
trivy-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    # Template automatically loads trivy.template.yaml and merges with local trivy.yaml
```

### Migration from Deprecated Templates

```yaml
# OLD (deprecated):
old-config-scan:
  extends: .config_scanning

# NEW (recommended):
new-config-scan:
  extends: .trivy_scanning
  variables:
    DIRECTORY: "./"
    PLUGIN_SEVERITY_MISCONFIG: "MEDIUM,HIGH,CRITICAL,UNKNOWN"
```

---

## How to Update the Changelog

1. **New features** → `Added` section
2. **Changes** → `Changed` section  
3. **Bug fixes** → `Fixed` section
4. **Deprecated features** → `Deprecated` section
5. **Removed features** → `Removed` section
6. **Security updates** → `Security` section

During a release, the `[Unreleased]` section is automatically renamed to the version number.
